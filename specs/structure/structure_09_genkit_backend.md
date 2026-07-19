# 第9章 ハンズオン構成案: Genkit バックエンド

## コンセプト
クライアントサイド（Flutter）からサーバーサイド（Cloud Functions + Genkit）へ AI ロジックを移行します。TypeScript によるバックエンド開発の基礎もカバーします。

## 推奨ディレクトリ構成

### Flutter 側 (`lib/`)
```
lib/
├── core/
│   ├── ai/
│   │   └── genkit_service.dart     # [NEW] Cloud Functions 呼び出しクライアント
│   └── ...
```

### Functions 側 (`functions/`)
```
functions/
├── src/
│   ├── flows/                      # AI ワークフロー定義
│   │   └── feedbackFlow.ts         # 日記フィードバックフロー
│   ├── tools/                      # ツール定義
│   │   └── wordCountTool.ts        # 文字数カウントツール
│   ├── prompts/                    # Dotprompt ファイル
│   │   └── feedback.prompt         # プロンプト定義 (v2)
│   └── index.ts                    # エントリーポイント
```

## 教育的ポイント

### 1. `functions/src/flows/feedbackFlow.ts`
**狙い**: 「Flow」という単位で AI 処理をカプセル化する。入力と出力のスキーマ（Zod）を定義し、堅牢な API を作る感覚を養います。

### 2. `functions/src/prompts/feedback.prompt`
**狙い**: **Dotprompt** の導入。プロンプト、モデル設定、入力スキーマを1つのファイル（`.prompt`）にまとめることで、プロンプト管理が劇的に楽になることを体験させます。

### 3. クライアントの責務の変化
**狙い**: Flutter 側は「AI の詳細」を知る必要がなくなり、単に「API を呼んで結果を表示する」だけの薄いレイヤーになる（Thin Client 化）ことを示します。
