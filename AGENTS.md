# AGENTS.md

このリポジトリで作業する AI エージェント・開発者向けのガイドです。

## リポジトリの目的

書籍「作って学ぶ生成AIモバイルアプリ開発／運用ーFirebase AI LogicとGenkitでFlutterアプリにGeminiを実装する」のハンズオンで使用する AI 日記アプリのサンプルコードです。

- 書籍の第4章〜第7章（Flutter + Firebase AI Logic）と第9章〜第11章（Genkit バックエンド）に対応します
- 書籍リポジトリ（`gihyo-contents`）から Git submodule として参照され、本文とコードの対応関係をコミット単位で固定します
- 読者が手を動かして進める教材であるため、**本文の手順どおりに再現できること**を最優先とします

## 技術スタック

| 領域 | 技術 |
| --- | --- |
| クライアント | Flutter / Dart（バージョンは `pubspec.yaml` を参照） |
| 状態管理 | Riverpod（`riverpod_generator` によるコード生成） |
| データモデル | Freezed |
| ルーティング | GoRouter |
| AI（クライアント） | Firebase AI Logic（`firebase_ai` パッケージ） |
| AI（バックエンド） | Genkit（TypeScript） |
| バックエンド | Cloud Functions for Firebase（Node.js 24、リージョンは `asia-northeast1`） |
| データベース | Cloud Firestore（ベクトル検索を含む） |
| その他 Firebase | Authentication / Remote Config / App Check |

## ディレクトリ構成

```text
lib/
  core/            # アプリ基盤（ai/ router/ theme/ utils/）
  shared/          # 機能横断の共通 Widget・Provider
  features/        # 機能単位のディレクトリ（feature-first 構成）
    diary/               # 日記の CRUD（ベース実装）
    ai_feedback/         # 第5章: AI フィードバック
    chat/                # 第5章: マルチターンチャット（第6章でグラウンディング追加）
    sentiment_analysis/  # 第6章: センチメント分析（構造化出力）
    calendar_integration/ # 第6章: 関数呼び出し + Google Calendar 連携
    llm_ops/             # 第7章: Remote Config・サーバープロンプトテンプレート
    ai_feedback_genkit/  # 第9章: Genkit バックエンド呼び出し
    settings/
  tutorial/        # 第4章: Firebase AI Logic のチュートリアル
  examples/        # 本文で参照する最小構成のサンプル（main_*.dart）
assets/prompts/    # システムプロンプトの Markdown ファイル
functions/         # Cloud Functions（Genkit バックエンド）
  src/
    genkit.ts             # 共有の Genkit インスタンス
    firebase.ts           # Firebase Admin SDK / Firestore の初期化
    diary-feedback/       # 第9章: センチメント分析 + フィードバック生成フロー
    memory-assistant-rag/ # 第10章: RAG（Indexer / Retriever / 思い出アシスタント）
    diary-writer-agent/   # 第11章: ライティングエージェント（tools/ skills/）
    prompts/              # Dotprompt（機能名ごとのサブディレクトリで管理）
firebase.json      # firestore / functions / emulators の設定（flutter キーはローカル限定）
specs/             # 画面・要件などの仕様ドキュメント
```

## 書籍の章とコードの対応

| 章 | 主な実装箇所 | 内容 |
| --- | --- | --- |
| 第4章 | `lib/firebase_options.dart`、`lib/tutorial/` | Firebase セットアップ、`firebase_ai` 導入、テキスト生成 |
| 第5章 | `lib/features/ai_feedback/`、`lib/features/chat/`、`lib/core/ai/`、`assets/prompts/` | AI フィードバック、ストリーミング、マルチターンチャット |
| 第6章 | `lib/features/sentiment_analysis/`、`lib/features/calendar_integration/`、`lib/features/chat/` | 構造化出力、関数呼び出し、グラウンディング |
| 第7章 | `lib/features/llm_ops/` | サーバープロンプトテンプレート、Remote Config、App Check |
| 第9章 | `functions/src/diary-feedback/`、`lib/features/ai_feedback_genkit/` | Genkit フロー、Dotprompt、Cloud Functions デプロイ |
| 第10章 | `functions/src/memory-assistant-rag/` | Embedding、Firestore ベクトル検索、RAG フロー |
| 第11章 | `functions/src/diary-writer-agent/` | エージェントループ、RAG ツール、Skills、reflection |

第8章は別リポジトリ（`genkit-youtube-summary`）を使用するため、本リポジトリに対応コードはありません。

## セットアップ

Flutter アプリ:

```bash
flutter pub get
dart pub global activate flutterfire_cli
flutterfire configure
flutter run
```

Cloud Functions:

```bash
cd functions
npm install
```

- `lib/firebase_options.dart` はコミットされていません。各自の Firebase プロジェクトで `flutterfire configure` を実行して生成します
- **`flutterfire configure` で生成された実際の設定値をコミットしてはいけません**

## 開発コマンド

Flutter:

```bash
dart run build_runner watch --delete-conflicting-outputs  # コード生成
flutter analyze                                           # 静的解析
```

