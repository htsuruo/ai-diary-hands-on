# AI Diary Hands-on

書籍[作って学ぶ生成AIモバイルアプリ開発／運用](https://www.amazon.co.jp/dp/4297158795)のための、
Flutter 製 AI日記アプリです。Firebase AI Logic を使うクライアント実装から、
Genkit と Cloud Functions によるバックエンドまでを章ごとに段階的に作ります。

<img src="./assets/images/logo/symbol_with_box.png" alt="AI Diary のロゴ" width="70%">

## ハンズオンの開始方法

第4章から手を動かす場合は、
[chapter-04-start](https://github.com/htsuruo/ai-diary-hands-on/tree/chapter-04-start) タグ
から始めます。後続の機能を含む `main` を出発点にすると、本文の途中で作るコードが
あらかじめ存在してしまうためです。クローン後は、変更を保存するための作業ブランチを
作成してください。

```bash
git clone --branch chapter-04-start \
  https://github.com/htsuruo/ai-diary-hands-on.git
cd ai-diary-hands-on
git switch -c ai-diary-work
```

`--branch chapter-04-start` で、第4章の開始タグを指定してクローンします。タグを
指定しないと、既定のブランチにある完成後のコードが取得されます。クローン後は、
`git switch -c` でハンズオンの変更を保存する作業ブランチを作成します。

章の開始・完了時点は、`chapter-XX-start` と `chapter-XX-complete` のタグで管理します。
途中の章から始めるときは、対応する `chapter-XX-start` を指定してクローンします。

## セットアップ

### 必要な環境

| 用途 | 必要なもの |
| --- | --- |
| Flutter アプリ | Flutter SDK、Dart SDK（`pubspec.yaml` の Dart SDK 制約は `^3.12.0`） |
| Firebase 設定 | Firebase CLI、FlutterFire CLI、Firebase プロジェクト |
| 第8章以降 | Node.js 24、npm、Firebase プロジェクト |
| iOS | Xcode と RubyGems（FlutterFire の設定時に必要になる場合があります） |

最初に `flutter doctor` を実行し、開発環境に不足がないことを確認してください。

### Flutterの依存関係

Firebase を設定する前に、プロジェクトの依存関係を取得します。

```bash
flutter pub get
```

### Firebase設定

このプロジェクトではFirebaseを使用しています。初回セットアップ時に以下を実行してください:

```bash
# FlutterFire CLIのインストール（初回のみ）
dart pub global activate flutterfire_cli

# Firebase設定ファイルの生成
flutterfire configure
```

`flutterfire configure` を実行すると、`lib/firebase_options.dart` が生成されます。

**注意**: `firebase_options.dart` は `.gitignore` 対象のためリポジトリには
含まれていません。各自の Firebase プロジェクトで `flutterfire configure` を実行して
生成してください。API キー、サービスアカウント鍵、実プロジェクトの設定値も
コミットしません。

### アプリの起動

接続するデバイスまたはエミュレータを確認してから起動します。

```bash
flutter devices
flutter run
```

### Cloud FunctionsとGenkit

第8章以降で使用する Cloud Functions の依存関係は、プロジェクトルートで Firebase を
設定したあと、次のコマンドでインストールします。Functions の実行環境は Node.js 24
です。

```bash
cd functions
npm install
```

#### iOSビルド時の注意点: `xcodeproj` gem

`flutterfire configure` でプラットフォームに `ios` を含めると、内部で Ruby の `xcodeproj` gem を使って `.pbxproj`（Xcodeプロジェクトファイル）を編集します。この gem がインストールされていない環境では、次のようなエラーで処理が失敗します。

```bash
Exception: .../rubygems/core_ext/kernel_require.rb:54:in `require': cannot load such file -- xcodeproj (LoadError)
```

このエラーが出た場合は、次のコマンドで `xcodeproj` gem をインストールしてから `flutterfire configure` を再実行してください。

```bash
gem install --user-install xcodeproj
```

この gem は CocoaPods を利用しているかどうかにかかわらず、`GoogleService-Info.plist` をXcodeプロジェクトへ登録する処理で必要になります（下記のSPM移行後も変わりません）。

### iOS: Swift Package Manager移行

本プロジェクトのiOSはCocoaPodsを廃止し、Swift Package Manager（SPM）に移行済みです。
CocoaPods（`pod`コマンド）のインストールは不要です。

参考: [Swift Package Manager for app developers | Flutter](http://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers)

## よく使うコマンド

### Flutter

```bash
# 静的解析
flutter analyze

# Riverpod / Freezed などのコード生成を監視
dart run build_runner watch --delete-conflicting-outputs
```

### FunctionsとGenkit

以下は `functions/` ディレクトリで実行します。

```bash
# 静的解析と TypeScript ビルド
npm run lint
npm run build

# 章ごとの Genkit Developer UI
npm run genkit:feedback
npm run genkit:rag
npm run genkit:writer

# Functions Emulator と Genkit を併用
npm run genkit:emulators

# Cloud Functions をデプロイ
npm run deploy
```

## 技術構成

- Framework: Flutter (stable channel, 3.44.4) + Dart (SDK ^3.12.0)
- State management: Riverpod
- Code generation: Freezed、JSON Serializable、Build Runner
- Development tools: Simple Logger、Custom Lint、Pedantic Mono、Riverpod Lint
- Support Platform: Android、iOS
- Database: Cloud Firestore (Firebase)
- Backend AI: Genkit + Google GenAI（第8章以降）

## プロジェクト構成

本アプリは機能（feature-first）ごとにディレクトリを分けて構成しています。ハンズオンでは、章を進めながら `lib/features/` と `functions/src/` の下へAI機能を追加します。

```bash
lib
├── app.dart
├── core
│   ├── ai
│   ├── core.dart
│   ├── router
│   ├── theme
│   └── utils
├── examples
├── features
│   ├── ai_feedback
│   ├── ai_feedback_genkit
│   ├── calendar_integration
│   ├── chat
│   ├── diary
│   ├── llm_ops
│   ├── sentiment_analysis
│   └── settings
├── main.dart
├── tutorial
└── shared
    ├── extensions
    ├── shared.dart
    └── widgets
```

第4章の開始時点では、日記のCRUDと、後続章で利用するGoogleサインインの基盤を実装済みです。AI機能は各章のハンズオンで追加します。

### ディレクトリの役割

- `core/`: アプリケーション全体の基盤
    - ルーティング、テーマ、ユーティリティなど
    - 特定のドメイン知識を持たない純粋な技術的基盤
- `shared/`: 複数の機能（Feature）で共有されるリソース
    - 共通の UI コンポーネント
    - 拡張メソッド
- `features/`: 機能ごとに独立したドメイン

### 各章でのfeatureの拡張イメージ

```bash
features/
├── diary/              # 基本日記機能
├── calendar_integration/ # Googleサインイン基盤、第6章でカレンダー連携を追加
├── chat/               # 第5章で拡張するチャット画面の雛形
├── settings/           # Googleサインインの確認画面
├── ai_feedback/        # 第5章: AI フィードバック
├── sentiment_analysis/ # 第6章: センチメント分析
├── llm_ops/            # 第7章: LLMOps
└── ai_feedback_genkit/ # 第9章: Genkit バックエンド連携
```

バックエンドの実装は `functions/src/` に配置します。第8章ではGenkitの開発環境とサンプルフロー、第9章ではワークフロー、第10章ではRAG、第11章ではAIエージェントを実装します。

### 章と主な実装箇所

| 章 | 主な実装箇所 | 内容 |
| --- | --- | --- |
| 第4章 | `lib/tutorial/`、`lib/firebase_options.dart` | Firebase環境、Firebase AI Logic、テキスト生成 |
| 第5章 | `lib/features/ai_feedback/`、`lib/features/chat/`、`lib/core/ai/` | AIフィードバック、ストリーミング、マルチターンチャット |
| 第6章 | `lib/features/sentiment_analysis/`、`lib/features/calendar_integration/`、`lib/features/chat/` | 構造化出力、関数呼び出し、グラウンディング |
| 第7章 | `lib/features/llm_ops/` | AIモニタリング、プロンプトテンプレート、Remote Config、App Check |
| 第8章 | `functions/src/genkit-sample.ts` | GenkitとCloud Functionsの開発環境 |
| 第9章 | `functions/src/diary-feedback/`、`lib/features/ai_feedback_genkit/` | Genkitワークフロー、Dotprompt、Callable関数 |
| 第10章 | `functions/src/memory-assistant-rag/` | Embedding、Firestoreベクトル検索、RAG |
| 第11章 | `functions/src/diary-writer-agent/` | ライティングエージェント、RAGツール、Skills、reflection |

#### Core vs Shared の使い分け

`core` と `shared` ディレクトリを以下のように定義して使い分けます。

| ディレクトリ | コンセプト | 特徴 | 具体例 |
| :--- | :--- | :--- | :--- |
| **`core`** | **アプリの基盤** | ・アプリ全体で使う技術的な土台<br>・特定の機能（ドメイン）に依存しない<br>・起動や全画面の動作に関わる | `logger` (`core/utils/logger.dart`)、`AppTheme`、`router`、Firebase AI の共通 Provider |
| **`shared`** | **共有部品 (UI/Logic)** | ・複数の機能から再利用される部品<br>・このアプリ固有のデザインや要件を含む<br>・機能の一部を共通化したもの | `ActionIconButton`、`EmptyWidget`、`DateTime` 拡張 |

**判断の目安:**
- **「これがないとアプリが起動すらしないか？」**
    - YES → `core` (Router, Themeなど)
    - NO → `shared` (特定のボタン、特定のフォーマッターなど)

- **「他の全く違うアプリを作る時、このファイルをコピーして使えるか？」**
    - YES (修正なしで使える) → `core` の可能性が高い (Logger, Router)
    - NO (デザインが違うから無理) → `shared` の可能性が高い (共通 Widget)

### データフロー

基本的には以下の流れで処理が進みます：

1. **UI**: ユーザーがボタンを押す。
2. **ViewModel**: UIから呼ばれ、ロジックを実行する。
3. **Repository**: ViewModelから呼ばれ、DB(Firestore)を操作する。
4. **DB**: データが更新される。
5. **Repository**: DBの変更を検知する（Stream）。
6. **ViewModel**: 新しいデータを受け取る。
7. **UI**: ViewModelの状態変化を検知(`ref.watch`)し、画面を再描画する。

## Firestoreデータ構造

日記データは `users/{uid}/diaries` のサブコレクションに保存します。ユーザーごとにデータが分離され、セキュリティルールによるアクセス制御を記述しやすい構造です。本ハンズオンでは認証を実装しないため、`uid` には固定値を使用しています。

```bash
users (collection)
  └─ {uid} (document) ※ハンズオンでは固定値
      └─ diaries (collection)
          ├─ {diaryId} (document)
          │   ├─ title: string
          │   ├─ content: string
          │   ├─ date: string
          │   ├─ createdAt: Timestamp
          │   └─ updatedAt: Timestamp
          ├─ {diaryId} (document)
          └─ ...
```

## 主要パッケージの簡単な紹介

このプロジェクトで使用している主要なパッケージの簡単な紹介です。

### Riverpod: 状態管理

アプリ全体でデータを管理・共有するための仕組みです。
- **Provider**: データの「保管場所」兼「生成ロジック」。
- **ConsumerWidget**: Providerのデータを「使う」ためのWidget。
- **ref.watch**: データを監視し、変更があったら画面を再描画します（基本はこれを使う）。
- **ref.read**: 再描画せずにデータやメソッドを一度だけ呼び出します（ボタンタップ時など）。

### Freezed: イミュータブルなデータクラス

変更不可能な（Immutable）データクラスを簡単に作るためのツールです。
- **copyWith**: データの一部だけ書き換えた「新しいインスタンス」を作ります。
- **fromJson**: JSONデータからDartのオブジェクトに変換します。

### GoRouter: 画面遷移

URLベースで画面遷移を管理するパッケージです。
- Webのように `/diary/123` といったパスで画面を定義できます。
- `context.push('/path')` や `context.go('/path')` で遷移します。
