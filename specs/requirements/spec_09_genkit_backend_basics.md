# 第9章 ハンズオン仕様書: Genkit でバックエンド AI ワークフロー構築

## 概要

本章では、Genkit の基本を理解し、AI ワークフローをバックエンドで構築する方法を学びます。Firebase Local Emulator Suite でローカル開発し、Cloud Functions for Firebase にデプロイして Flutter アプリと連携させます。

## 前提条件

### 環境

- Node.js: 20.x 以上
- npm または yarn
- Firebase CLI: 13.x 以上
- 第5章〜第7章のハンズオンが完了していること

### 読者の知識レベル

- TypeScript の基礎知識（または JavaScript の知識と学習意欲）
- Firebase Cloud Functions の基本概念
- コマンドラインツールの基本操作

### 必要なツール

- Genkit CLI (`npm install -g genkit`)
- Firebase CLI (`npm install -g firebase-tools`)
- エディタ（VS Code 推奨）

## アプリの完成イメージ

### 新規画面

本章では新しい画面は追加せず、既存のフィードバック機能をバックエンドに移行します。

### アーキテクチャの変更

#### Before（第5章）

```
Flutter App → Firebase AI Logic → Gemini API
```

#### After（本章）

```
Flutter App → Cloud Functions (Genkit) → Gemini API
              ↓
         Genkit Dev UI（開発・デバッグ用）
```

### ユーザー体験フロー

#### 基本フロー

ユーザー体験は第5章と同じですが、バックエンドで以下が実現されます:

1. より複雑な AI ワークフローの実行
2. Tool の活用（日記の文字数カウント）
3. プロンプトのバージョン管理（Dotprompt）
4. トレーサビリティの向上

#### 具体例：長文日記へのフィードバック

##### ユーザー視点での体験

**日記を書く（800文字の長文）**

ユーザーB さんが以下のような長い日記を書きました。

```text
今日は朝から大忙しの一日だった。まず、会社でプレゼンテーションがあり、
準備してきた資料を元に提案を行った。予想以上に質問が多く、
しっかり答えられるか不安だったが、チームメンバーのサポートもあって
無事に乗り切ることができた。

午後は別のプロジェクトのミーティングがあり、
新しい機能の仕様について議論した。技術的な課題がいくつかあったが、
エンジニアチームと協力しながら解決策を見つけることができた。

夜は友人とディナーに行き、最近の仕事の話や趣味の話で盛り上がった。
忙しい日々の中でも、こうした時間を持てることに感謝している。
明日も頑張ろうという気持ちになった。

（全体で約800文字）
```

**AIフィードバックをタップ**

日記詳細画面で「AI フィードバック」ボタンをタップします。第5章のクライアント実装と同じ UI ですが、バックエンドでは Genkit のフローが動作しています。

**フィードバックの表示**

数秒後、以下のようなフィードバックが表示されます。

```text
800文字も書かれたのですね！お疲れ様です！✨

充実した一日を過ごされましたね。プレゼンテーションでは
チームのサポートを受けながら質問に対応し、午後のミーティングでも
協力して課題を解決できたとのこと。

特に印象的なのは、忙しい中でも友人との時間を大切にしている点です。
こうしたワークライフバランスを保つ姿勢が、明日への活力に
つながっているのですね。素敵なライフスタイルです！
```

**ユーザーが気づかない裏側の処理**

ユーザーには見えませんが、バックエンドでは以下の処理が実行されていました。

##### 開発者視点：Genkit Dev UIでのトレース

開発者が Genkit Dev UI を開くと、以下のような処理の流れが可視化されています。

**フロー実行のトレース**

```text
Flow: feedbackFlow
実行時間: 3.2秒
ステータス: 成功 ✓

処理ステップ:

1. 入力受信 (0.1秒)
   - diaryContent: "今日は朝から..." (800文字)

2. Tool呼び出し: countWords (0.2秒)
   入力: { text: "今日は朝から..." }
   出力: 800
   判定: 500文字以上 → 労いの言葉を追加

3. Dotprompt読み込み (0.1秒)
   - ファイル: feedback.prompt
   - バージョン: v2.1
   - 変数展開: diaryContent, wordCount

4. Gemini API呼び出し (2.5秒)
   - モデル: gemini-2.0-flash-exp
   - 入力トークン: 950
   - 出力トークン: 180
   - レスポンス時間: 2.5秒

5. 出力処理 (0.3秒)
   - 結果: "800文字も書かれたのですね..."
   - 文字数: 210文字

コスト概算: $0.002
```

