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

`flutterfire configure` を実行すると、`lib/firebase_options.dart` が生成されます。

**注意**: `firebase_options.dart` は `.gitignore` 対象のためリポジトリには含まれていません。各自の Firebase プロジェクトで `flutterfire configure` を実行して生成してください。

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

## 技術構成

- Framework: Flutter (stable channel, 3.44.4) + Dart (SDK ^3.12.0)
- State management: Riverpod
- Code generation: Freezed、JSON Serializable、Build Runner
- Development tools: Simple Logger、Custom Lint、Pedantic Mono、Riverpod Lint
- Support Platform: Android、iOS
- Database: Cloud Firestore(Firebase)

## プロジェクト構成

本アプリは機能（feature-first）ごとにディレクトリを分けて構成しています。ハンズオンでは、章を進めながら `lib/features/` の下へAI機能を追加します。

```bash
lib
├── app.dart
├── core
│   ├── core.dart
│   ├── router
│   ├── theme
│   └── utils
├── features
│   ├── calendar_integration
│   ├── chat
│   ├── diary
│   └── settings
├── main.dart
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
