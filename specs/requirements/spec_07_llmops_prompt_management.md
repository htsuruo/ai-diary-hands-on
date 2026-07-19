# 第7章 ハンズオン仕様書: LLMOps - プロンプト管理と運用改善

## 概要

本章では、AI 機能をデータに基づいて継続的に改善する LLMOps の実践を学びます。Firebase Remote Config を使ったプロンプトの A/B テスト、App Check によるセキュリティ強化、モニタリングを通じた改善サイクルを体験します。

## 前提条件

### 環境

- 第5章、第6章のハンズオンが完了していること
- Firebase プロジェクトの Blaze プラン（従量課金制）に移行済み
- Firebase CLI が最新版

### 読者の知識レベル

- Firebase の基本サービス（Authentication、Firestore）の理解
- A/B テストの基本概念
- 基本的な統計の知識（オプション）

### 必要なパッケージ

- `firebase_remote_config`
- `firebase_app_check`
- `firebase_analytics`

## アプリの完成イメージ

### 画面構成

本章では新しい画面を追加せず、既存機能の改善とバックエンドの強化を行います。

#### 改善点の可視化（開発者向け）

- Remote Config のパラメータが反映されていることを確認できるデバッグ画面（オプション）
- プロンプトのバージョン表示（オプション）

### ユーザー体験フロー

#### 通常のユーザー

ユーザーからは変化が見えませんが、バックエンドでは以下が実現されています:

1. より効果的なプロンプトが自動的に配信される
2. 不正なアクセスがブロックされる
3. パフォーマンスとコストが最適化されている

##### 具体例：プロンプト改善の効果

**改善前のフィードバック（コントロール）**

ユーザーA さんが以下の日記を書きました。

```text
今日は仕事で新しいプロジェクトを任された。
責任が重くてプレッシャーを感じるけど、
やりがいもありそう。頑張ろう。
```

従来のプロンプトでは、このような共感的だが一般的なフィードバックが返されました。

```text
新しいプロジェクトを任されたのですね。
プレッシャーを感じるのは当然ですが、
やりがいを感じられているのは素晴らしいことです。
応援しています！
```

**改善後のフィードバック（バリアントA）**

同じ日記に対して、A/B テストで配信された改善版プロンプトでは、より具体的で実用的なフィードバックが生成されました。

```text
新プロジェクトのリーダーに選ばれたのですね！おめでとうございます。

プレッシャーを感じるのは、それだけ責任を真剣に受け止めている証拠です。
以下を意識すると良いかもしれません：

・まずは小さな成功体験を積み重ねる
・困ったときはチームメンバーに相談する
・自分一人で抱え込まないこと

あなたなら必ずやり遂げられます。一歩ずつ進んでいきましょう！
```

**ユーザーの反応**

ユーザーA さんは改善後のフィードバックに対して「いいね👍」ボタンをタップしました。このアクションが Analytics に記録され、改善版プロンプトの効果が測定されます。

**A/Bテストの結果**

2週間のテスト期間後、Firebase Console で以下のような結果が確認できました。

```text
A/Bテスト結果
実験名: フィードバックプロンプトの最適化
期間: 2025/11/01 - 2025/11/14

コントロール（従来版）
- ユーザー数: 500人
- ポジティブ反応率: 45%
- チャット開始率: 20%

バリアントA（改善版）
- ユーザー数: 500人
- ポジティブ反応率: 68% (+51%改善) ✓
- チャット開始率: 35% (+75%改善) ✓

統計的有意性: 99.5% ✓
推奨: バリアントAを全ユーザーに展開
```

このデータに基づいて、開発者はバリアント A を全ユーザーに展開する決定を下します。

#### 開発者の体験フロー

##### 具体例：プロンプト改善サイクル

**ステップ1: 課題の発見**

Firebase Analytics を確認すると、以下のような傾向が見られました。

```text
イベント分析（過去30日間）

feedback_shown: 10,000回
feedback_positive_reaction: 4,500回（45%）
feedback_negative_reaction: 1,200回（12%）
chat_started: 2,000回（20%）

課題:
ポジティブ反応率が50%を下回っている
チャット開始率が低い（目標30%）
```