**Tool実行の詳細**

```typescript
// countWords Tool の実行ログ

Input:
{
  text: "今日は朝から大忙しの一日だった...（全文）"
}

Processing:
- スペースと改行を除外
- 文字数カウント実行

Output:
800

Decision:
wordCount >= 500 → true
→ プロンプトに労いの言葉を追加
"{{wordCount}}文字も書かれたのですね！お疲れ様です！"
```

**Dotpromptの適用**

```handlebars
--- feedback.prompt (v2.1) ---

あなたは優しく共感的な日記メンターです。

{{#if (gte wordCount 500)}}
重要: この日記は{{wordCount}}文字と長文です。
冒頭で「{{wordCount}}文字も書かれたのですね！お疲れ様です！」と
労いの言葉を入れてください。
{{/if}}

ユーザーの日記を読んで、フィードバックを提供してください。

日記:
{{diaryContent}}
```

**API呼び出しの詳細**

```text
Gemini API Request:

Prompt (展開後):
"あなたは優しく共感的な日記メンターです。

重要: この日記は800文字と長文です。
冒頭で「800文字も書かれたのですね！お疲れ様です！」と
労いの言葉を入れてください。

ユーザーの日記を読んで、フィードバックを提供してください。

日記:
今日は朝から大忙しの一日だった...（全文）"

Response:
"800文字も書かれたのですね！お疲れ様です！✨

充実した一日を過ごされましたね...（全文）"
```

##### 短文日記の場合の違い

**日記内容（200文字）**

```text
今日は良い天気だった。
散歩に行って気分転換できた。
```

**フィードバック**

```text
良い天気の日に散歩で気分転換できたのは良かったですね！
シンプルな楽しみ方も大切です。
```

**Genkit Dev UIでのトレース**

```text
Tool呼び出し: countWords
出力: 200
判定: 500文字未満 → 通常のフィードバックのみ
```

短文の場合は労いの言葉は表示されず、通常のフィードバックのみが生成されます。このように、Tool を使った条件分岐がバックエンドで自動的に処理されます。

##### この実装のメリット

**ユーザーにとって:**

- UI は変わらないが、より適切なフィードバックが得られる
- 長文を書いた努力が認められる

**開発者にとって:**

- 複雑なロジックをバックエンドで管理できる
- プロンプトの変更がデプロイ不要で可能（Dotprompt）
- トレーサビリティにより、問題の特定が容易
- Tool の追加で機能拡張が簡単

**コスト面:**

- クライアントからの直接呼び出しと比較して、わずかなオーバーヘッド（+0.3秒程度）
- Tool による前処理でトークン数を最適化可能
- バッチ処理やキャッシュの実装も可能（将来的）

## 実装範囲

### 8.1 Genkit の基本

このセクションは主に理論的な説明です。

#### 学習内容

- Genkit とは何か
- AI ワークフローとは
- Genkit の主要コンポーネント（Flow、Model、Tool、Prompt）
- Firebase との統合の利点

### 8.2 Firebase の基礎

このセクションも主に理論的な説明ですが、一部セットアップ作業が含まれます。

#### 学習内容

- Cloud Functions for Firebase の役割
- Firebase Local Emulator Suite の利点
- Genkit と Cloud Functions の統合パターン

### 8.3 準備: Firebase 環境と Genkit 開発環境の構築

#### 実装内容

##### 8.3.1 Genkit CLI のインストール

**インストールコマンド:**

```bash
npm install -g genkit
```

**確認:**

```bash
genkit --version
```

##### 8.3.2 Firebase プロジェクトのセットアップ

**既存プロジェクトの使用:**
第5章で作成した Firebase プロジェクトを使用します。

**ディレクトリ構成:**

