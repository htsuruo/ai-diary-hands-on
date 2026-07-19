# AI日記アプリ 基本機能仕様書

## 概要

本仕様書は、第5章以降のハンズオンで使用する AI 日記アプリの基本機能（AI 機能以外）について定義します。読者は本仕様に基づいて実装されたサンプルコードを参照し、AI 機能の実装に集中できます。

## アプリの目的

ユーザーが日々の出来事や考えを記録できるシンプルな日記アプリケーション。第5章以降で AI 機能（フィードバック生成、チャット機能など）を追加する土台となります。

## 前提条件

- Flutter SDK: 3.24.0以上
- Dart SDK: 3.5.0以上
- 状態管理: Riverpod 2.6.1以上

## 機能要件

### 1. データモデル

#### DiaryEntry クラス

日記エントリを表現するデータクラス。Freezed を使用してイミュータブルなモデルを定義します。

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_entry.freezed.dart';
part 'diary_entry.g.dart';

@freezed
class DiaryEntry with _$DiaryEntry {
  const factory DiaryEntry({
    required String id,
    required String title,
    required String content,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime updatedAt,
  }) = _DiaryEntry;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryFromJson(json);
}

// Firestore Timestamp ⇔ DateTime の変換ヘルパー
DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  return value as DateTime;
}

dynamic _dateTimeToTimestamp(DateTime dateTime) => Timestamp.fromDate(dateTime);
```

**Freezed の利点**:

- `copyWith` メソッドが自動生成される
- `==` と `hashCode` が自動実装される
- JSON シリアライゼーションが簡潔に記述できる
- イミュータブルなデータモデルを強制できる
- コードの記述量が削減される

**Firestore 対応**:

- `@JsonKey` で Firestore の `Timestamp` 型と `DateTime` を自動変換
- 変換ヘルパー関数は定型文としてコピー&ペーストで OK
- Firestore 特有の複雑な処理は不要

#### バリデーションルール

- **id**: UUID v4形式（自動生成）
- **title**:
  - 必須項目
  - 最大文字数: 100文字
  - 空文字列不可
- **content**:
  - 必須項目
  - 最大文字数: 10,000文字
  - 空文字列不可
- **createdAt**: 作成時のタイムスタンプ（自動設定）
- **updatedAt**: 更新時のタイムスタンプ（自動更新）

### 2. データ永続化

#### ストレージ

Cloud Firestore を使用してデータを保存します。

**Firestore を選択する理由**:

- 第5章で Firebase AI Logic SDK を使うため、Firebase 環境は既に構築済み
- 第10章の RAG 実装で Firestore を使用するため、早期に慣れておくメリットがある
- リアルタイム同期やバックアップ機能が標準で提供される
- NoSQL だが、日記アプリのようなシンプルなデータ構造では複雑さが顕在化しない
- オフラインキャッシュ機能により、ネットワーク環境がなくても動作可能

**学習の容易性**:

- Firestore の詳細な理解は不要（定型コードで実装可能）
- Repository パターンで Firestore の複雑さを隠蔽
- リアルタイムリスナー（Stream）を使って、データの自動同期を実現

#### データ構造

Firestore のコレクション構造はシンプルに1階層のみです。

```
diaries (collection)
  ├─ {diaryId} (document)
  │   ├─ id: string
  │   ├─ title: string
  │   ├─ content: string
  │   ├─ createdAt: Timestamp
  │   └─ updatedAt: Timestamp
  ├─ {diaryId} (document)
  └─ ...