**ステップ2: 仮説の立案**

開発者は以下の仮説を立てます。

```text
仮説:
現在のプロンプトは共感的だが、具体的なアドバイスが
不足しているため、ユーザーが「もっと聞きたい」と
思わないのではないか。

改善案:
フィードバックに具体的なアクションや質問を含めることで、
ユーザーのエンゲージメントを高める。
```

**ステップ3: Remote Configで新プロンプトを設定**

Firebase Console で新しいプロンプトを設定します。

```text
パラメータ名: feedback_prompt

コントロール（現行版）:
「あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、共感的なフィードバックを提供してください。」

バリアントA（改善版）:
「あなたは日記コーチです。
ユーザーの日記を読んで、以下を含むフィードバックを提供してください：
1. 内容への共感
2. 具体的な気づきや学び
3. 次のアクションにつながるアドバイス
簡潔に、親しみやすいトーンで。」
```

**ステップ4: A/Bテストの開始**

Remote Config のインタフェースで：

```text
実験名: フィードバックプロンプトの最適化
ターゲット: 全ユーザー
配分: コントロール 50% / バリアントA 50%

目標指標:
- 主要: feedback_positive_reaction（向上）
- 副次: chat_started（向上）

期間: 2週間
```

「実験を開始」ボタンをクリックすると、自動的に新旧プロンプトが A/B テストされます。

**ステップ5: データの確認と判断**

1週間後、中間結果を確認します。

```text
中間レポート（7日目）

ポジティブ反応率:
コントロール: 45%
バリアントA: 67% (+49%改善)
信頼度: 95%

チャット開始率:
コントロール: 20%
バリアントA: 34% (+70%改善)
信頼度: 98%

ステータス: バリアントAが有意に優れている
```

2週間のテスト完了後、「勝者を展開」ボタンをクリックして、改善版を全ユーザーに適用します。

**ステップ6: 継続的な改善**

展開後も引き続きデータを監視し、さらなる改善の余地を探します。

```text
改善サイクル

第1回 A/Bテスト → +51%改善 ✓
第2回 A/Bテスト → さらに+15%改善（計画中）
第3回 A/Bテスト → ...

継続的な改善により、ユーザー満足度を向上
```

このように、LLMOps の実践により、データに基づいた継続的な改善が可能になります。

## 実装範囲

### 7.1 Firebase サービスとの連携で実現する LLMOps

このセクションは理論的な説明が中心で、コード実装はありません。

#### 学習内容

- LLMOps とは何か
- なぜ LLMOps が重要なのか
- Firebase で実現できる LLMOps の要素

### 7.2 商用化のためのチェックリスト

このセクションも主に理論的な内容ですが、一部設定作業が含まれます。

#### 実装内容

##### 7.2.1 Firebase API キーの制限

Firebase プロジェクトの API キーを適切に制限します。

**設定手順:**

1. Google Cloud Console で API キーを選択
2. アプリケーションの制限を設定
   - Android: パッケージ名と SHA-1 フィンガープリント
   - iOS: バンドル ID
   - Web: HTTP リファラー
3. API の制限を設定
   - 必要な API のみを有効化

**確認項目:**

```yaml
API キー制限チェックリスト:
  ✓ Android アプリの SHA-1 フィンガープリントが設定されている
  ✓ iOS アプリのバンドル ID が設定されている
  ✓ 不要な API が無効化されている
  ✓ 本番用とデバッグ用で異なるプロジェクトを使用している
```

##### 7.2.2 モニタリング機能の有効化

Firebase Console でモニタリングを設定します。

**設定項目:**

1. Firebase Console > Vertex AI > 使用状況
2. 以下のメトリクスを確認できることを確認:
   - API 呼び出し回数
   - トークン使用量
   - エラー率
   - レスポンス時間
   - コスト見積もり

**アラート設定（推奨）:**

```yaml
推奨アラート:
  - API 呼び出し回数が想定の 120% を超えた場合
  - エラー率が 5% を超えた場合
  - 1 日のコストが予算を超えた場合
```

