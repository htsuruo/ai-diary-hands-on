# 第11章 ハンズオン仕様書: Genkit で AI エージェント実装

## 概要

本章では、AI エージェントの概念を理解し、自律的にタスクを実行するマルチエージェントシステムを Genkit で実装します。日記の内容を深く理解するため、Web 検索で関連情報を収集するリサーチエージェントを構築します。

## 前提条件

### 環境

- 第9章、第10章のハンズオンが完了していること
- Tavily API キー（Web 検索用）
- Genkit の基礎知識

### 読者の知識レベル

- Genkit の Flow と Tool の概念
- RAG の基礎知識（第10章）
- マルチステップワークフローの理解

### 必要なパッケージ・サービス

- Tavily API（Web 検索）
- Genkit MCP（Model Context Protocol）プラグイン（オプション）

## アプリの完成イメージ

### 機能概要

#### 日記リサーチエージェント

ユーザーの日記に登場するトピックについて、自律的に Web 検索を行い、関連情報を収集・分析して提供します。

### ユーザー体験フロー

1. ユーザーが日記詳細画面で「詳しく調べる」ボタンをタップ
2. AI エージェントが起動（バックグラウンド）
   - Planning: 調査計画を立案
   - Research: Web 検索で情報収集
   - Reflection: 情報の分析と知識ギャップの特定
   - Refinement: 調査内容を洗練
3. 調査結果が表示される（進捗も表示）
4. ユーザーは調査結果を読んで日記の内容をより深く理解できる

### エージェントの自律的な動作例

**日記:**「今日は量子コンピュータについての記事を読んだ。すごい技術だと思った」

**エージェントの動作:**

1. **Planning**:「量子コンピュータの基本概念、最新動向、実用例を調査する」
2. **Research**: Web 検索で以下を調査
   - 「量子コンピュータとは」
   - 「量子コンピュータ最新ニュース 2025」
   - 「量子コンピュータ実用例」
3. **Reflection**:「基礎は理解できたが、具体的な企業の取り組みが不足」
4. **Research（追加）**:「Google 量子コンピュータ」「IBM 量子コンピュータ」
5. **Refinement**: 情報を整理して分かりやすくまとめる

## 実装範囲

### 10.1 AI エージェントとは

このセクションは理論的な説明が中心です。

#### 学習内容

- AI エージェントの定義
- 単純な LLM 呼び出しとの違い
- エージェントの3つの特徴:
  1. 自律性（Autonomy）
  2. ツール利用（Tool Use）
  3. 計画能力（Planning）

### 10.2 Genkit における エージェントの構成要素

このセクションも主に理論的な説明です。

#### 学習内容

- エージェントのアーキテクチャ
- Plan → Execute → Reflect のサイクル
- マルチエージェントシステムの設計パターン

### 10.3 エージェントの手足 - ツールの準備

#### 実装内容

##### 10.3.1 Tavily API のセットアップ

**Tavily とは:**
AI エージェント向けの Web 検索 API。Google 検索よりも構造化された結果を返します。

**API キーの取得:**