```

**補足**:

- ユーザー認証は実装しない（全ユーザーが同じデータを共有）
- 第5章以降で必要に応じてユーザー認証を追加可能
- サブコレクションは使用しない（シンプルさ優先）

### 3. プロジェクト構成

本アプリは Feature-First アーキテクチャを採用し、機能ごとにディレクトリを分割します。

```
lib/
├── main.dart                          # エントリーポイント
├── app.dart                           # アプリのルートウィジェット
├── firebase_options.dart              # Firebase 設定（自動生成）
│
├── core/                              # アプリケーションのコア機能
│   ├── router/                        # ルーティング設定
│   ├── theme/                         # テーマ設定
│   └── utils/                         # ユーティリティ
│
├── shared/                            # 共有機能（複数の機能から利用）
│   ├── providers/                     # 共有 Provider
│   │   └── scaffold_messenger.dart    # SnackBar表示用
│   ├── widgets/                       # 共有 Widget
│   │   └── ...
│   └── extensions/                    # 拡張メソッド
│
└── features/                          # 機能ごとに分割
    └── diary/                         # 日記機能
        ├── data/                      # データ層
        │   ├── models/                # データモデル
        │   │   ├── diary_entry.dart
        │   │   ├── diary_entry.freezed.dart
        │   │   └── diary_entry.g.dart
        │   └── repositories/          # リポジトリ
        │       ├── diary_repository.dart
        │       └── diary_repository.g.dart
        │
        └── ui/                        # プレゼンテーション層
            ├── list_page.dart         # 一覧画面
            ├── detail_page.dart       # 詳細画面
            ├── edit/                  # 編集・作成画面関連
            │   └── ...
            └── providers/             # UI用 Provider

