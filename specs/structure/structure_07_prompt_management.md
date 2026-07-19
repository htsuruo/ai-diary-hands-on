# 第7章 ハンズオン構成案: LLMOps (プロンプト管理)

## コンセプト
ハードコードされたプロンプトをクラウド（Remote Config）に移行し、アプリの再リリースなしで AI の挙動を変える「運用」の視点を導入します。

## 推奨ディレクトリ構成

```
lib/
├── core/
│   ├── config/                     # [NEW] 設定管理
│   │   └── remote_config_service.dart # Remote Config ラッパー
│   └── analytics/                  # [NEW] 分析基盤
│       └── analytics_service.dart     # A/Bテスト用イベント送信
│
├── features/
│   ├── ai_feedback/
│   │   ├── data/
│   │   │   └── feedback_prompts.dart   # [MOD] Remote Config から値を取得するように変更
│   │   └── ...
```

## 教育的ポイント

### 1. `core/config/remote_config_service.dart`
**狙い**: プロンプトを「動的な設定値」として扱う。
```dart
String get feedbackPrompt => 
    _remoteConfig.getString('feedback_prompt') ?? _defaultPrompt;
```

### 2. `features/ai_feedback/data/feedback_prompts.dart` のリファクタリング
**狙い**: 静的な文字列定数から、動的な値の取得への移行。アーキテクチャが整っていれば（第5章で分離していれば）、この変更は `data` 層だけで完結し、UI に影響を与えないことを示します。

### 3. A/B テストのサイクル
1.  **Config**: プロンプトを Remote Config に出す。
2.  **Analytics**: ユーザーの反応（Good/Bad）を計測するコードを入れる。
3.  **Experiment**: Firebase Console で実験を設定する（ここは画面操作メイン）。