1. [Tavily](https://tavily.com/) にアクセス
2. アカウント作成
3. API キーを取得（無料プランで月1000リクエスト）

**環境変数の設定:**
`functions/.env` に追加:

```
TAVILY_API_KEY=tvly-xxxxxxxxxxxxxxxx
```

##### 10.3.2 Web 検索ツールの実装

**src/tools/webSearch.ts の作成:**

```typescript
import { defineTool } from '@genkit-ai/core';
import { z } from 'zod';
import axios from 'axios';

interface TavilySearchResult {
  title: string;
  url: string;
  content: string;
  score: number;
}

interface TavilyResponse {
  results: TavilySearchResult[];
}

export const webSearchTool = defineTool(
  {
    name: 'webSearch',
    description: `
Web 検索を実行し、関連情報を取得します。
調査したいトピックについて最新の情報や詳細を知りたいときに使用してください。
    `,
    inputSchema: z.object({
      query: z.string().describe('検索クエリ'),
      maxResults: z.number().default(5).describe('取得する最大結果数'),
    }),
    outputSchema: z.array(
      z.object({
        title: z.string(),
        url: z.string(),
        content: z.string(),
        score: z.number(),
      })
    ),
  },
  async (input) => {
    try {
      const response = await axios.post<TavilyResponse>(
        'https://api.tavily.com/search',
        {
          api_key: process.env.TAVILY_API_KEY,
          query: input.query,
          max_results: input.maxResults,
          search_depth: 'advanced',
          include_answer: false,
        }
      );

      return response.data.results;
    } catch (error) {
      console.error('Web search failed:', error);
      throw new Error('Web 検索に失敗しました');
    }
  }
);
```

**依存関係の追加:**

```bash
cd functions
npm install axios
```

##### 10.3.3 ツールのテスト

**Genkit Dev UI でのテスト:**

1. Dev UI を起動
2. Tools タブで `webSearch` を選択
3. Input に検索クエリを入力:

   ```json
   {
     "query": "量子コンピュータとは",
     "maxResults": 3
   }
   ```

4. 実行して検索結果が返ることを確認

### 10.4 エージェントの頭脳 - フローの構築

#### 実装内容

##### 10.4.1 Planning エージェントの実装

**src/agents/planningAgent.ts の作成:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { gemini20FlashExp } from '@genkit-ai/googleai';
import { z } from 'zod';

const PlanSchema = z.object({
  topic: z.string().describe('調査するトピック'),
  queries: z.array(z.string()).describe('実行すべき検索クエリのリスト'),
  reasoning: z.string().describe('この計画を立てた理由'),
});

export const planningAgent = defineFlow(
  {
    name: 'planningAgent',
    inputSchema: z.object({
      diaryContent: z.string(),
    }),
    outputSchema: PlanSchema,
  },
  async (input) => {
    const prompt = `
あなたは調査計画を立案するエージェントです。
ユーザーの日記を読んで、深く理解するために調査すべきトピックと検索クエリを提案してください。

# 日記
${input.diaryContent}

# 指示
1. 日記に登場する主要なトピックを特定
2. そのトピックについて調査すべき3〜5個の検索クエリを考案
3. なぜその調査が有益かを説明

検索クエリは具体的で、最新情報が得られるものにしてください。
    `;

    const result = await gemini20FlashExp.generate({
      prompt,
      config: {
        temperature: 0.7,
        responseSchema: PlanSchema,
        responseMimeType: 'application/json',
      },
    });

    return JSON.parse(result.text);
  }
);
```

##### 10.4.2 Research エージェントの実装

**src/agents/researchAgent.ts の作成:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { webSearchTool } from '../tools/webSearch';
import { z } from 'zod';

const ResearchResultSchema = z.object({
  query: z.string(),
  findings: z.array(
    z.object({
      title: z.string(),
      url: z.string(),
      summary: z.string(),
    })
  ),
});

export const researchAgent = defineFlow(
  {
    name: 'researchAgent',
    inputSchema: z.object({
      queries: z.array(z.string()),
    }),
    outputSchema: z.array(ResearchResultSchema),
  },
  async (input) => {
    const results = [];

    for (const query of input.queries) {
      // Web 検索を実行
      const searchResults = await webSearchTool({
        query,
        maxResults: 3,
      });

      results.push({
        query,
        findings: searchResults.map((result) => ({
          title: result.title,
          url: result.url,
          summary: result.content,
        })),
      });
    }

    return results;
  }
);
```

##### 10.4.3 Reflection エージェントの実装

**src/agents/reflectionAgent.ts の作成:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { gemini20FlashExp } from '@genkit-ai/googleai';
import { z } from 'zod';

const ReflectionSchema = z.object({
  summary: z.string().describe('収集した情報の要約'),
  gaps: z.array(z.string()).describe('不足している情報や調査すべき点'),
  additionalQueries: z.array(z.string()).describe('追加で実行すべき検索クエリ'),
});

export const reflectionAgent = defineFlow(
  {
    name: 'reflectionAgent',
    inputSchema: z.object({
      originalTopic: z.string(),
      researchResults: z.array(z.any()),
    }),
    outputSchema: ReflectionSchema,
  },
  async (input) => {
    const researchSummary = input.researchResults
      .map((result) => {
        const findingsText = result.findings
          .map((f: any) => `- ${f.title}: ${f.summary}`)
          .join('\n');
        return `【${result.query}】\n${findingsText}`;
      })
      .join('\n\n');

    const prompt = `
あなたは内省的な分析エージェントです。
収集した情報を分析し、知識のギャップを特定してください。

# 元のトピック
${input.originalTopic}

# 収集した情報
${researchSummary}

# 指示
1. 収集した情報を簡潔に要約
2. まだ不足している情報や調査すべき点を特定
3. 追加で実行すべき検索クエリを提案（0〜3個）

もし十分な情報が集まっている場合は、追加クエリは空の配列にしてください。
    `;

    const result = await gemini20FlashExp.generate({
      prompt,
      config: {
        temperature: 0.7,
        responseSchema: ReflectionSchema,
        responseMimeType: 'application/json',
      },
    });

    return JSON.parse(result.text);
  }
);
```

##### 10.4.4 Refinement エージェントの実装

**src/agents/refinementAgent.ts の作成:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { gemini20FlashExp } from '@genkit-ai/googleai';
import { z } from 'zod';

export const refinementAgent = defineFlow(
  {
    name: 'refinementAgent',
    inputSchema: z.object({
      originalDiary: z.string(),
      researchResults: z.array(z.any()),
      reflection: z.object({
        summary: z.string(),
        gaps: z.array(z.string()),
      }),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    const researchSummary = input.researchResults
      .map((result) => {
        const findingsText = result.findings
          .map((f: any) => `- ${f.title}\n  ${f.summary}\n  参照: ${f.url}`)
          .join('\n');
        return `## ${result.query}\n${findingsText}`;
      })
      .join('\n\n');

    const prompt = `
あなたはリサーチ結果をまとめるエージェントです。
ユーザーの日記と収集した情報を統合し、分かりやすいレポートを作成してください。

# ユーザーの日記
${input.originalDiary}

# 調査結果
${researchSummary}

# 分析サマリー
${input.reflection.summary}

# 指示
以下の構成でレポートを作成してください:

1. **概要**: 日記のトピックについての簡潔な説明
2. **調査結果**: 収集した情報を分かりやすく整理
3. **関連リンク**: 参考になる URL
4. **まとめ**: 日記の内容と調査結果の関連性

読みやすく、有益な情報を提供してください。
    `;

    const result = await gemini20FlashExp.generate({
      prompt,
      config: {
        temperature: 0.7,
      },
    });

    return result.text;
  }
);
```

### 10.5 マルチエージェントの統合

#### 実装内容

##### 10.5.1 オーケストレーションフローの実装

**src/flows/research-agent-flow.ts の作成:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { onFlow } from '@genkit-ai/firebase/functions';
import { z } from 'zod';
import { planningAgent } from '../agents/planningAgent';
import { researchAgent } from '../agents/researchAgent';
import { reflectionAgent } from '../agents/reflectionAgent';
import { refinementAgent } from '../agents/refinementAgent';

export const researchAgentFlow = onFlow(
  {
    name: 'researchAgentFlow',
    inputSchema: z.object({
      diaryContent: z.string(),
    }),
    outputSchema: z.object({
      report: z.string(),
      sources: z.array(
        z.object({
          title: z.string(),
          url: z.string(),
        })
      ),
    }),
  },
  async (input) => {
    // Step 1: Planning - 調査計画を立案
    const plan = await planningAgent({
      diaryContent: input.diaryContent,
    });

    console.log('Plan created:', plan);

    // Step 2: Research - 初回調査
    let researchResults = await researchAgent({
      queries: plan.queries,
    });

    console.log('Initial research completed');

    // Step 3: Reflection - 情報分析と追加調査の判断
    const reflection = await reflectionAgent({
      originalTopic: plan.topic,
      researchResults,
    });

    console.log('Reflection:', reflection);

    // Step 4: Additional Research（必要な場合）
    if (reflection.additionalQueries.length > 0) {
      const additionalResults = await researchAgent({
        queries: reflection.additionalQueries,
      });

      researchResults = [...researchResults, ...additionalResults];
      console.log('Additional research completed');
    }

    // Step 5: Refinement - 最終レポート作成
    const report = await refinementAgent({
      originalDiary: input.diaryContent,
      researchResults,
      reflection: {
        summary: reflection.summary,
        gaps: reflection.gaps,
      },
    });

    // ソースの抽出
    const sources = researchResults.flatMap((result) =>
      result.findings.map((finding: any) => ({
        title: finding.title,
        url: finding.url,
      }))
    );

    return {
      report,
      sources,
    };
  }
);
```

