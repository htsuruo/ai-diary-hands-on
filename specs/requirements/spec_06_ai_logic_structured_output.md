# 第6章 ハンズオン仕様書: 構造化出力と関数呼び出し

## 概要

本章では、AI が日記の内容を構造化データとして理解し、感情分析やカレンダー登録などの具体的なアクションを実行できるようにします。構造化出力と関数呼び出しを活用し、AI をアプリと連携するインテリジェントなアシスタントに進化させます。

## 前提条件

### 環境

- 第5章のハンズオンが完了していること
- Flutter SDK: 3.24.0 以上
- Firebase AI Logic SDK が導入済み

### 読者の知識レベル

- 第5章で学んだ AI Logic の基礎知識
- Dart の JSON 処理の基礎
- Freezed パッケージの基本的な使い方（または学習意欲）

### 必要なパッケージ

- `freezed` および `freezed_annotation`
- `json_serializable`
- `build_runner`
- `googleapis` (Google Calendar API 用)
- `googleapis_auth` (Google OAuth 用)

## アプリの完成イメージ

### 画面構成

#### 1. 日記詳細画面（拡張）

- 日記の全文表示
- **感情タグ表示エリア**（新規実装）
  - 感情: positive / negative / neutral
  - 感情アイコン（😊 😐 😢）
  - タグの色分け（positive: 緑、negative: 赤、neutral: グレー）
- **「感情分析」ボタン**（新規実装）
- **「カレンダーに登録」ボタン**（新規実装、条件付き表示）

#### 2. 日記一覧画面（拡張）

- 各日記エントリに感情アイコンを表示
- 感情に応じた背景色やアクセントカラー

#### 3. カレンダー登録確認ダイアログ（新規実装）

- 抽出された予定情報の表示
  - タイトル
  - 日時
  - 説明
- 確認ボタンとキャンセルボタン

### ユーザー体験フロー

#### フロー1: 感情分析とタグ付け

##### 基本フロー

1. ユーザーが日記を書く
2. 日記詳細画面で「感情分析」ボタンをタップ
3. AI が日記を分析（ローディング表示）
4. 感情タグ（positive/negative/neutral）とその理由が表示される
5. 感情に応じたアイコンと色が自動で設定される
6. 日記一覧に戻ると、アイコンが反映されている

##### 具体例：プロジェクト成功の日記

**日記内容**

```text
今日はプロジェクトの発表がうまくいって、
チームのみんなから褒められた。
準備を頑張った甲斐があった。
夜は美味しいディナーでお祝い！
```

**感情分析ボタンをタップ**

ローディングインジケーターが表示され、数秒後に以下の結果が表示されます。

**分析結果の表示**

```text
😊 Positive

理由:
プロジェクト成功と周囲からの評価、お祝いなど
ポジティブな出来事が記録されています。
前向きな気持ちが伝わってくる内容ですね。

トピック:
• 仕事
• プロジェクト
• チーム
• お祝い
```

**日記一覧画面での表示**

日記一覧に戻ると、この日記エントリに😊アイコンが付き、背景が薄い緑色に変わります。一目で「良い日だった」と振り返ることができます。

##### 具体例：落ち込んだ日の日記

**日記内容**

```text
仕事でミスをしてしまい、上司に怒られた。
自分の不注意が原因で、チームに迷惑をかけてしまった。
落ち込んでいる。
```

**分析結果**

```text
😢 Negative

理由:
仕事のミスと叱責、自責の念など否定的な感情が
表現されています。辛い経験でしたね。

トピック:
• 仕事
• ミス
• 反省
```

日記一覧では😢アイコンと薄い赤色の背景で表示され、後で見返したときに「この日は大変だったな」と思い出せます。こうした記録も成長の一部として残せます。

#### フロー2: カレンダー予定の自動登録

##### 基本フロー

1. 日記に予定に関する記述がある（例:「明日14時から友達とランチ」）
2. 日記詳細画面で「カレンダーに登録」ボタンをタップ
3. AI が日記から予定情報を抽出
4. 確認ダイアログが表示される（タイトル、日時、説明）
5. ユーザーが「登録」をタップ
6. Google Calendar API 経由でカレンダーに予定が追加される
7. 成功メッセージが表示される

##### 具体例：友人との約束を書いた日記

**日記内容**

```text
明日の午後2時から、駅前のカフェで
大学時代の友人と会う約束をした。
久しぶりに会えるので楽しみ。
3時間くらいゆっくり話したいな。
```

**「カレンダーに登録」ボタンをタップ**