##### 7.2.3 Rate Limit の設定

ユーザー単位での API 呼び出し制限を設定します。

**実装方法:**

1. Firebase Security Rules を使用
2. Cloud Functions でカスタム制限を実装（高度）

**Security Rules の例（Firestore ベース）:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/api_usage/{date} {
      allow read, write: if request.auth.uid == userId;
      
      // 1日の呼び出し制限
      allow create: if request.auth.uid == userId 
        && (!exists(/databases/$(database)/documents/users/$(userId)/api_usage/$(date))
        || get(/databases/$(database)/documents/users/$(userId)/api_usage/$(date)).data.count < 100);
    }
  }
}
```

**Flutter 側の実装:**

```dart
class UsageLimiter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<bool> canMakeRequest(String userId) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('api_usage')
        .doc(today);
    
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({'count': 1});
      return true;
    }
    
    final count = doc.data()?['count'] ?? 0;
    if (count >= 100) {
      return false;
    }
    
    await docRef.update({'count': FieldValue.increment(1)});
    return true;
  }
}
```

### 7.3 App Check で不正なクライアントからのリクエストをブロック

#### 実装内容

##### 7.3.1 App Check のセットアップ

**iOS の設定:**

1. Firebase Console で App Check を有効化
2. Device Check プロバイダーを選択
3. アプリに App Check SDK を追加

**Android の設定:**

1. Firebase Console で App Check を有効化
2. Play Integrity プロバイダーを選択
3. Google Play Console でアプリを登録
4. アプリに App Check SDK を追加

**Web の設定:**

1. reCAPTCHA v3 を設定
2. サイトキーとシークレットキーを取得
3. Firebase Console に登録

##### 7.3.2 Flutter アプリへの統合

**パッケージの追加:**

```yaml
dependencies:
  firebase_app_check: ^0.3.0+4
```

**初期化コード:**

```dart
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // App Check の初期化
  await FirebaseAppCheck.instance.activate(
    // iOS: Device Check
    // Android: Play Integrity
    // Web: reCAPTCHA
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
  
  runApp(const MyApp());
}
```

**デバッグモードの設定:**
開発中はデバッグトークンを使用します。

```dart
// デバッグモード時のみ
if (kDebugMode) {
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
}
```

##### 7.3.3 バックエンドの設定

Firebase のバックエンドサービスで App Check を強制します。

**Vertex AI（AI Logic）:**
Firebase Console で App Check の適用を有効化

**Cloud Functions（第9章以降で使用）:**

```typescript
import { onCall } from 'firebase-functions/v2/https';

export const protectedFunction = onCall(
  { enforceAppCheck: true },
  async (request) => {
    // App Check で検証済みのリクエストのみ実行される
    // ...
  }
);
```

##### 7.3.4 動作確認

**テストシナリオ:**

1. **正常系**: アプリから API 呼び出しが成功する
2. **不正リクエスト**: curl などでの直接呼び出しがブロックされる
3. **デバッグモード**: デバッグビルドで動作することを確認

### 7.4 LLMOps はじめの一歩 - プロンプトの管理

#### 実装内容

##### 7.4.1 問題の理解

プロンプトをコードにハードコーディングする問題点を説明します。

**問題点:**

- 変更のたびにアプリの再リリースが必要
- A/B テストができない
- 複数バージョンの管理が困難
- ロールバックが困難

##### 7.4.2 解決策の提示

Firebase Remote Config による動的なプロンプト管理を提案します。

### 7.5 Remote Config でプロンプトや LLM モデルの動的変更

#### 実装内容

##### 7.5.1 Remote Config のセットアップ

**パッケージの追加:**

```yaml
dependencies:
  firebase_remote_config: ^5.1.4
  firebase_analytics: ^11.3.3  # A/B テストに必要