```
ai_diary_app/
├── lib/              # Flutter アプリ
├── functions/        # Cloud Functions (Genkit) ← 新規作成
│   ├── src/
│   │   ├── index.ts
│   │   ├── flows/
│   │   │   └── feedback.ts
│   │   ├── tools/
│   │   │   └── countWords.ts
│   │   └── prompts/
│   │       └── feedback.prompt
│   ├── package.json
│   └── tsconfig.json
├── pubspec.yaml
└── firebase.json
```

##### 8.3.3 Cloud Functions の初期化

**コマンド:**

```bash
cd ai_diary_app
firebase init functions
```

**設定オプション:**

- 言語: TypeScript
- ESLint: Yes
- 依存関係のインストール: Yes

##### 8.3.4 Genkit パッケージの追加

**package.json の編集:**

```json
{
  "name": "functions",
  "scripts": {
    "build": "tsc",
    "serve": "npm run build && firebase emulators:start --only functions",
    "shell": "npm run build && firebase functions:shell",
    "start": "npm run shell",
    "deploy": "firebase deploy --only functions",
    "logs": "firebase functions:log",
    "genkit:dev": "genkit start -- tsx --watch src/index.ts"
  },
  "engines": {
    "node": "20"
  },
  "main": "lib/index.js",
  "dependencies": {
    "@genkit-ai/core": "^0.9.0",
    "@genkit-ai/firebase": "^0.9.0",
    "@genkit-ai/googleai": "^0.9.0",
    "@genkit-ai/dotprompt": "^0.9.0",
    "firebase-admin": "^12.7.0",
    "firebase-functions": "^6.1.0"
  },
  "devDependencies": {
    "@types/node": "^20.11.19",
    "genkit": "^0.9.0",
    "tsx": "^4.7.1",
    "typescript": "~5.3.3"
  }
}
```

**インストール:**

```bash
cd functions
npm install
```

##### 8.3.5 Firebase Emulator Suite のセットアップ

**firebase.json の編集:**

```json
{
  "functions": [
    {
      "source": "functions",
      "codebase": "default",
      "ignore": [
        "node_modules",
        ".git",
        "firebase-debug.log",
        "firebase-debug.*.log"
      ]
    }
  ],
  "emulators": {
    "functions": {
      "port": 5001
    },
    "ui": {
      "enabled": true,
      "port": 4000
    },
    "singleProjectMode": true
  }
}
```

**Emulator の起動:**

```bash
firebase emulators:start
```

確認: `http://localhost:4000` にアクセスして Emulator UI が表示されること

### 8.4 はじめての AI フロー構築・テスト

#### 実装内容

##### 8.4.1 Genkit の初期化

**src/index.ts の作成:**

```typescript
import { configureGenkit } from '@genkit-ai/core';
import { firebase } from '@genkit-ai/firebase';
import { googleAI } from '@genkit-ai/googleai';

configureGenkit({
  plugins: [
    firebase(),
    googleAI({
      apiKey: process.env.GOOGLE_AI_API_KEY,
    }),
  ],
  logLevel: 'debug',
  enableTracingAndMetrics: true,
});

export * from './flows/feedback';
```

**環境変数の設定:**
`.env` ファイル（functions/ ディレクトリ）:

```
GOOGLE_AI_API_KEY=your_api_key_here
```

**注意:** `.env` は `.gitignore` に追加

##### 8.4.2 基本的なフローの定義

**src/flows/feedback.ts の作成:**

```typescript
import { defineFlow, runFlow } from '@genkit-ai/core';
import { gemini20FlashExp } from '@genkit-ai/googleai';
import { onFlow } from '@genkit-ai/firebase/functions';

// フィードバック生成フローの定義
export const feedbackFlow = onFlow(
  {
    name: 'feedbackFlow',
    inputSchema: z.object({
      diaryContent: z.string(),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    const prompt = `
あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 内容に共感し、ポジティブな側面を見つける
- 気づきや学びがあれば指摘する
- 簡潔に2-3文でまとめる
- 親しみやすいトーンで

日記:
${input.diaryContent}
    `;

    const result = await gemini20FlashExp.generate({
      prompt,
    });

    return result.text;
  }
);
```