AI が日記を分析し、予定情報を抽出します。数秒後、以下のような確認ダイアログが表示されます。

**確認ダイアログ**

```text
📅 カレンダーに登録しますか？

タイトル:
大学時代の友人とカフェ

開始: 2025年11月17日 14:00
終了: 2025年11月17日 17:00

場所:
駅前のカフェ

説明:
久しぶりに会える友人との約束

[キャンセル] [登録する]
```

**「登録する」をタップ**

Google Calendar に予定が追加され、成功メッセージが表示されます。

```text
✓ カレンダーに登録しました！

Google Calendar で確認する
```

**実際のカレンダーアプリで確認**

Google Calendar アプリを開くと、明日14時〜17時に「大学時代の友人とカフェ」という予定が登録されています。通知も自動で設定されるため、約束を忘れる心配がありません。

##### 予定がない日記の例

**日記内容**

```text
いつか海外旅行に行きたいな。
来年あたり、時間ができたら考えよう。
```

この場合、具体的な日時がないため「カレンダーに登録」ボタンをタップしても「具体的な予定が見つかりませんでした」とメッセージが表示されます。AI は曖昧な表現と具体的な予定を区別できます。

## 実装範囲

### 6.1 構造化出力 - 日記から感情とトピックを自動でタグ付け

#### 実装内容

##### 6.1.1 データモデルの定義（Freezed）

感情分析の結果を表す型安全なデータモデルを定義します。

**実装するファイル:**

- `lib/models/sentiment_analysis.dart`（新規作成）

**データ構造:**

```dart
@freezed
class SentimentAnalysis with _$SentimentAnalysis {
  const factory SentimentAnalysis({
    required Sentiment sentiment,
    required String reason,
    required List<String> topics,
  }) = _SentimentAnalysis;

  factory SentimentAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SentimentAnalysisFromJson(json);
}

enum Sentiment {
  @JsonValue('positive')
  positive,
  @JsonValue('negative')
  negative,
  @JsonValue('neutral')
  neutral,
}
```

**ビルドコマンド:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

##### 6.1.2 JSON スキーマの定義

AI に返してほしい JSON の構造を定義します。

**スキーマ定義:**

```json
{
  "type": "object",
  "properties": {
    "sentiment": {
      "type": "string",
      "enum": ["positive", "negative", "neutral"],
      "description": "日記の全体的な感情"
    },
    "reason": {
      "type": "string",
      "description": "その感情と判断した理由（1-2文）"
    },
    "topics": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "日記の主なトピック（最大3つ）"
    }
  },
  "required": ["sentiment", "reason", "topics"]
}
```

##### 6.1.3 感情分析機能の実装

AI Logic の構造化出力機能を使って感情分析を実装します。

**実装するクラス・メソッド:**

- `AIService` クラスに `analyzeSentiment(String diaryContent)` メソッドを追加

**プロンプト:**

```
日記の内容を読んで、感情を分析してください。
全体的な感情をpositive、negative、neutralのいずれかで判定し、
その理由を簡潔に説明してください。
また、日記の主なトピックを最大3つ抽出してください。
```

**処理フロー:**

1. JSON スキーマを定義
2. `GenerativeModel` に `responseSchema` を指定
3. プロンプトと日記内容を送信
4. レスポンスを JSON としてパース
5. `SentimentAnalysis.fromJson()` でモデルに変換

**サンプルコード構造:**

```dart
Future<SentimentAnalysis> analyzeSentiment(String diaryContent) async {
  final schema = Schema.object(
    properties: {
      'sentiment': Schema.enumString(
        enumValues: ['positive', 'negative', 'neutral'],
        description: '日記の全体的な感情',
      ),
      'reason': Schema.string(
        description: 'その感情と判断した理由',
      ),
      'topics': Schema.array(
        items: Schema.string(),
        description: '日記の主なトピック',
      ),
    },
    requiredProperties: ['sentiment', 'reason', 'topics'],
  );

  final model = FirebaseAI.instance.generativeModel(
    model: 'gemini-2.0-flash-exp',
    generationConfig: GenerationConfig(
      responseSchema: schema,
      responseMimeType: 'application/json',
    ),
  );

  final response = await model.generateContent([Content.text(prompt)]);
  final json = jsonDecode(response.text!);
  return SentimentAnalysis.fromJson(json);
}
```

##### 6.1.4 UI の実装

感情分析結果を視覚的に表示する UI を実装します。

**画面要素:**