```

**初期化コード:**

```dart
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  
  Future<void> initialize() async {
    // 設定の最小取得間隔を設定（開発時は短く）
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode 
          ? const Duration(seconds: 0)  // デバッグ時は即座に反映
          : const Duration(hours: 1),   // 本番環境では1時間
      ),
    );
    
    // デフォルト値の設定
    await _remoteConfig.setDefaults({
      'feedback_prompt': _defaultFeedbackPrompt,
      'sentiment_analysis_prompt': _defaultSentimentPrompt,
      'model_name': 'gemini-2.0-flash-exp',
      'enable_calendar_feature': true,
    });
    
    // 設定の取得とアクティベート
    await _remoteConfig.fetchAndActivate();
  }
  
  String get feedbackPrompt => _remoteConfig.getString('feedback_prompt');
  String get sentimentPrompt => _remoteConfig.getString('sentiment_analysis_prompt');
  String get modelName => _remoteConfig.getString('model_name');
  bool get enableCalendarFeature => _remoteConfig.getBool('enable_calendar_feature');
}
```

**デフォルトプロンプトの定義:**

```dart
static const _defaultFeedbackPrompt = '''
あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 内容に共感し、ポジティブな側面を見つける
- 気づきや学びがあれば指摘する
- 簡潔に2-3文でまとめる
- 親しみやすいトーンで
''';
```

##### 7.5.2 Firebase Console での設定

**手順:**

1. Firebase Console > Remote Config
2. パラメータの追加:
   - `feedback_prompt` (文字列): フィードバック用プロンプト
   - `sentiment_analysis_prompt` (文字列): 感情分析用プロンプト
   - `model_name` (文字列): 使用するモデル名
   - `enable_calendar_feature` (ブール値): カレンダー機能の ON/OFF

3. 各パラメータに値を設定
4. 変更を公開

##### 7.5.3 アプリコードの更新

既存の AI サービスを Remote Config 対応に変更します。

**AIService の更新:**

```dart
class AIService {
  final RemoteConfigService _configService;
  
  AIService(this._configService);
  
  Future<String> generateFeedback(String diaryContent) async {
    // Remote Config からプロンプトを取得
    final systemPrompt = _configService.feedbackPrompt;
    final modelName = _configService.modelName;
    
    final model = FirebaseAI.instance.generativeModel(
      model: modelName,
    );
    
    final prompt = '''
$systemPrompt

日記:
$diaryContent
    ''';
    
    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? '';
  }
  
  Future<SentimentAnalysis> analyzeSentiment(String diaryContent) async {
    final systemPrompt = _configService.sentimentPrompt;
    final modelName = _configService.modelName;
    
    // ... 実装
  }
}
```

**機能フラグの活用:**

```dart
class DiaryDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configService = context.read<RemoteConfigService>();
    
    return Scaffold(
      body: Column(
        children: [
          // ... 既存の UI
          
          // Remote Config で機能の ON/OFF を制御
          if (configService.enableCalendarFeature)
            ElevatedButton(
              onPressed: _addToCalendar,
              child: const Text('カレンダーに登録'),
            ),
        ],
      ),
    );
  }
}
```

##### 7.5.4 A/B テストの設定

**Firebase Console での設定:**

1. **実験の作成**
   - Remote Config > A/B テスト > 実験を作成
   - 実験名:「フィードバックプロンプトの最適化」

2. **ターゲティング**
   - 対象ユーザー: アプリのすべてのユーザー
   - ユーザー割合: 100%

3. **バリアントの設定**
   - コントロール（既存）: 50%

     ```
     あなたは優しく共感的な日記メンターです。
     ユーザーの日記を読んで、共感的なフィードバックを提供してください。
     ```

   - バリアント A（具体的）: 50%

     ```
     あなたは日記コーチです。
     ユーザーの日記を読んで、具体的な気づきや学びを指摘してください。
     アクションにつながるフィードバックを心がけてください。
     ```

4. **目標の設定**
   - 主要指標: `feedback_positive_reaction`（カスタムイベント）
   - 副次指標: `chat_started`（チャット画面への遷移）

##### 7.5.5 Analytics イベントの実装

A/B テストの効果測定のため、Analytics イベントを送信します。

**パッケージの追加（既に追加済みの場合はスキップ）:**

```yaml
dependencies:
  firebase_analytics: ^11.3.3
