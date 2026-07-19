# 第10章 ハンズオン仕様書: RAG で過去の日記から答える思い出アシスタント

## 概要

本章では、RAG（Retrieval-Augmented Generation）の仕組みを理解し、Firestore Vector Search で過去の日記を検索して回答を生成する「思い出アシスタント」を実装します。ベクトル検索と LLM を組み合わせた実践的な AI アプリケーションを構築します。

## 前提条件

### 環境

- 第9章のハンズオンが完了していること
- Firestore データベースが作成済み
- Firebase の Blaze プラン（Vector Search に必要）

### 読者の知識レベル

- Firestore の基本操作
- Genkit の基礎知識（第9章）
- ベクトルや Embedding の概念（本章で学習）

### 必要なパッケージ・サービス

- Firestore Vector Search
- Genkit Retriever
- Text Embedding API（Vertex AI）

## アプリの完成イメージ

### 新規画面

#### 思い出アシスタント画面（新規実装）

- チャット形式の UI
- ユーザーが過去の日記について質問できる
- AI が関連する日記を検索して回答を生成

### ユーザー体験フロー

1. ユーザーが「思い出アシスタント」画面を開く
2. 質問を入力（例:「楽しかった旅行について教えて」）
3. AI が過去の日記を検索（バックグラウンド）
4. 関連する日記の内容を元に回答を生成（ストリーミング表示）
5. 回答に参考にした日記の引用が含まれる
6. さらに質問を続けられる

### データフロー

```
ユーザーの質問
  ↓
Genkit Flow (memoryAssistantFlow)
  ↓
1. Embedding 生成（質問をベクトル化）
  ↓
2. Firestore Vector Search（関連日記を検索）
  ↓
3. Retriever（検索結果を取得）
  ↓
4. プロンプト組み立て（検索結果をコンテキストに含める）
  ↓
5. Gemini API（回答生成）
  ↓
回答テキスト
```

## 実装範囲

### 9.1 RAG とは

このセクションは理論的な説明が中心です。

#### 学習内容

- RAG の基本概念
- 広義の RAG と狭義の RAG
- RAG が必要な理由と解決する課題
- Retrieve → Generate の流れ

### 9.2 Embedding とは

このセクションも理論的な説明が中心です。

#### 学習内容

- Embedding（ベクトル埋め込み）とは
- テキストをベクトル化する仕組み
- 意味的な類似度の計算
- Embedding モデルの種類

### 9.3 Cloud Firestore の準備

#### 実装内容

##### 9.3.1 Firestore データベースの作成

**Firebase Console での操作:**

1. Firebase Console > Firestore Database
2. データベースを作成（既に存在する場合はスキップ）
3. ロケーション: asia-northeast1（東京）推奨

##### 9.3.2 日記データのスキーマ設計

**コレクション構造:**

```
diaries (collection)
  └── {diaryId} (document)
      ├── userId: string
      ├── title: string
      ├── content: string
      ├── createdAt: timestamp
      ├── embedding: array<number> (768次元のベクトル)
      └── metadata: map
          ├── wordCount: number
          ├── sentiment: string
          └── topics: array<string>
```

##### 9.3.3 Vector Search インデックスの作成

**Firebase Console での操作:**

1. Firestore > インデックス
2. 単一フィールドインデックスを作成
   - コレクション: `diaries`
   - フィールド: `embedding`
   - 設定:
     - ベクトル構成: 有効
     - 次元数: 768
     - 距離の測定: COSINE（コサイン類似度）

**注意:** インデックスの作成には10〜20分かかる場合があります。

##### 9.3.4 ダミーデータの投入

**スクリプト作成（functions/scripts/seed-diaries.ts）:**

```typescript
import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { embed } from '@genkit-ai/ai/embedder';
import { textEmbedding004 } from '@genkit-ai/googleai';

initializeApp();
const db = getFirestore();

const sampleDiaries = [
  {
    title: '京都旅行',
    content: `
今日から2泊3日で京都旅行。清水寺、金閣寺、嵐山を巡った。
紅葉が美しく、写真をたくさん撮った。夕食は湯豆腐を食べて大満足。
明日は祇園と伏見稲荷に行く予定。楽しみ！
    `,
  },
  {
    title: '友人との再会',
    content: `
3年ぶりに大学時代の友人と会った。お互いの近況を報告し合い、
昔話に花が咲いた。時間が経ってもすぐに昔のように話せる関係って貴重。
次回は夏に集まることを約束した。
    `,
  },
  {
    title: 'プロジェクト成功',
    content: `