**index.ts への追加:**

```typescript
export * from './flows/research-agent-flow';
```

##### 10.5.2 Genkit Dev UI でのテスト

**テスト手順:**

1. Dev UI を起動
2. `researchAgentFlow` を選択
3. Input に日記を入力:

   ```json
   {
     "diaryContent": "今日は量子コンピュータについての記事を読んだ。すごい技術だと思った。実用化はまだ先のようだが、将来が楽しみだ。"
   }
   ```

4. 実行
5. Trace で各エージェントの動作を確認:
   - Planning: 検索クエリの計画
   - Research: Web 検索の実行
   - Reflection: 追加調査の判断
   - Refinement: レポート作成

### 10.6 Flutter アプリとの連携

#### 実装内容

##### 10.6.1 リサーチ機能の UI 実装

**日記詳細画面に「詳しく調べる」ボタンを追加:**

```dart
class DiaryDetailScreen extends StatefulWidget {
  // ...
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final _functions = FirebaseFunctions.instance;
  String? _researchReport;
  List<ResearchSource>? _sources;
  bool _isResearching = false;

  Future<void> _conductResearch() async {
    setState(() => _isResearching = true);

    try {
      final callable = _functions.httpsCallable('researchAgentFlow');
      final result = await callable.call({
        'data': {
          'diaryContent': widget.diary.content,
        },
      });

      final data = result.data['result'];
      setState(() {
        _researchReport = data['report'] as String;
        _sources = (data['sources'] as List)
            .map((s) => ResearchSource(
                  title: s['title'] as String,
                  url: s['url'] as String,
                ))
            .toList();
      });

      // 結果画面に遷移
      _showResearchResult();
    } catch (e) {
      _showError('調査に失敗しました: $e');
    } finally {
      setState(() => _isResearching = false);
    }
  }

  void _showResearchResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResearchResultScreen(
          report: _researchReport!,
          sources: _sources!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日記詳細'),
      ),
      body: Column(
        children: [
          // 日記内容の表示
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(widget.diary.content),
            ),
          ),

          // 詳しく調べるボタン
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _isResearching ? null : _conductResearch,
              icon: _isResearching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(
                _isResearching ? '調査中...' : '詳しく調べる',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class ResearchSource {
  final String title;
  final String url;

  ResearchSource({
    required this.title,
    required this.url,
  });
}
```

