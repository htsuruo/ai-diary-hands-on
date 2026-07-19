# ai_diary_hands_on

AI日記アプリのハンズオンプロジェクト

<img src="./assets/images/logo/symbol_with_box.png" alt="Symbol Icon" width="70%">

## セットアップ

### Firebase設定

このプロジェクトではFirebaseを使用しています。初回セットアップ時に以下を実行してください:

```bash
# FlutterFire CLIのインストール（初回のみ）
dart pub global activate flutterfire_cli

# Firebase設定ファイルの生成
flutterfire configure
```

`flutterfire configure` を実行すると、`lib/firebase_options.dart` に実際のFirebase設定値が書き込まれます。

**注意**: `firebase_options.dart` はダミーデータでコミットされています。`flutterfire configure` 実行後の変更はコミットしないでください。

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

### Firebase設定ファイルの役割

このリポジトリには `firebase.json` が2つあります。
どちらも Firebase 関連の設定ファイルですが、用途が異なります。

- `firebase.json`
  - FlutterFire CLI が生成する Flutter アプリ連携用の設定です。
  - `flutterfire configure` を実行するときに利用されます。
- `firebase/firebase.json`
  - Cloud Functions、Firestore、Emulator 用の Firebase CLI 設定です。
  - `firebase/` 配下で Functions や Emulator を操作するときに利用されます。

ルート直下の `firebase.json` は Flutter アプリと Firebase プロジェクトの対応関係を管理するためのファイルです。
基本的には FlutterFire CLI が管理するため、手動で編集する必要はありません。

一方、`firebase/firebase.json` は第9章以降で扱う Genkit バックエンド、
Cloud Functions、Firestore、Emulator のための設定です。
Functions のビルド、エミュレータ起動、デプロイなど Firebase CLI を使う作業は、
基本的に `firebase/` ディレクトリで実行します。

```bash
# Firebase CLIのインストール（初回のみ）
npm install -g firebase-tools

cd firebase
npm --prefix functions install
firebase emulators:start
```

### iOS: Swift Package Manager移行

本プロジェクトのiOSはCocoaPodsを廃止し、Swift Package Manager（SPM）に移行済みです。
CocoaPods（`pod`コマンド）のインストールは不要です。