半年間取り組んできたプロジェクトがついにリリース。
チーム全員の努力が実って、お客様からも高評価をいただいた。
打ち上げでは皆で喜びを分かち合った。次のプロジェクトも頑張ろう。
    `,
  },
  // 他のサンプルデータも追加...
];

async function seedDiaries() {
  for (const diary of sampleDiaries) {
    // Embedding を生成
    const embeddingResult = await embed({
      embedder: textEmbedding004,
      content: diary.content,
    });

    // Firestore に保存
    await db.collection('diaries').add({
      userId: 'sample_user',
      title: diary.title,
      content: diary.content,
      createdAt: new Date(),
      embedding: embeddingResult.embedding,
      metadata: {
        wordCount: diary.content.length,
      },
    });

    console.log(`Diary "${diary.title}" added`);
  }

  console.log('All diaries seeded successfully');
}

seedDiaries();
```

**実行:**

```bash
cd functions
npx tsx scripts/seed-diaries.ts
```

##### 9.3.5 Firebase Extensions による自動 Embedding（オプション）

**Extensions のインストール:**

1. Firebase Console > Extensions
2. 「Firestore Vector Search」Extension を検索
3. インストールと設定

**設定項目:**

- コレクション: `diaries`
- Embedding フィールド: `embedding`
- テキストフィールド: `content`
- Embedding モデル: `text-embedding-004`

**メリット:**

- 日記が追加されると自動で Embedding が生成される
- スクリプトを書く必要がない

### 9.4 Genkit でフロー構築

#### 実装内容

##### 9.4.1 Retriever の作成

**src/retrievers/diaryRetriever.ts の作成:**

```typescript
import { defineRetriever } from '@genkit-ai/ai/retriever';
import { embed } from '@genkit-ai/ai/embedder';
import { textEmbedding004 } from '@genkit-ai/googleai';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { Document } from '@genkit-ai/ai';

const db = getFirestore();

export const diaryRetriever = defineRetriever(
  {
    name: 'diaryRetriever',
    configSchema: z.object({
      userId: z.string(),
      limit: z.number().default(5),
    }),
  },
  async (input, options) => {
    // 質問を Embedding に変換
    const queryEmbedding = await embed({
      embedder: textEmbedding004,
      content: input.text(),
    });

    // Firestore Vector Search で類似日記を検索
    const query = db
      .collection('diaries')
      .where('userId', '==', options.userId)
      .findNearest('embedding', queryEmbedding.embedding, {
        limit: options.limit,
        distanceMeasure: 'COSINE',
      });

    const snapshot = await query.get();

    // 検索結果を Document 形式に変換
    const documents: Document[] = snapshot.docs.map((doc) => {
      const data = doc.data();
      return Document.fromText(
        `タイトル: ${data.title}\n内容: ${data.content}`,
        {
          metadata: {
            diaryId: doc.id,
            title: data.title,
            createdAt: data.createdAt.toDate().toISOString(),
          },
        }
      );
    });

    return {
      documents,
    };
  }
);
```

##### 9.4.2 プロンプトの組み立て（Dotprompt）

**src/prompts/memory-assistant.prompt の作成:**

```handlebars
---
model: googleai/gemini-2.0-flash-exp
config:
  temperature: 0.7
  maxOutputTokens: 1000
input:
  schema:
    question: string
    context: string
output:
  format: text
---

あなたはユーザーの思い出を振り返るアシスタントです。
ユーザーの過去の日記を参照して、質問に答えてください。

## 重要な指示
- 提供されたコンテキスト（過去の日記）の内容のみを元に回答してください
- コンテキストにない情報は推測しないでください
- 自然で親しみやすい口調で回答してください
- 日記の引用を適切に含めてください

## コンテキスト（過去の日記）
{{context}}

## ユーザーの質問
{{question}}

## 回答
```

##### 9.4.3 RAG フロー全体の構築

**src/flows/memory-assistant.ts の作成:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { onFlow } from '@genkit-ai/firebase/functions';
import { prompt } from '@genkit-ai/dotprompt';
import { diaryRetriever } from '../retrievers/diaryRetriever';
import { z } from 'zod';