```

**イベント送信の実装:**

```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // フィードバックが表示されたとき
  Future<void> logFeedbackShown() async {
    await _analytics.logEvent(
      name: 'feedback_shown',
      parameters: null,
    );
  }
  
  // ユーザーがフィードバックに「いいね」したとき
  Future<void> logFeedbackPositiveReaction() async {
    await _analytics.logEvent(
      name: 'feedback_positive_reaction',
      parameters: null,
    );
  }
  
  // チャットを開始したとき
  Future<void> logChatStarted() async {
    await _analytics.logEvent(
      name: 'chat_started',
      parameters: null,
    );
  }
  
  // フィードバックに「いまいち」と反応したとき
  Future<void> logFeedbackNegativeReaction() async {
    await _analytics.logEvent(
      name: 'feedback_negative_reaction',
      parameters: null,
    );
  }
}
```

**UI への組み込み:**

```dart
class FeedbackWidget extends StatelessWidget {
  final String feedback;
  
  @override
  Widget build(BuildContext context) {
    final analytics = context.read<AnalyticsService>();
    
    // フィードバックが表示された
    analytics.logFeedbackShown();
    
    return Card(
      child: Column(
        children: [
          Text(feedback),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  analytics.logFeedbackPositiveReaction();
                },
              ),
              IconButton(
                icon: const Icon(Icons.thumb_down),
                onPressed: () {
                  analytics.logFeedbackNegativeReaction();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

##### 7.5.6 A/B テストの結果分析

**Firebase Console での確認手順:**

1. Remote Config > A/B テスト > 実験名をクリック
2. 結果を確認:
   - コントロール vs バリアント A の比較
   - 各指標の改善率
   - 統計的有意性

**判断基準:**

```yaml
実験成功の基準:
  ✓ feedback_positive_reaction が 10% 以上向上
  ✓ 統計的有意性が 95% 以上
  ✓ 副次指標（chat_started）が悪化していない
```

**次のアクション:**

- 成功: バリアント A を全ユーザーに展開
- 失敗: コントロールを継続、新しい仮説でテスト
- 不明確: サンプルサイズを増やして継続

##### 7.5.7 本番展開

A/B テストで勝者が決定したら本番展開します。

**手順:**

1. A/B テスト画面で「勝者を展開」をクリック
2. Remote Config のデフォルト値を更新
3. アプリコードのデフォルト値も更新（次回リリース時）

## テストシナリオ

### API キー制限のテスト

1. **正常系**: 正規のアプリから API 呼び出しが成功する
2. **異常系**: 不正なパッケージ名からの呼び出しがブロックされる

### App Check のテスト

1. **正常系**: アプリから API 呼び出しが成功する
2. **異常系**: curl での直接呼び出しが HTTP 401 エラーになる
3. **デバッグ**: デバッグモードで動作する

### Remote Config のテスト

1. **初期化**: アプリ起動時にデフォルト値が読み込まれる
2. **取得**: サーバーから最新の値が取得される
3. **反映**: プロンプトが変更されて AI の応答が変わる
4. **機能フラグ**: カレンダー機能の ON/OFF が反映される

### A/B テストのテスト

1. **バリアント分割**: ユーザーがランダムに振り分けられる
2. **イベント送信**: Analytics イベントが正しく送信される
3. **一貫性**: 同じユーザーは同じバリアントを受け取り続ける

### Rate Limit のテスト

1. **正常系**: 制限内の呼び出しは成功する
2. **制限超過**: 制限を超えるとエラーメッセージが表示される
3. **リセット**: 翌日になるとカウンターがリセットされる

## エラーハンドリング

### Remote Config 関連

1. **取得失敗**: デフォルト値を使用
2. **タイムアウト**: デフォルト値を使用、バックグラウンドで再試行
3. **パースエラー**: デフォルト値にフォールバック

### App Check 関連

1. **トークン取得失敗**: リトライ処理
2. **検証失敗**: ユーザーフレンドリーなエラーメッセージ
3. **デバッグモード**: 開発中はエラーをログ出力

### Rate Limit 関連

1. **制限超過**:「本日の利用上限に達しました。明日またお試しください」
2. **Firestore エラー**: エラーメッセージとリトライボタン

## パフォーマンス考慮事項

### Remote Config の最適化

- 起動時に一度だけ取得
- バックグラウンドで定期的に更新
- キャッシュを活用

### App Check の最適化

- トークンの自動更新を活用
- 失敗時のリトライ間隔を適切に設定

### Rate Limit の最適化

- クライアント側でもカウントを保持（Firestore の読み取りを削減）
- バッチ処理でカウントを更新

## UI/UX ガイドライン

### エラーメッセージ

ユーザーフレンドリーで具体的なメッセージを表示します。

```dart
static const userFriendlyErrors = {
  'app_check_failed': '認証に失敗しました。アプリを最新版に更新してください。',
  'rate_limit_exceeded': '本日の利用上限に達しました。明日 0:00 以降に再度お試しください。',
  'config_fetch_failed': '設定の取得に失敗しました。インターネット接続を確認してください。',
};
```

### フィードバック収集

A/B テスト用のフィードバック UI を実装します。

- シンプルな👍/👎ボタン
- 目立ちすぎない配置
- タップ後の視覚的フィードバック

## 実装の優先順位

### 必須（MVP）

1. Remote Config の基本実装
2. プロンプトの動的配信
3. App Check の導入
4. Analytics イベントの実装

### 推奨

1. A/B テストの実施
2. Rate Limit の実装
3. モニタリングダッシュボードの確認

### オプション

1. カスタムダッシュボードの構築
2. Slack/メール通知の設定
3. 高度な Rate Limit（Cloud Functions）

## 実装時の注意事項

### セキュリティ

- App Check のデバッグトークンを本番環境に含めない
- API キーの制限を必ず設定
- Rate Limit を適切に設定

### コスト管理

- Remote Config の取得頻度を適切に設定
- 不要な Analytics イベントを送信しない
- Firestore の読み書きを最適化

### ユーザー体験

- エラー時も機能を継続できるようフォールバックを実装
- 変更がユーザーに気づかれないようスムーズに反映

## 検証方法

### 開発者向けツール

Remote Config の値を確認できるデバッグ画面を実装します（オプション）。

```dart
class DebugConfigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = context.watch<RemoteConfigService>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Config デバッグ')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Model Name'),
            subtitle: Text(config.modelName),
          ),
          ListTile(
            title: const Text('Feedback Prompt'),
            subtitle: Text(config.feedbackPrompt),
          ),
          ListTile(
            title: const Text('Calendar Feature'),
            subtitle: Text(config.enableCalendarFeature.toString()),
          ),
          ElevatedButton(
            onPressed: () async {
              await config.initialize();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('設定を再取得しました')),
              );
            },
            child: const Text('設定を再取得'),
          ),
        ],
      ),
    );
  }
}
```

## サンプルデータ

### A/B テスト用のプロンプトバリアント

**コントロール（共感重視）:**

```
あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 内容に共感し、ポジティブな側面を見つける
- 簡潔に2-3文でまとめる
- 親しみやすいトーンで
```

**バリアント A（具体的アドバイス）:**

```
あなたは実践的な日記コーチです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 具体的な気づきや学びを指摘する
- 次のアクションにつながる提案をする
- 2-3文で簡潔に
```

**バリアント B（質問形式）:**

```
あなたは思考を深める日記ガイドです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 内容を深く考えさせる質問をする
- 新しい視点を提示する
- 2-3文で簡潔に
```

## 参考資料

### 公式ドキュメント

- [Firebase Remote Config](https://firebase.google.com/docs/remote-config)
- [Firebase A/B Testing](https://firebase.google.com/docs/ab-testing)
- [Firebase App Check](https://firebase.google.com/docs/app-check)
- [Firebase Analytics](https://firebase.google.com/docs/analytics)

### ベストプラクティス

- [LLMOps: Operational Practices for Large Language Models](https://www.oreilly.com/library/view/llmops-operational-practices/9781098144234/)
