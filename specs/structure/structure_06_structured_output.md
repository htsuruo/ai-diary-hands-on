# 第6章 ハンズオン構成案: 構造化出力と関数呼び出し

## コンセプト
非構造データ（テキスト）を構造化データ（JSON/型）に変換するプロセスを可視化します。「AI がアプリの関数を呼ぶ」という逆転の制御フローを理解しやすくします。

## 推奨ディレクトリ構成

```
lib/
├── features/
│   ├── sentiment_analysis/         # [NEW] 第6章の新機能
│   │   ├── domain/
│   │   │   └── sentiment.dart          # Freezed モデル (構造化出力の型)
│   │   ├── data/
│   │   │   └── sentiment_prompts.dart  # JSONスキーマ定義を含むプロンプト
│   │   ├── logic/
│   │   │   └── sentiment_service.dart  # 分析ロジック
│   │   └── presentation/
│   │       └── sentiment_chip.dart     # 感情アイコン表示
│   │
│   └── calendar_integration/       # [NEW] 第6章の新機能 (関数呼び出し)
│       ├── domain/
│       │   └── calendar_event.dart     # イベントモデル
│       ├── data/
│       │   └── calendar_tools.dart     # [TIP] Tool定義を分離
│       ├── logic/
│       │   └── calendar_service.dart   # Google Calendar API 連携
│       └── presentation/
│           └── add_event_dialog.dart
```

## 教育的ポイント

### 1. `features/sentiment_analysis/domain/sentiment.dart`
**狙い**: AI の出力を「型安全」に扱う重要性。`json_schema` と Dart のクラス定義の対応関係を学びます。

### 2. `features/calendar_integration/data/calendar_tools.dart`
**狙い**: Tool 定義（関数宣言）を独立させる。AI に見せる「関数のカタログ」と、実際に実行される「関数の実体」の違いを意識させます。
```dart
final addEventTool = FunctionDeclaration(
  'addEvent',
  'カレンダーに予定を追加する',
  Schema.object(...)
);
```

### 3. 実装のステップ
1.  **Schema**: AI に返してほしいデータの形（型）を定義する。
2.  **Tool Definition**: AI が使える道具（関数）を定義する。
3.  **Execution**: AI が道具を使おうとしたら、アプリ側で実行して結果を返すループを実装する。