```

**Feature-First の利点**:

- 機能単位でコードがまとまり、凝集性が高い
- 章の進行とディレクトリが対応（第5章で `ai_feedback/` を追加、など）
- 変更時の影響範囲が明確
- スケーラブルな構成

**ディレクトリの役割**:

- `core/`: アプリケーション全体の基盤
  - ルーティング、テーマ、ユーティリティなど
  - 特定のドメイン知識を持たない純粋な技術的基盤

- `shared/`: 複数の機能（Feature）で共有されるリソース
  - 共通の UI コンポーネント
  - 共通の Provider（ScaffoldMessenger など）
  - 拡張メソッド

- `features/`: 機能ごとに独立したドメイン
  - `data/`: データアクセス層（Repository, Model）
  - `ui/`: プレゼンテーション層（Page, Widget, Provider）

**モデルとリポジトリの配置ルール**:

- `DiaryEntry` モデル: `features/diary/data/models/` に配置
  - 明確に diary ドメインのモデル

- `DiaryRepository`: `features/diary/data/repositories/` に配置
  - 基本的に diary ドメインの責務
  - 他の feature から参照する場合は、このファイルを import して利用

**第5章以降での拡張**:

```
features/
├── diary/              # 基本日記機能
├── ai_feedback/        # 第5章: AI フィードバック
├── chat/               # 第5章: AI チャット
├── analysis/           # 第6章: 感情分析・タグ生成
├── rag/                # 第10章: RAG
└── agent/              # 第11章: AI Agent
```

### 4. 画面構成

#### 4.1 日記一覧画面（DiaryListPage）

**目的**: すべての日記エントリを一覧表示し、新規作成や詳細表示への導線を提供

**UI要素**:

- AppBar
  - タイトル:「日記」
  - アクション: なし
- FloatingActionButton
  - アイコン: `Icons.add`
  - 機能: 新規作成画面へ遷移
- 日記リスト（ListView）
  - 更新日時の降順でソート（新しい順）
  - 各アイテムの表示内容:
    - タイトル（太字、16sp）
    - 本文の抜粋（最初の100文字、グレー、14sp）
    - 更新日時（相対表示: "2時間前"、"3日前" など）
  - タップで詳細画面へ遷移
  - 空の状態:
    - 中央に「日記がありません」メッセージ
    - 「新しい日記を作成しましょう」サブメッセージ

**サンプルレイアウト**:

```
┌─────────────────────────┐
│ 日記                     │
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ 今日の出来事         │ │
│ │ 今日は久しぶりに...  │ │
│ │ 2時間前             │ │
│ └─────────────────────┘ │
│ ┌─────────────────────┐ │
│ │ 充実した一日         │ │
│ │ 朝から晩まで...     │ │
│ │ 昨日                │ │
│ └─────────────────────┘ │
│                    [+]  │
└─────────────────────────┘
```

#### 4.2 日記作成・編集画面（DiaryEditPage）

**目的**: 新規日記の作成または既存日記の編集

**UI要素**:

- AppBar
  - タイトル:「新規作成」または「編集」
  - 先頭: 戻るボタン
  - アクション: 保存ボタン（テキスト: "保存"）
- タイトル入力欄（TextField）
  - ラベル: "タイトル"
  - 最大行数: 1
  - 最大文字数: 100
  - バリデーション: 空欄不可
- 本文入力欄（TextField）
  - ラベル: "本文"
  - 最大行数: null（自動拡張）
  - 最小行数: 10
  - 最大文字数: 10,000
  - バリデーション: 空欄不可

**動作**:

- 新規作成モード:
  - タイトルと本文は空
  - 保存時に新しい ID を生成
- 編集モード:
  - 既存のタイトルと本文を表示
  - 保存時に `updatedAt` を更新
- バリデーション:
  - どちらかが空の場合、保存ボタンを無効化
  - または保存時に SnackBar でエラー表示
- 保存成功後:
  - 一覧画面に戻る
  - SnackBar で「保存しました」を表示

**サンプルレイアウト**:

```
┌─────────────────────────┐
│ < 新規作成         保存  │
├─────────────────────────┤
│ ┌─────────────────────┐ │
│ │ タイトル             │ │
│ └─────────────────────┘ │
│                         │
│ ┌─────────────────────┐ │
│ │ 本文                 │ │
│ │                     │ │
│ │                     │ │
│ │                     │ │
│ │                     │ │
│ │                     │ │
│ │                     │ │
│ └─────────────────────┘ │
└─────────────────────────┘
```

#### 4.3 日記詳細画面（DiaryDetailPage）

**目的**: 日記の全文を読みやすく表示し、編集・削除の操作を提供

**UI要素**:

- AppBar
  - タイトル: 日記のタイトル
  - 先頭: 戻るボタン
  - アクション:
    - 編集ボタン（`Icons.edit`）
    - 削除ボタン（`Icons.delete`）
- スクロール可能なコンテンツ
  - 更新日時（グレー、12sp）
  - 本文（16sp、読みやすい行間）

**動作**:

- 編集ボタン:
  - 編集画面へ遷移（既存データを渡す）
- 削除ボタン:
  - 確認ダイアログを表示
  - 「本当に削除しますか？」
  - キャンセル / 削除ボタン
- 削除実行後:
  - 一覧画面に戻る
  - SnackBar で「削除しました」を表示

**サンプルレイアウト**:

```
┌─────────────────────────┐
│ < 今日の出来事  ✏️  🗑️   │
├─────────────────────────┤
│                         │
│ 2025年1月15日 10:30     │
│                         │
│ 今日は久しぶりに友人と   │
│ 会ってランチをした。     │
│ 仕事の話や最近の趣味の   │
│ 話で盛り上がって、       │
│ あっという間に3時間も    │
│ 経っていた。             │
│ こういう時間って本当に   │
│ 大切だなと思った。       │
│                         │
└─────────────────────────┘
```

### 5. 状態管理（Riverpod）

#### 5.1 DiaryRepository Provider

Firestore とのやり取りを担当するリポジトリ。リアルタイムリスナー（Stream）を使ってデータの自動同期を実現します。

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../models/diary_entry.dart';

part 'diary_repository.g.dart';

@riverpod
class DiaryRepository extends _$DiaryRepository {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  CollectionReference get _collection => _firestore.collection('diaries');

  @override
  Stream<List<DiaryEntry>> build() {
    // Firestore のリアルタイムリスナーで日記リストを監視
    return _collection
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return DiaryEntry.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  Future<void> addDiary({
    required String title,
    required String content,
  }) async {
    final now = DateTime.now();
    final diary = DiaryEntry(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    final json = diary.toJson();
    json.remove('id'); // Firestore の doc ID として使用するため除外
    
    await _collection.doc(diary.id).set(json);
    // Stream が自動的に更新を検知するため、明示的な状態更新は不要
  }

  Future<void> updateDiary(DiaryEntry diary) async {
    final updatedDiary = diary.copyWith(updatedAt: DateTime.now());
    final json = updatedDiary.toJson();
    json.remove('id');
    
    await _collection.doc(diary.id).update(json);
    // Stream が自動的に更新を検知
  }

  Future<void> deleteDiary(String id) async {
    await _collection.doc(id).delete();
    // Stream が自動的に更新を検知
  }
}
```