- `ElevatedButton`: 感情分析ボタン
- `Card`: 分析結果表示エリア
  - 感情アイコン（`Icon` ウィジェット）
  - 感情テキスト（positive / negative / neutral）
  - 理由テキスト
  - トピックチップ（`Chip` ウィジェット）

**感情アイコンのマッピング:**

```dart
IconData getSentimentIcon(Sentiment sentiment) {
  switch (sentiment) {
    case Sentiment.positive:
      return Icons.sentiment_satisfied;
    case Sentiment.negative:
      return Icons.sentiment_dissatisfied;
    case Sentiment.neutral:
      return Icons.sentiment_neutral;
  }
}

Color getSentimentColor(Sentiment sentiment) {
  switch (sentiment) {
    case Sentiment.positive:
      return Colors.green;
    case Sentiment.negative:
      return Colors.red;
    case Sentiment.neutral:
      return Colors.grey;
  }
}
```

##### 6.1.5 データの永続化

分析結果を日記データと一緒に保存します。

**実装:**

- 日記モデルに `sentimentAnalysis` フィールドを追加
- ローカルストレージまたは Firestore に保存
- 日記一覧画面で感情アイコンを表示

### 6.2 関数呼び出し - 感情分析を元にアイコンを変える

この機能は実質的に 6.1 で実装されているため、ここでは「関数呼び出し」の概念説明と簡単な例を示します。

#### 実装内容

##### 6.2.1 関数宣言の基礎

AI に「アイコンを変更する」という関数を宣言します（実際には Flutter 側で実装済み）。

**関数宣言の例:**

```dart
final changeIconTool = FunctionDeclaration(
  'changeIcon',
  'ユーザーの感情に基づいてアイコンを変更する',
  Schema.object(
    properties: {
      'sentiment': Schema.enumString(
        enumValues: ['positive', 'negative', 'neutral'],
        description: '検出された感情',
      ),
    },
  ),
);
```

**注意:**
この例では、実際には AI に関数を呼び出させる必要はありません（6.1 で既に感情データを取得しているため）。ここでは次の 6.3 セクションの準備として、関数呼び出しの基礎を理解します。

### 6.3 関数呼び出し API - 日記からカレンダーに予定を登録

#### 実装内容

##### 6.3.1 Google Calendar API のセットアップ

**事前準備:**

1. Google Cloud Console でプロジェクトを作成
2. Google Calendar API を有効化
3. OAuth 2.0 クライアント ID を作成（iOS / Android / Web）
4. `google_sign_in` パッケージで認証を実装

**実装するクラス:**

- `lib/services/calendar_service.dart`（新規作成）

**処理フロー:**

1. Google Sign-In で認証
2. OAuth トークンを取得
3. Calendar API クライアントを初期化

##### 6.3.2 カレンダーイベント追加関数の実装

**実装するメソッド:**

- `CalendarService.addEvent(CalendarEvent event)`

**データ構造:**

```dart
@freezed
class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
}
```

**処理フロー:**

1. `googleapis` パッケージの `CalendarApi` を使用
2. `Event` オブジェクトを作成
3. `events.insert()` で Google Calendar に追加

**サンプルコード構造:**

```dart
class CalendarService {
  final CalendarApi _calendarApi;

  Future<void> addEvent(CalendarEvent event) async {
    final googleEvent = Event(
      summary: event.title,
      description: event.description,
      start: EventDateTime(dateTime: event.startTime),
      end: EventDateTime(dateTime: event.endTime),
    );

    await _calendarApi.events.insert(googleEvent, 'primary');
  }
}
```

##### 6.3.3 関数宣言の定義

AI に「カレンダーに予定を追加する」関数を宣言します。

**関数宣言:**

```dart
final addEventToCalendarTool = FunctionDeclaration(
  'addEventToCalendar',
  '日記の内容からカレンダーに予定を追加する',
  Schema.object(
    properties: {
      'title': Schema.string(
        description: '予定のタイトル',
      ),
      'startTime': Schema.string(
        description: '開始日時（ISO 8601形式）',
      ),
      'endTime': Schema.string(
        description: '終了日時（ISO 8601形式）',
      ),
      'description': Schema.string(
        description: '予定の説明',
      ),
    },
    requiredProperties: ['title', 'startTime', 'endTime'],
  ),
);
```

##### 6.3.4 AI による予定抽出と関数呼び出し

**実装するメソッド:**

- `AIService.extractAndAddCalendarEvent(String diaryContent)`

**処理フロー:**

