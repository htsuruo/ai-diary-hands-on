# 第5章 ハンズオン構成案: AI Logic 基礎

## コンセプト
「AI の魔法」を UI コードから分離し、読者が AI のロジック（プロンプトとモデル設定）に集中できるようにします。

## 推奨ディレクトリ構成

```
lib/
├── core/
│   ├── ai/                         # [NEW] AI 共通設定
│   │   └── generative_model_provider.dart  # モデル定義（Ch5, 6, 9...で再利用）
│   └── ...
├── features/
│   ├── diary/                      # 既存機能
│   │   └── ...
│   │
│   ├── ai_feedback/                # [NEW] 第5章の新機能
│   │   ├── data/
│   │   │   └── feedback_prompts.dart   # [TIP] プロンプトをロジックから分離
│   │   ├── logic/
│   │   │   ├── feedback_provider.dart        # FutureProvider (基本)
│   │   │   └── feedback_stream_provider.dart # StreamProvider (発展)
│   │   └── presentation/
│   │       ├── feedback_card.dart      # UI コンポーネント
│   │       └── feedback_button.dart    # UI コンポーネント
│   │
│   └── chat/                       # [NEW] 第5章の新機能 (Part 2)
│       ├── logic/
│       │   └── chat_notifier.dart      # チャットの状態管理
│       └── presentation/
│           └── chat_page.dart
```

## 教育的ポイント

### 1. `core/ai/generative_model_provider.dart`
**狙い**: AI モデルを「インフラ」として扱う。DB や API クライアントと同様に、DI (Dependency Injection) で管理することを教えます。
```dart
@riverpod
GenerativeModel generativeModel(Ref ref) {
  return FirebaseAI.instance.generativeModel(model: 'gemini-2.0-flash-exp');
}
```

### 2. `features/ai_feedback/data/feedback_prompts.dart`
**狙い**: プロンプトエンジニアリングをコードから切り離す。プロンプトは「コード」であり、バージョン管理や修正のしやすさが重要であることを示します。
```dart
class FeedbackPrompts {
  static String analyzeDiary(String content) => '''
    あなたは共感的なメンターです...
    日記: $content
  ''';
}
```

### 3. 実装のステップ
1.  **Brain (Model)**: `generative_model_provider.dart` で脳を作る。
2.  **Instruction (Prompt)**: `feedback_prompts.dart` で指示書を書く。
3.  **Logic (Provider)**: `feedback_provider.dart` で脳と指示書を繋ぐ。
4.  **UI (Widget)**: 結果を表示する。

この順序で進めることで、各パーツの役割が明確になります。