**リアルタイムリスナーの利点**:

- Firestore のデータが変更されると、自動的に UI が更新される
- 複数デバイス間でのデータ同期が自動的に行われる
- 手動でのデータ再取得が不要（`_fetchDiaries()` のような処理が不要）
- より Firestore らしい実装パターン

**ポイント**:

- `build()` メソッドが `Stream<List<DiaryEntry>>` を返す
- `.snapshots()` で Firestore のリアルタイムリスナーを購読
- CRUD 操作後の明示的な状態更新は不要（Stream が自動検知）
- Firestore の `Timestamp` 変換は `DiaryEntry` の `@JsonKey` で自動処理

#### 5.2 日記一覧 Provider

更新日時の降順でソートされた日記リストを提供。リアルタイムリスナーにより、Firestore のデータ変更が自動的に反映されます。

```dart
@riverpod
class SortedDiaries extends _$SortedDiaries {
  @override
  Stream<List<DiaryEntry>> build() {
    // DiaryRepository の Stream を監視
    return ref.watch(diaryRepositoryProvider.stream).map((diaries) {
      final sorted = [...diaries];
      sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return sorted;
    });
  }
}
```

**補足**: リアルタイムリスナーを使う場合、ソート処理は Firestore の `.orderBy()` で既に行われているため、この Provider は省略可能です。必要に応じて追加のフィルタリングやソート条件を適用する際に使用します。

#### 5.3 日記詳細 Provider

ID で特定の日記を取得。リアルタイムリスナーにより、データの変更が自動的に反映されます。

```dart
@riverpod
class DiaryById extends _$DiaryById {
  @override
  Stream<DiaryEntry?> build(String id) {
    // DiaryRepository の Stream から該当する日記を抽出
    return ref.watch(diaryRepositoryProvider.stream).map((diaries) {
      try {
        return diaries.firstWhere((d) => d.id == id);
      } catch (_) {
        return null;
      }
    });
  }
}
```

**別の実装方法（ドキュメント単位でリスナー）**:

より効率的に、特定のドキュメントだけを監視することも可能です。

```dart
@riverpod
class DiaryById extends _$DiaryById {
  @override
  Stream<DiaryEntry?> build(String id) {
    return FirebaseFirestore.instance
        .collection('diaries')
        .doc(id)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return DiaryEntry.fromJson({
        ...data,
        'id': doc.id,
      });
    });
  }
}
```

### 6. ナビゲーション

#### ルーティング

`go_router` パッケージの使用を推奨（オプション）。シンプルに `Navigator.push` でも可。

**画面遷移フロー**:

```
日記一覧
  ├─> 新規作成 (FloatingActionButton)
  └─> 日記詳細 (リストアイテムタップ)
       ├─> 編集 (編集ボタン)
       └─> 削除確認ダイアログ (削除ボタン)
            └─> 一覧に戻る
```

## 非機能要件

### パフォーマンス

- 日記一覧の読み込み: 1秒以内
- 日記の保存: 500ms 以内
- スムーズなスクロール（60fps）

### ユーザビリティ

- Material Design 3 に準拠
- 最小タップ領域: 44×44pt
- 読みやすいフォントサイズ
- 適切な余白とパディング

### エラーハンドリング

- Firestore アクセスエラー時の適切なエラーメッセージ表示
- バリデーションエラーの明確な表示
- ネットワークエラーのハンドリング（オフラインキャッシュで対応）

## 技術スタック