1. 関数宣言を含む `GenerativeModel` を作成
2. 日記内容から予定を抽出するプロンプトを送信
3. AI が関数呼び出しを返す（`FunctionCall`）
4. `FunctionCall` のパラメータから `CalendarEvent` を構築
5. ユーザーに確認ダイアログを表示
6. 承認されたら `CalendarService.addEvent()` を実行

**プロンプト:**

```
以下の日記から、カレンダーに登録すべき予定があれば抽出してください。
予定がない場合は何もしないでください。

日記:
$diaryContent
```

**サンプルコード構造:**

```dart
Future<CalendarEvent?> extractCalendarEvent(String diaryContent) async {
  final model = FirebaseAI.instance.generativeModel(
    model: 'gemini-2.0-flash-exp',
    tools: [
      Tool(functionDeclarations: [addEventToCalendarTool]),
    ],
  );

  final response = await model.generateContent([Content.text(prompt)]);
  
  // 関数呼び出しが含まれているかチェック
  final functionCalls = response.functionCalls;
  if (functionCalls.isEmpty) {
    return null;
  }

  // 最初の関数呼び出しからパラメータを取得
  final functionCall = functionCalls.first;
  final args = functionCall.args;

  return CalendarEvent(
    title: args['title'] as String,
    startTime: DateTime.parse(args['startTime'] as String),
    endTime: DateTime.parse(args['endTime'] as String),
    description: args['description'] as String?,
  );
}
```

##### 6.3.5 UI の実装

**確認ダイアログの実装:**

```dart
Future<bool?> showCalendarEventDialog(
  BuildContext context,
  CalendarEvent event,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('カレンダーに登録しますか?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('タイトル: ${event.title}'),
          Text('開始: ${_formatDateTime(event.startTime)}'),
          Text('終了: ${_formatDateTime(event.endTime)}'),
          if (event.description != null)
            Text('説明: ${event.description}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('登録'),
        ),
      ],
    ),
  );
}
```

**処理フロー（UI 側）:**

1. 「カレンダーに登録」ボタンをタップ
2. `extractCalendarEvent()` を呼び出し
3. 予定が抽出されたら確認ダイアログを表示
4. ユーザーが「登録」をタップしたら `addEvent()` を実行
5. 成功メッセージを `SnackBar` で表示

### 6.4 統合と UX 改善

#### 実装内容

##### 6.4.1 ローディング状態の管理

非同期処理中のローディング表示を実装します。

**実装方法:**

- `StatefulWidget` で `isLoading` フラグを管理
- ローディング中は `CircularProgressIndicator` を表示
- ボタンを無効化

##### 6.4.2 エラーハンドリング

各処理のエラーハンドリングを実装します。

**エラーケース:**

1. **感情分析失敗**: API エラー、JSON パースエラー
2. **カレンダー認証失敗**: Google Sign-In エラー
3. **予定追加失敗**: Calendar API エラー、ネットワークエラー

**エラー表示:**

```dart
void _showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: '閉じる',
        textColor: Colors.white,
        onPressed: () {},
      ),
    ),
  );
}
```

##### 6.4.3 成功フィードバック

処理成功時のフィードバックを実装します。

**実装:**

- 感情分析成功: アニメーションでタグが表示される
- カレンダー登録成功: 成功メッセージと Google Calendar へのリンク

## テストシナリオ

### 感情分析機能のテスト

1. **ポジティブな日記**: positive と判定される
2. **ネガティブな日記**: negative と判定される
3. **中立的な日記**: neutral と判定される
4. **複数トピック**: 適切にトピックが抽出される
5. **エラー系**: API エラー時に適切なメッセージが表示される

### カレンダー登録機能のテスト

1. **明確な予定**:「明日14時から友達とランチ」→ 正しく抽出される
2. **予定なし**: カレンダーボタンが表示されない、または「予定が見つかりません」
3. **曖昧な予定**:「いつか映画を見たい」→ 予定として抽出されない
4. **複数の予定**: 最初の予定が抽出される
5. **キャンセル**: 確認ダイアログでキャンセルできる
6. **エラー系**: Calendar API エラー時に適切なエラーメッセージ

### UI/UX のテスト

1. **ローディング表示**: 分析中にインジケーターが表示される
2. **ボタン無効化**: 処理中はボタンがタップできない
3. **感情アイコン**: 感情に応じたアイコンと色が表示される
4. **確認ダイアログ**: 予定情報が正しく表示される

## エラーハンドリング

### 対応するエラー

#### 感情分析関連

1. **JSON パースエラー**: スキーマに従わないレスポンス
2. **API エラー**: Gemini API の呼び出し失敗
3. **ネットワークエラー**: インターネット接続なし