export const memoryAssistantFlow = onFlow(
  {
    name: 'memoryAssistantFlow',
    inputSchema: z.object({
      userId: z.string(),
      question: z.string(),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    // Step 1: Retrieve - 関連する日記を検索
    const retrieveResult = await diaryRetriever.retrieve({
      query: input.question,
      config: {
        userId: input.userId,
        limit: 5,
      },
    });

    // 検索結果が空の場合
    if (retrieveResult.documents.length === 0) {
      return '申し訳ございません。関連する日記が見つかりませんでした。';
    }

    // Step 2: コンテキストの組み立て
    const context = retrieveResult.documents
      .map((doc, index) => {
        const metadata = doc.metadata;
        return `
【日記 ${index + 1}】
タイトル: ${metadata.title}
日付: ${new Date(metadata.createdAt).toLocaleDateString('ja-JP')}
内容:
${doc.text()}
        `;
      })
      .join('\n---\n');

    // Step 3: Generate - プロンプトを使って回答生成
    const memoryPrompt = await prompt('memory-assistant');
    const result = await memoryPrompt.generate({
      input: {
        question: input.question,
        context,
      },
    });

    return result.text;
  }
);
```

**index.ts への追加:**

```typescript
export * from './flows/memory-assistant';
```

##### 9.4.4 Genkit Dev UI でのテスト

**テスト手順:**

1. Genkit Dev UI を起動: `npm run genkit:dev`
2. `memoryAssistantFlow` を選択
3. Input に以下を入力:

   ```json
   {
     "userId": "sample_user",
     "question": "楽しかった旅行について教えて"
   }
   ```

4. 「Run」をクリック
5. 検索→生成の流れを Trace で確認
6. 回答に日記の内容が反映されていることを確認

### 9.5 Flutter アプリとの連携と動作確認

#### 実装内容

##### 9.5.1 思い出アシスタント画面の作成

**lib/screens/memory_assistant_screen.dart の作成:**

```dart
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class MemoryAssistantScreen extends StatefulWidget {
  final String userId;

  const MemoryAssistantScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MemoryAssistantScreen> createState() => _MemoryAssistantScreenState();
}

class _MemoryAssistantScreenState extends State<MemoryAssistantScreen> {
  final _functions = FirebaseFunctions.instance;
  final _messageController = TextEditingController();
  final _messages = <ChatMessage>[];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('思い出アシスタント'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _MessageBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(),
          _MessageInput(
            controller: _messageController,
            onSend: _sendMessage,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    // ユーザーメッセージを追加
    setState(() {
      _messages.add(ChatMessage(
        text: question,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();

    try {
      // Cloud Functions の呼び出し
      final callable = _functions.httpsCallable('memoryAssistantFlow');
      final result = await callable.call({
        'data': {
          'userId': widget.userId,
          'question': question,
        },
      });

      // AI の回答を追加
      setState(() {
        _messages.add(ChatMessage(
          text: result.data['result'] as String,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      _showError('エラーが発生しました: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isLoading;

  const _MessageInput({
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '過去の日記について質問してください',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: isLoading ? null : onSend,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: isLoading
                ? null
                : () => onSend(controller.text),
          ),
        ],
      ),
    );
  }
}
```

##### 9.5.2 ナビゲーションの追加

日記一覧画面などから思い出アシスタント画面への導線を追加します。

```dart
// 日記一覧画面の AppBar に追加
AppBar(
  title: const Text('日記一覧'),
  actions: [
    IconButton(
      icon: const Icon(Icons.psychology),
      tooltip: '思い出アシスタント',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemoryAssistantScreen(
              userId: currentUser.uid,
            ),
          ),
        );
      },
    ),
  ],
)
```

##### 9.5.3 動作確認

**テストシナリオ:**

1. アプリを起動し、思い出アシスタント画面を開く
2. 「楽しかった旅行について教えて」と質問
3. 京都旅行の日記の内容を元にした回答が返る
4. 「友人との思い出は?」と質問
5. 友人との再会の日記の内容を元にした回答が返る

##### 9.5.4 実際の日記データでのテスト

**手順:**

1. アプリで複数の日記を書く
2. 数日待って、いくつか日記を追加する
3. 思い出アシスタントで質問する
4. AI が実際の日記を検索して回答することを確認

## テストシナリオ

### Firestore Vector Search のテスト

1. **インデックス作成**: Vector Search インデックスが正常に作成される
2. **ダミーデータ**: サンプル日記が Embedding 付きで保存される
3. **検索**: 類似度の高い日記が検索される
4. **パフォーマンス**: 検索が1秒以内に完了する

### Retriever のテスト

1. **正常系**: 関連する日記が正しく取得される
2. **結果なし**: 関連する日記がない場合、空の配列が返る
3. **上限**: limit パラメータが正しく機能する
4. **ユーザー分離**: 他のユーザーの日記が検索されない

### RAG フローのテスト

1. **基本的な質問**:「旅行について教えて」→ 旅行の日記を元に回答
2. **具体的な質問**:「京都で何を食べた?」→ 具体的な内容を回答
3. **関連なし**:「株価について教えて」→「関連する日記がありません」
4. **複数の日記**: 複数の関連日記を統合した回答

### Flutter アプリのテスト

1. **UI**: 思い出アシスタント画面が正しく表示される
2. **メッセージ送信**: 質問を送信できる
3. **回答表示**: AI の回答が表示される
4. **連続質問**: 複数の質問を連続して送信できる

## エラーハンドリング

### Vector Search 関連

1. **インデックス未作成**: 適切なエラーメッセージを表示
2. **検索失敗**: リトライまたはエラーメッセージ
3. **タイムアウト**: 検索のタイムアウト処理

### Embedding 関連

1. **Embedding 生成失敗**: エラーハンドリングとフォールバック
2. **レート制限**: リトライロジック

### Flutter 側

1. **ネットワークエラー**: ユーザーフレンドリーなエラーメッセージ
2. **タイムアウト**: 適切なタイムアウト設定とリトライ
3. **空の回答**:「関連する日記が見つかりませんでした」

## パフォーマンス考慮事項

### 検索の最適化

- 適切な limit 設定（5〜10件）
- インデックスの適切な設定
- キャッシュの活用

### Embedding の最適化

- バッチ処理による効率化
- 既存の Embedding の再利用

### コスト最適化

- 検索回数の最小化
- Embedding 生成回数の削減
- 適切なモデルの選択

## UI/UX ガイドライン

### 検索中の表示

- ローディングインジケーター
- 「過去の日記を検索しています...」のメッセージ

### 回答の表示

- ストリーミング表示（オプション）
- 参照した日記へのリンク（オプション）
- 日付や引用の明示

### エラー時の対応

- ユーザーフレンドリーなメッセージ
- リトライボタン
- ヘルプテキスト

## 実装の優先順位

### 必須（MVP）

1. Firestore Vector Search のセットアップ
2. Retriever の実装
3. RAG フローの実装
4. Flutter アプリの思い出アシスタント画面

### 推奨

1. Dotprompt によるプロンプト管理
2. エラーハンドリング
3. ローディング状態の表示

### オプション

1. ストリーミング表示
2. 参照日記へのリンク
3. 検索結果のフィルタリング
4. 会話履歴の保持

## 実装時の注意事項

### セキュリティ

- ユーザーの日記は他のユーザーから隔離
- 適切な Firestore Security Rules の設定
- 検索結果の権限チェック

### プライバシー

- Embedding はサーバーで生成（クライアントに生データを送らない）
- ユーザーデータの適切な管理

### コスト管理

- Vector Search のクエリ数を監視
- Embedding 生成回数を最適化

## サンプルデータ

### テスト用の質問例

**旅行関連:**

- 「楽しかった旅行について教えて」
- 「京都で何を見た?」
- 「旅行でおいしかった食べ物は?」

**友人関連:**

- 「友人との思い出を教えて」
- 「最近友達と何をした?」

**仕事関連:**

- 「仕事でうまくいったことは?」
- 「達成したプロジェクトについて教えて」

### 期待される回答例

**質問:**「楽しかった旅行について教えて」

**回答:**

```
京都旅行について書かれていますね！2泊3日で清水寺、金閣寺、嵐山を
巡られたとのこと。紅葉がとても美しかったようで、たくさん写真を
撮られたんですね。夕食に湯豆腐を食べて大満足されたそうで、
京都らしい素敵な体験をされたみたいですね。
翌日は祇園と伏見稲荷に行く予定と書かれていました。
とても充実した旅行だったようで、楽しそうな様子が伝わってきます！
```

## 参考資料

### 公式ドキュメント

- [Firestore Vector Search](https://firebase.google.com/docs/firestore/vector-search)
- [Genkit Retriever](https://firebase.google.com/docs/genkit/retrieval-augmented-generation)
- [Text Embedding API](https://cloud.google.com/vertex-ai/docs/generative-ai/embeddings/get-text-embeddings)

### コードラボ

- [Vector Search with Firestore を利用しベクトル検索機能を試す](https://firebase.google.com/codelabs/firestore-vectorsearch-ios)