##### 8.4.3 Genkit Developer UI でのテスト

**Genkit Dev UI の起動:**

```bash
cd functions
npm run genkit:dev
```

確認: `http://localhost:4000` にアクセス

**テスト手順:**

1. Developer UI で `feedbackFlow` を選択
2. Input に日記テキストを入力:

   ```json
   {
     "diaryContent": "今日は久しぶりに友人と会ってランチをした。楽しかった。"
   }
   ```

3. 「Run」ボタンをクリック
4. Output にフィードバックが表示されることを確認

### 8.5 Cloud Functions へのデプロイと Flutter との接続

#### 実装内容

##### 8.5.1 Cloud Functions へのデプロイ

**デプロイコマンド:**

```bash
firebase deploy --only functions
```

**確認:**
Firebase Console で関数が表示されることを確認

**デプロイされる関数:**

- `feedbackFlow` (HTTP トリガー)

##### 8.5.2 Flutter アプリからの呼び出し

**パッケージの追加:**

```yaml
dependencies:
  cloud_functions: ^5.1.4
```

**Flutter 側の実装:**

**lib/services/genkit_service.dart の作成:**

```dart
import 'package:cloud_functions/cloud_functions.dart';

class GenkitService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // ローカルエミュレータを使う場合
  GenkitService({bool useEmulator = false}) {
    if (useEmulator) {
      _functions.useFunctionsEmulator('localhost', 5001);
    }
  }

  Future<String> generateFeedback(String diaryContent) async {
    try {
      final callable = _functions.httpsCallable('feedbackFlow');
      final result = await callable.call({
        'data': {
          'diaryContent': diaryContent,
        },
      });

      return result.data['result'] as String;
    } catch (e) {
      throw Exception('フィードバックの生成に失敗しました: $e');
    }
  }
}
```

**UI の更新:**
既存の `AIService` の代わりに `GenkitService` を使用するよう変更。

```dart
class DiaryDetailScreen extends StatefulWidget {
  // ...
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final _genkitService = GenkitService(useEmulator: kDebugMode);
  String? _feedback;
  bool _isLoading = false;

  Future<void> _generateFeedback() async {
    setState(() => _isLoading = true);

    try {
      final feedback = await _genkitService.generateFeedback(
        widget.diary.content,
      );

      setState(() {
        _feedback = feedback;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラー: $e')),
      );
    }
  }

  // ... UI 実装
}
```

### 8.6 Tool calling - 日記の文字数を数える Tool を作成

#### 実装内容

##### 8.6.1 Tool の定義

**src/tools/countWords.ts の作成:**

```typescript
import { defineTool } from '@genkit-ai/core';
import { z } from 'zod';

export const countWordsTool = defineTool(
  {
    name: 'countWords',
    description: '日記の文字数をカウントする。長文の場合に使用してユーザーを労う。',
    inputSchema: z.object({
      text: z.string().describe('文字数をカウントするテキスト'),
    }),
    outputSchema: z.number().describe('文字数'),
  },
  async (input) => {
    // 日本語の文字数をカウント（スペースや改行を除く）
    const count = input.text.replace(/\s/g, '').length;
    return count;
  }
);
```

##### 8.6.2 Tool を使用するフローの実装

**src/flows/feedback.ts の更新:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { gemini20FlashExp } from '@genkit-ai/googleai';
import { onFlow } from '@genkit-ai/firebase/functions';
import { countWordsTool } from '../tools/countWords';
import { z } from 'zod';