#### カレンダー登録関連

1. **認証エラー**: Google Sign-In の失敗
2. **権限エラー**: Calendar API のアクセス権限なし
3. **API エラー**: Calendar API の呼び出し失敗
4. **日時パースエラー**: 不正な日時フォーマット

### エラーメッセージ例

```dart
static const errorMessages = {
  'sentiment_analysis_failed': '感情分析に失敗しました。もう一度お試しください。',
  'calendar_auth_failed': 'Google アカウントでのログインに失敗しました。',
  'calendar_add_failed': 'カレンダーへの登録に失敗しました。',
  'network_error': 'インターネット接続を確認してください。',
  'no_event_found': '日記から予定を見つけることができませんでした。',
};
```

## パフォーマンス考慮事項

### API 呼び出しの最適化

- 不要な分析を避ける（キャッシュの活用）
- 複数の分析を並列実行しない（順次実行）

### UI の応答性

- ローディング状態を即座に表示
- 分析結果をアニメーションで表示

### データサイズ

- 日記の長さ制限（トークン数考慮）
- 大きすぎる日記は要約してから分析

## UI/UX ガイドライン

### デザイン原則

- 感情に応じた色使い（positive: 緑系、negative: 赤系、neutral: グレー系）
- Material Design 3 の色システムを活用
- アクセシビリティを考慮した色のコントラスト

### インタラクション

- ボタンタップのフィードバック（ripple effect）
- ローディング中の視覚的フィードバック
- 成功・失敗の明確な通知

### 情報階層

- 感情アイコン: 最も目立つ位置
- 理由テキスト: 補足情報として表示
- トピックチップ: スクロール可能なリスト

## 実装の優先順位

### 必須（MVP）

1. Freezed によるデータモデル定義
2. 構造化出力による感情分析
3. 感情アイコンと色の表示
4. Google Calendar API の基本的な連携
5. 関数呼び出しによる予定抽出
6. 確認ダイアログと予定登録

### 推奨

1. エラーハンドリング
2. ローディング状態の表示
3. 成功フィードバック
4. トピックチップの表示

### オプション

1. アニメーション効果
2. 予定の編集機能
3. 複数予定の一括登録
4. カレンダー選択（複数カレンダー対応）

## 実装時の注意事項

### セキュリティ

- OAuth トークンの安全な保存
- Calendar API の適切な権限スコープ
- ユーザー確認なしに予定を登録しない

### プライバシー

- ユーザーデータの適切な取り扱い
- 感情分析結果の永続化時の配慮

### コスト管理

- 分析のキャッシュ
- 不要な API 呼び出しを避ける

## サンプルデータ

### 感情分析用の日記サンプル

**Positive:**

```
今日はプロジェクトの発表がうまくいって、
チームのみんなから褒められた。
準備を頑張った甲斐があった。
夜は美味しいディナーでお祝い！
```

**期待される分析結果:**

```json
{
  "sentiment": "positive",
  "reason": "プロジェクト成功と周囲からの評価、お祝いなどポジティブな出来事が記録されている",
  "topics": ["仕事", "プロジェクト", "チーム", "お祝い"]
}
```

**Negative:**

```
仕事でミスをしてしまい、上司に怒られた。
自分の不注意が原因で、チームに迷惑をかけてしまった。
落ち込んでいる。
```

**期待される分析結果:**

```json
{
  "sentiment": "negative",
  "reason": "仕事のミスと叱責、自責の念など否定的な感情が表現されている",
  "topics": ["仕事", "ミス", "反省"]
}
```

### カレンダー登録用の日記サンプル

```
明日の午後2時から、駅前のカフェで大学時代の友人と会う約束をした。
久しぶりに会えるので楽しみ。
3時間くらいゆっくり話したいな。
```

**期待される抽出結果:**

```json
{
  "title": "大学時代の友人とカフェ",
  "startTime": "2025-11-16T14:00:00",
  "endTime": "2025-11-16T17:00:00",
  "description": "駅前のカフェで友人と会う"
}
```

## 参考資料

### 公式ドキュメント

- [Firebase AI - Structured Output](https://firebase.google.com/docs/vertex-ai/structured-output)
- [Firebase AI - Function Calling](https://firebase.google.com/docs/vertex-ai/function-calling)
- [Google Calendar API](https://developers.google.com/calendar/api/guides/overview)
- [Freezed パッケージ](https://pub.dev/packages/freezed)

### サンプルコード

- [Function Calling の例](https://github.com/google/generative-ai-dart/tree/main/samples/dart/bin)