参考: [Swift Package Manager for app developers | Flutter](http://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers)

## 技術構成

- Framework: Flutter (stable channel, 3.44.4) + Dart (SDK ^3.12.0)
- State management: Riverpod
- Code generation: Freezed、JSON Serializable、Build Runner
- Development tools: Simple Logger、Custom Lint、Pedantic Mono、Riverpod Lint
- Support Platform: Android、iOS
- Database: Cloud Firestore(Firebase)

## プロジェクト構成

本アプリは 機能（feature-first）ごとにディレクトリを分けて構成しています。`lib/features/` の下に、機能ごとのディレクトリ（`ai_feedback`など）を作成します。

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
├── firebase_options.dart
├── main.dart
└── shared
    ├── extensions
    ├── shared.dart
    └── widgets
```

本レポジトリはハンズオン前提での利用のため、ユーザー認証などは実装せず必要最小限の機能をシンプルに実装することを優先しています。

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
├── ai_feedback/        # 第5章: AI フィードバック
├── chat/               # 第5章: AI チャット
├── sentiment_analysis/ # 第6章: センチメント分析
├── calendar_integration/ # 第6章: カレンダー連携
├── llm_ops/            # 第7章: LLMOps
└── ai_feedback_genkit/ # 第9章: Genkit バックエンド連携
```

#### Core vs Shared の使い分け

`core` と `shared` ディレクトリを以下のように定義して使い分けます。

| ディレクトリ | コンセプト | 特徴 | 具体例 |
| :--- | :--- | :--- | :--- |
| **`core`** | **インフラ & カーネル** | ・アプリが動くための**土台**<br>・ビジネスロジックを含まない、または**全機能の根幹**となるデータ<br>・他のアプリでも使い回せるような汎用的なものが多い | `Logger`, `ApiClient`, `AppTheme`, `Router`, `ScaffoldMessenger`<br>`DiaryEntry` (例外的にここ: アプリの核となるデータ) |
| **`shared`** | **共有部品 (UI/Logic)** | ・複数の機能から**再利用**される部品<br>・このアプリ固有のデザインや要件が含まれる<br>・「機能の一部」だが、共通化されたもの | `PrimaryButton`, `ErrorView`, `DateFormatters`<br>`DiaryCard` (一覧と検索の両方で使う場合など) |

**判断の目安:**
- **「これがないとアプリが起動すらしないか？」**
    - YES → `core` (Router, Theme, Authなど)
    - NO → `shared` (特定のボタン、特定のフォーマッターなど)

- **「他の全く違うアプリを作る時、このファイルをコピーして使えるか？」**
    - YES (修正なしで使える) → `core` の可能性が高い (Logger, API Client)
    - NO (デザインが違うから無理) → `shared` の可能性が高い (UI Components)

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
          │   ├─ feedbackText: string
          │   ├─ sentimentAnalysis: string
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

## 機能概要

### 第5章 FlutterアプリとFirebase AI Logicの統合

1. ユーザーが日記を書く（既存機能）
2. 日記詳細画面で「AIフィードバック」ボタンをタップ
3. AIが日記を読んで共感的なフィードバックを生成（ストリーミング表示）
4. フィードバックを読んだ後、「チャットで相談」ボタンをタップ
5. AIチャット画面に遷移し、フィードバック内容について質問
6. 会話履歴が保持され、文脈に沿った対話が可能

| AIフィードバック | チャットメンタリング |
|---|---|
| ![](./assets/demo/chapter_05/ai_feedback.gif) | ![](./assets/demo/chapter_05/ai_chat.gif) |

### 第6章 Flutterアプリで実践するLLM拡張

#### センチメント分析

1. 日記詳細画面で「センチメント分析」ボタンをタップ
2. 日記の内容をポジティブ・ネガティブ・ニュートラルで分析
3. 一覧画面から日記の感情をすぐに確認可能

#### Googleカレンダーの自動追加

1. ユーザーが日記に予定を書く（例：「明日14時から友達とランチ」）
2. LLMが日記から予定情報を抽出
3. 予定の追加が適切だと判断した場合、Googleカレンダーに自動追加
4. 追加したカレンダーをユーザーへ通知

#### 外部ソースを参照したチャット回答

1. 「チャットで相談」ボタンをタップ（第5章で実装）
2. AIチャット画面でフィードバック内容について質問（第5章で実装）
3. LLMがWeb検索が必要と判断した場合、外部ソースを参照
4. 参照した外部ソースをチップUIで表示し、アプリ内ブラウザで確認可能

| センチメント分析 | Google カレンダーの予定登録 | 外部ソースを参照したチャット回答 |
| --- | --- | --- |
| ![](./assets/demo/chapter_06/sentiment_analysis.gif) | ![](./assets/demo/chapter_06/calendar_integration.gif) | ![](./assets/demo/chapter_06/chat_with_grounding.gif) |

### 第7章 LLMOpsによるプロンプト管理と運用改善

1. AIフィードバックのプロンプトを、Firebaseコンソールで管理するサーバープロンプトテンプレートへ移行
2. Remote Configの値を切り替えることで、アプリのリリースなしにプロンプトを更新
3. App Checkを有効化し、正規のアプリ以外からのAI機能の呼び出しを防止

### 第9章 Genkitバックエンド連携

1. 第5章で実装したAIフィードバックを、Cloud Functions上のGenkitフロー呼び出しに置き換え
2. バックエンドでセンチメント分析とフィードバック生成を組み合わせたフローを実行し、結果をストリーミング表示

第10章（RAG）と第11章（AIエージェント）はバックエンドのみの実装のため、Flutterアプリへの機能追加はありません。`firebase/functions/` 配下の実装と Genkit Developer UI で動作を確認します。