##### 10.6.2 調査結果画面の実装

**lib/screens/research_result_screen.dart の作成:**

```dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResearchResultScreen extends StatelessWidget {
  final String report;
  final List<ResearchSource> sources;

  const ResearchResultScreen({
    super.key,
    required this.report,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('調査結果'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // レポート
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '調査レポート',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(report),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 参考ソース
          Text(
            '参考ソース',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          ...sources.map((source) => Card(
                child: ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(source.title),
                  subtitle: Text(
                    source.url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _launchUrl(source.url),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
```

**必要なパッケージ:**

```yaml
dependencies:
  url_launcher: ^6.3.1
```

## テストシナリオ

### エージェントシステムのテスト

1. **Planning**: 適切な検索クエリが生成される
2. **Research**: Web 検索が実行され結果が返る
3. **Reflection**: 追加調査が必要か適切に判断される
4. **Refinement**: 読みやすいレポートが生成される

### マルチエージェント統合のテスト

1. **正常フロー**: Plan → Research → Reflect → Refine が順次実行される
2. **追加調査**: Reflection で追加クエリが生成され、再度 Research が実行される
3. **追加調査不要**: 十分な情報が集まった場合、追加調査がスキップされる

### Flutter アプリのテスト

1. **UI**:「詳しく調べる」ボタンが表示される
2. **調査実行**: ボタンタップで調査が開始される
3. **ローディング**: 調査中はインジケーターが表示される
4. **結果表示**: 調査結果画面に遷移してレポートが表示される
5. **リンククリック**: 参考ソースのリンクがブラウザで開く