export const feedbackFlow = onFlow(
  {
    name: 'feedbackFlow',
    inputSchema: z.object({
      diaryContent: z.string(),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    const prompt = `
あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、フィードバックを提供してください。

重要: もし日記が500文字以上の場合は、countWords ツールを使って文字数を確認し、
「${文字数}文字も書かれたのですね！お疲れ様です！」のような労いの言葉を
フィードバックの冒頭に入れてください。

日記:
${input.diaryContent}
    `;

    const result = await gemini20FlashExp.generate({
      prompt,
      tools: [countWordsTool],
      config: {
        temperature: 0.7,
      },
    });

    return result.text;
  }
);
```

##### 8.6.3 Tool の動作確認

**Genkit Dev UI でのテスト:**

1. 500文字以上の日記テキストを入力
2. 実行
3. Tool が呼び出されることを Trace で確認
4. フィードバックに労いの言葉が含まれることを確認

### 8.7 Dotprompt でプロンプトを管理

#### 実装内容

##### 8.7.1 Dotprompt ファイルの作成

**src/prompts/feedback.prompt の作成:**

```handlebars
---
model: googleai/gemini-2.0-flash-exp
config:
  temperature: 0.7
  maxOutputTokens: 500
input:
  schema:
    diaryContent: string
output:
  format: text
tools:
  - countWords
---

あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 内容に共感し、ポジティブな側面を見つける
- 気づきや学びがあれば指摘する
- 簡潔に2-3文でまとめる
- 親しみやすいトーンで

重要: もし日記が500文字以上の場合は、countWords ツールを使って文字数を確認し、
「{{文字数}}文字も書かれたのですね！お疲れ様です！」のような労いの言葉を
フィードバックの冒頭に入れてください。

日記:
{{diaryContent}}
```

##### 8.7.2 Dotprompt を使用するようフローを更新

**src/flows/feedback.ts の更新:**

```typescript
import { defineFlow } from '@genkit-ai/core';
import { onFlow } from '@genkit-ai/firebase/functions';
import { prompt } from '@genkit-ai/dotprompt';
import { z } from 'zod';

export const feedbackFlow = onFlow(
  {
    name: 'feedbackFlow',
    inputSchema: z.object({
      diaryContent: z.string(),
    }),
    outputSchema: z.string(),
  },
  async (input) => {
    // Dotprompt からプロンプトをロード
    const feedbackPrompt = await prompt('feedback');

    // プロンプトを実行
    const result = await feedbackPrompt.generate({
      input: {
        diaryContent: input.diaryContent,
      },
    });

    return result.text;
  }
);
```

##### 8.7.3 Dotprompt の利点

**学習内容:**

- プロンプトとコードの分離
- バージョン管理が容易
- チーム開発での可読性向上
- プロンプトの再利用

### 8.8 トレーサビリティの確認

#### 実装内容

##### 8.8.1 Genkit Developer UI でのトレース確認

**確認項目:**

1. **フロー実行履歴**
   - 各実行の入力・出力
   - 実行時間
   - エラー情報

2. **ステップ詳細**
   - プロンプト送信
   - Tool 呼び出し
   - レスポンス生成

3. **パフォーマンス**
   - 各ステップの処理時間
   - トークン使用量
   - コスト見積もり

##### 8.8.2 Cloud Functions でのログ確認

**Firebase Console でのログ確認:**

1. Firebase Console > Functions
2. ログタブを選択
3. `feedbackFlow` の実行ログを確認

**ログの内容:**

- リクエストの詳細
- エラーやワーニング
- カスタムログ（追加実装）

**カスタムログの追加例:**

```typescript
import { logger } from 'firebase-functions';

export const feedbackFlow = onFlow(
  // ...
  async (input) => {
    logger.info('Feedback flow started', { 
      diaryLength: input.diaryContent.length 
    });

    try {
      const result = await feedbackPrompt.generate({
        input: {
          diaryContent: input.diaryContent,
        },
      });

      logger.info('Feedback generated successfully', {
        outputLength: result.text.length,
      });

      return result.text;
    } catch (error) {
      logger.error('Failed to generate feedback', { error });
      throw error;
    }
  }
);
```

## テストシナリオ

### ローカル開発環境のテスト

1. **Emulator 起動**: Emulator が正常に起動する
2. **Genkit Dev UI**: Dev UI にアクセスできる
3. **フロー実行**: Dev UI からフローが実行できる
4. **Flutter 連携**: Emulator に接続した Flutter アプリからフローを呼び出せる

### フロー機能のテスト

1. **基本的なフィードバック**: 日記に対してフィードバックが生成される
2. **Tool 呼び出し**: 500文字以上の日記で Tool が呼び出される
3. **短文**: 500文字未満の日記では Tool が呼び出されない
4. **エラーハンドリング**: 不正な入力でエラーメッセージが返る

### Dotprompt のテスト

1. **プロンプトロード**: Dotprompt ファイルが正しく読み込まれる
2. **変数展開**: 変数が正しく展開される
3. **設定反映**: temperature などの設定が反映される

### デプロイのテスト

1. **デプロイ成功**: Cloud Functions にデプロイが成功する
2. **本番動作**: デプロイされた関数が動作する
3. **Flutter 連携**: 本番環境の関数を Flutter から呼び出せる

## エラーハンドリング

### Genkit 関連

1. **プロンプトロードエラー**: Dotprompt ファイルが見つからない
2. **Tool 実行エラー**: Tool の実行に失敗
3. **モデル呼び出しエラー**: Gemini API の呼び出しに失敗

### Cloud Functions 関連

1. **デプロイエラー**: 構文エラー、依存関係の問題
2. **実行時エラー**: メモリ不足、タイムアウト
3. **権限エラー**: API キーが無効

### Flutter 側

1. **ネットワークエラー**: Functions への接続に失敗
2. **タイムアウト**: 処理に時間がかかりすぎる
3. **レスポンスパースエラー**: 不正なレスポンス形式

## パフォーマンス考慮事項

### Cold Start の最適化

- 最小限の依存関係
- 軽量なインポート
- 適切なメモリ設定

### コスト最適化

- 不要な API 呼び出しを避ける
- タイムアウトの適切な設定
- Tool の効率的な実装

### トークン使用量の管理

- プロンプトの簡潔化
- コンテキストウィンドウの最適化
- 不要な履歴の削除

## UI/UX ガイドライン

### ローディング状態

バックエンド呼び出しは時間がかかるため、適切なローディング表示を実装します。

```dart
Future<void> _generateFeedback() async {
  setState(() => _isLoading = true);

  try {
    // Genkit フローの呼び出し
    // ...
  } finally {
    setState(() => _isLoading = false);
  }
}
```

### エラーメッセージ

ユーザーフレンドリーなエラーメッセージを表示します。

```dart
void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'リトライ',
        onPressed: _generateFeedback,
      ),
    ),
  );
}
```

## 実装の優先順位

### 必須（MVP）

1. Genkit 開発環境の構築
2. 基本的なフローの実装
3. Cloud Functions へのデプロイ
4. Flutter からの呼び出し

### 推奨

1. Tool の実装
2. Dotprompt によるプロンプト管理
3. ログとトレーサビリティ

### オプション

1. 複雑なワークフロー
2. カスタムダッシュボード
3. パフォーマンス最適化

## 実装時の注意事項

### セキュリティ

- API キーを環境変数で管理
- `.env` ファイルを `.gitignore` に追加
- Cloud Functions の適切な権限設定

### コスト管理

- Emulator を活用して開発中のコストを抑える
- 本番環境では適切な Rate Limit を設定

### デバッグ

- Genkit Dev UI を活用
- 適切なログ出力
- エラーハンドリングの徹底

## サンプルデータ

### テスト用の日記サンプル

**短文（Tool が呼び出されない）:**

```
今日は良い天気だった。散歩に行って気分転換できた。
```

**長文（Tool が呼び出される）:**

```
今日は朝から大忙しの一日だった。まず、会社でプレゼンテーションがあり、
準備してきた資料を元に提案を行った。予想以上に質問が多く、
しっかり答えられるか不安だったが、チームメンバーのサポートもあって
無事に乗り切ることができた。

午後は別のプロジェクトのミーティングがあり、
新しい機能の仕様について議論した。技術的な課題がいくつかあったが、
エンジニアチームと協力しながら解決策を見つけることができた。

夜は友人とディナーに行き、最近の仕事の話や趣味の話で盛り上がった。
忙しい日々の中でも、こうした時間を持てることに感謝している。
明日も頑張ろうという気持ちになった。
```

## 参考資料

### 公式ドキュメント

- [Genkit 公式ドキュメント](https://firebase.google.com/docs/genkit)
- [Cloud Functions for Firebase](https://firebase.google.com/docs/functions)
- [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite)

### サンプルコード

- [Genkit サンプル集](https://github.com/firebase/genkit/tree/main/samples)