### 必須パッケージ

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.0.3
  riverpod_annotation: ^3.0.3
  cloud_firestore: ^6.1.0
  firebase_core: ^4.2.0
  collection: ^1.19.1
  gap: ^3.0.1
  go_router: ^16.3.0
  google_fonts: ^6.3.2
  intl: ^0.20.2
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  simple_logger: ^1.10.0
  adaptive_dialog: ^2.5.0

dev_dependencies:
  build_runner: ^2.7.1
  riverpod_generator: ^3.0.3
  freezed: ^3.2.3
  json_serializable: ^6.11.1
  flutter_test:
    sdk: flutter
  custom_lint: ^0.8.0
  riverpod_lint: ^3.0.3
  pedantic_mono: ^1.33.0
```

**Firebase のセットアップ**:

```bash
# Firebase CLI のインストール（初回のみ）
npm install -g firebase-tools

# Firebase にログイン
firebase login

# FlutterFire CLI のインストール（初回のみ）
dart pub global activate flutterfire_cli

# Firebase プロジェクトの作成と Flutter アプリの設定
flutterfire configure
```

**コード生成コマンド**:

```bash
# 初回または変更時に実行
flutter pub run build_runner build --delete-conflicting-outputs

# 開発中は watch モードが便利
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 推奨パッケージ（オプション）

```yaml
dependencies:
  go_router: ^14.6.2  # ルーティング
  timeago: ^3.7.0  # 相対時間表示
```

## テストデータ

### サンプル日記エントリ

実装確認用のサンプルデータ。

```dart
final sampleDiaries = [
  const DiaryEntry(
    id: 'sample-1',
    title: '充実した一日',
    content: '''今日は久しぶりに友人と会ってランチをした。
仕事の話や最近の趣味の話で盛り上がって、
あっという間に3時間も経っていた。
こういう時間って本当に大切だなと思った。''',
    createdAt: DateTime(2025, 1, 14, 10, 30),
    updatedAt: DateTime(2025, 1, 14, 10, 30),
  ),
  const DiaryEntry(
    id: 'sample-2',
    title: '新しいプロジェクト',
    content: '''会社で新しいプロジェクトが始まった。
チームメンバーと初めての顔合わせがあり、
これから一緒に働く仲間との出会いにワクワクしている。''',
    createdAt: DateTime(2025, 1, 12, 14, 0),
    updatedAt: DateTime(2025, 1, 12, 14, 0),
  ),
  const DiaryEntry(
    id: 'sample-3',
    title: '読書の時間',
    content: '''最近読んでいた本を読み終えた。
物語の結末に感動して、しばらく余韻に浸っていた。
次は何を読もうか考えるのも楽しい。''',
    createdAt: DateTime(2025, 1, 8, 20, 15),
    updatedAt: DateTime(2025, 1, 8, 20, 15),
  ),
];
```

## 実装の優先順位

### Phase 1: 最小限の機能（MVP）

1. データモデルの実装（Freezed）
2. Firebase プロジェクトのセットアップ
3. Firestore による永続化
4. 日記一覧画面（読み取りのみ）
5. 日記詳細画面（読み取りのみ）

### Phase 2: CRUD機能

1. 日記作成画面
2. 日記編集機能
3. 日記削除機能
4. バリデーション

### Phase 3: UX改善

1. ローディング状態の表示
2. エラーハンドリング
3. 空の状態の表示
4. 確認ダイアログ

## 第5章以降への接続

本仕様に基づいて実装された日記アプリに、以下の AI 機能を追加していきます：

- **第5章**: Firebase AI Logic SDK を使ったテキスト生成
  - 日記詳細画面に「AI フィードバック」ボタンを追加
  - ストリーミング応答の実装
  - マルチターンチャット機能
  
- **第6章**: 構造化出力
  - 日記の感情分析
  - タグの自動生成

- **第7章以降**: LLMOps、Genkit バックエンド、RAG、AI Agent など

## 参考実装

本仕様に基づいたサンプルコードは、以下のリポジトリで公開予定です：

- GitHub: `[リポジトリURL]`
- ブランチ: `chapter-05-base`

読者は本仕様書を参照しながら、自分でアプリを実装するか、サンプルコードをクローンして第5章以降に進むことができます。