## エラーハンドリング

### Web 検索関連

1. **API キーエラー**: 適切なエラーメッセージ
2. **レート制限**: リトライロジック
3. **検索失敗**: 別のクエリで再試行

### エージェント関連

1. **Planning 失敗**: デフォルトのクエリを使用
2. **Research 失敗**: 部分的な結果で継続
3. **タイムアウト**: 適切なタイムアウト設定

### Flutter 側

1. **ネットワークエラー**: ユーザーフレンドリーなメッセージ
2. **長時間処理**: タイムアウトと中断機能
3. **空の結果**:「調査結果が見つかりませんでした」

## パフォーマンス考慮事項

### 処理時間の最適化

- 並列実行の活用（複数クエリを同時実行）
- タイムアウトの適切な設定
- 不要な追加調査の回避

### コスト最適化

- Web 検索の回数を最小化
- 適切な maxResults 設定
- キャッシュの活用

## UI/UX ガイドライン

### ローディング表示

調査には時間がかかるため、進捗を明確に表示します。

```dart
// 進捗インジケーターの例
LinearProgressIndicator()
Text('AI が情報を調査しています...')
```

### エラー時の対応

- ユーザーフレンドリーなメッセージ
- リトライボタン
- 部分的な結果の表示

## 実装の優先順位

### 必須（MVP）

1. Planning エージェント
2. Research エージェント
3. Refinement エージェント
4. オーケストレーションフロー
5. Flutter UI

### 推奨

1. Reflection エージェント
2. 追加調査のロジック
3. エラーハンドリング

### オプション

1. 進捗表示の詳細化
2. 調査履歴の保存
3. 調査結果の共有機能

## 実装時の注意事項

### セキュリティ

- Tavily API キーの適切な管理
- ユーザー入力のサニタイズ

### コスト管理

- Tavily の無料枠を監視
- 不要な検索を避ける

### パフォーマンス

- Cloud Functions のタイムアウト設定（最大9分）
- 適切なリトライ戦略

## サンプルデータ

### テスト用の日記例

**例1: 技術トピック**

```
今日は生成AIについてのカンファレンスに参加した。
最新の LLM の進化や、RAG の活用事例について学んだ。
特に Gemini 2.0 の新機能が印象的だった。
```

**期待される調査結果:**

- Gemini 2.0 の新機能
- RAG の最新動向
- 生成 AI の実用例

**例2: 一般トピック**

```
週末に富士山に登った。天気が良くて絶景だった。
来年はアルプスにも挑戦したい。
```

**期待される調査結果:**

- 富士山登山のベストシーズン
- 日本アルプスの登山コース
- 登山の準備と装備

## 参考資料

### 公式ドキュメント

- [Genkit Agent Patterns](https://firebase.google.com/docs/genkit)
- [Tavily API Documentation](https://docs.tavily.com/)

### AI エージェントの理論

- [ReAct: Reasoning and Acting in Language Models](https://arxiv.org/abs/2210.03629)
- [AutoGPT](https://github.com/Significant-Gravitas/AutoGPT)