Cloud Functions（`functions/` で実行）:

```bash
npm run genkit:feedback   # 第9章: 日記フィードバックフローの Developer UI
npm run genkit:rag        # 第10章: RAG フローの Developer UI
npm run genkit:writer     # 第11章: ライティングエージェントの Developer UI
npm run genkit:emulators  # Functions Emulator と Genkit Developer UI の併用
npm run lint              # ESLint
npm run deploy            # Cloud Functions のデプロイ
```

## コーディング規約

- Flutter 側の規約は `.github/instructions/flutter.instructions.md` に従います
- 機能追加は `lib/features/` 配下の feature-first 構成を維持します
- Riverpod は `riverpod_generator` によるジェネレータ構文（`@riverpod`）を使用します
- Genkit 側は共有インスタンス（`src/genkit.ts`）を使い、フローは機能ごとのディレクトリ、プロンプトは Dotprompt（`src/prompts/<機能名>/*.prompt`）で管理します
- Flutter 側は `flutter analyze` の警告ゼロを維持します

## 書籍本文との同期ルール

このリポジトリのコードは書籍本文（`gihyo-contents` リポジトリの `contents/`）に転載されています。**コードと本文の乖離は読者の再現失敗に直結する**ため、次のルールを守ります。

1. 本文に掲載されているコード・ファイルパス・コマンドを変更する場合は、書籍リポジトリ側の該当章も必ず更新する
2. モデル名（例: Gemini のバージョン）や依存パッケージを更新する場合は、本文の記載と一致させる
3. 変更が特定の章の完成状態に影響する場合は、後述のタグを更新する
4. 書籍リポジトリ側で submodule の参照コミットを更新する

## 使用モデルの一覧と運用

現在使用している Gemini モデルは次のとおりです。

| 用途 | モデル名 | 主な定義箇所 |
| --- | --- | --- |
| クライアント（第4〜7章） | `gemini-3.1-flash-lite` | `lib/tutorial/`、`lib/features/` 各所 |
| バックエンド共通デフォルト（第9〜11章） | `gemini-3.1-flash-lite` | `functions/src/genkit.ts` |
| 第9章 フィードバックフロー | `gemini-3.1-flash-lite` | `functions/src/prompts/diary-feedback/*.prompt` |
| 第10章 Embedding | `gemini-embedding-2` | `functions/src/memory-assistant-rag/embedder.ts` |
| 第10章 RAG フロー | `gemini-3.1-flash-lite` | `functions/src/prompts/memory-assistant-rag/memory-assistant.prompt` |
| 第11章 ドラフト生成・リフレクション | `gemini-3.5-flash` | `functions/src/prompts/diary-writer-agent/diary_draft.prompt`、`diary_reflect.prompt` |
| 第11章 メタデータ生成 | `gemini-3.1-flash-lite` | `functions/src/prompts/diary-writer-agent/diary_meta.prompt` |

モデル名の運用ルール:

- モデル名を変更する場合は、実装・この表・本文の該当章の 3 つを必ず同時に更新する
- 同一章内・章間でモデルを使い分ける場合は、その意図（性能・コスト・応答速度）を本文で説明する
- 刊行前に `-preview` サフィックスのモデルが正式版へ置き換え可能かを確認する

## タグ運用

各章の開始時点と完了時点をタグで管理します。読者は途中の章から始める場合に `chapter-XX-start` を、完成形を確認したい場合に `chapter-XX-complete` を利用します。

| タグ | 意味 |
| --- | --- |
| `chapter-XX-start` | その章のハンズオンを開始する時点のコード |
| `chapter-XX-complete` | その章のハンズオンを完了した時点のコード |

運用ルール:

- タグの対象は第4章〜第7章、第9章〜第11章です
- `chapter-XX-complete` と次章の `chapter-(XX+1)-start` は原則同じコミットを指します（第7章 → 第9章のように章が飛ぶ場合も同様）
- **タグが指すツリーには、その章より後の章で実装する機能を含めてはいけません**（例: `chapter-05-complete` に第6章のセンチメント分析が入っていてはいけない）
- 章の内容に影響する修正を行った場合は、該当章以降のタグを付け直し、書籍リポジトリの submodule 参照も更新します

## 注意事項

- `lib/firebase_options.dart` の実値、`.env`、API キー、サービスアカウント鍵はコミット禁止です
- `pubspec.lock` と `package-lock.json` はコミット対象です（読者環境の再現性のため）
- `firebase.json` の `flutter` キー（flutterfire configure が追記する実プロジェクト設定）はコミット禁止です
- Firestore エミュレータは使用しません（Functions Emulator + 開発用プロジェクトの実 Firestore で動作確認します）
- 第10章のベクトル検索には Firestore のベクトルインデックス作成（`gcloud firestore indexes composite create`）が必要です。インデックス定義は `firestore.indexes.json` に反映します
- `weekly-report-agent` など書籍の対象外となった実装は削除済みです。復活させないでください
