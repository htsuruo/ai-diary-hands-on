# 第5章 ハンズオン仕様書: AI Logicでテキスト生成の基礎

## 概要

本章では、Flutter アプリに Firebase AI Logic SDK を導入し、Gemini API を使った基本的なテキスト生成機能を実装します。日記に対する AI フィードバック機能とマルチターンチャットを通じて、AI を活用したアプリケーション開発の基礎を学びます。

## 前提条件

### 環境

- Flutter SDK: 3.24.0以上
- Dart SDK: 3.5.0以上
- Firebase プロジェクトの作成済み
- Firebase CLI のインストール済み

### 読者の知識レベル

- Flutter での基本的なアプリ開発経験
- Firebase の基本的な理解（プロジェクト作成、FlutterFire のセットアップ経験）
- Dart の基礎知識（async/await、Stream）

## アプリの完成イメージ

### 画面構成

#### 1. 日記一覧画面（既存）

- 日記エントリのリスト表示
- 各エントリには日付、タイトル、本文の抜粋を表示
- タップで日記詳細画面へ遷移

#### 2. 日記詳細画面（本章で実装）

- 日記の全文表示
- **「AI フィードバック」ボタン**（新規実装）
- フィードバック結果の表示エリア
- **「チャットで相談」ボタン**（新規実装）

#### 3. AI チャット画面（本章で実装）

- チャット形式の UI
- ユーザーメッセージと AI メッセージを表示
- テキスト入力欄と送信ボタン
- ストリーミング表示（文字が少しずつ表示される）

### ユーザー体験フロー

#### 基本フロー

1. ユーザーが日記を書く（既存機能）
2. 日記詳細画面で「AI フィードバック」ボタンをタップ
3. AI が日記を読んで共感的なフィードバックを生成（ストリーミング表示）
4. フィードバックを読んだ後、「チャットで相談」ボタンをタップ
5. AI チャット画面に遷移し、フィードバック内容について質問できる
6. 会話履歴が保持され、文脈に沿った対話が可能

#### 具体例：充実した一日の日記

**ステップ1: 日記を書く**

ユーザーが以下の日記を書きます：

```
今日は久しぶりに友人と会ってランチをした。
仕事の話や最近の趣味の話で盛り上がって、
あっという間に3時間も経っていた。
こういう時間って本当に大切だなと思った。
```

**ステップ2-3: AI フィードバックの生成**

日記詳細画面で「AI フィードバック」ボタンをタップすると、ローディングインジケーターが表示され、数秒後に以下のようなフィードバックが生成されます（ストリーミングで文字が徐々に表示される）：

```
友人との楽しい時間を過ごせて良かったですね！
3時間もあっという間に過ぎるほど充実した会話ができたのは、
お互いに心を開いて話せる関係があるからこそですね。
そういった人との繋がりを大切にしているあなたは素敵です。
```

**ステップ4-6: チャットでさらに深掘り**

フィードバックを読んだユーザーが「チャットで相談」ボタンをタップ。AI チャット画面に遷移すると、以下のような対話が可能になります：

```
👤 ユーザー: 「友人との関係を大切にするコツってありますか？」

🤖 AI: 「素敵な質問ですね！あなたのように定期的に会う時間を作ることが
何より大切です。3時間も一緒に過ごせる関係は、お互いを尊重し合っている
証拠ですね。

具体的なコツとしては：
- 月に1回など、定期的に会う予定を立てる
- 近況報告だけでなく、お互いの夢や悩みも共有する
- 相手の話に興味を持って、深く聞くこと

今日のような充実した時間を、これからも大切にしてくださいね。」

👤 ユーザー: 「最近忙しくて会えてない別の友人がいるんですが、
どうしたらいいでしょう？」

🤖 AI: 「忙しい中でも、友人のことを気にかけているのは素晴らしいです。
まずは短いメッセージを送ってみるのはいかがでしょうか。

例えば：
『最近忙しくてなかなか会えないけど、元気にしてる？
落ち着いたら久しぶりにランチでもどう？』

というような軽いメッセージで十分です。あなたのことを思い出してくれた
だけで、相手は嬉しいはずですよ。今日友人と会えたように、
きっとまた良い時間を過ごせる日が来ますよ。」
```

このように、日記の内容を AI が理解した上で、文脈に沿った自然な対話が可能になります。会話履歴は保持されるため、「その友人」「今日の話」といった表現で、前の会話を参照しながら対話を続けられます。

## 実装範囲

### 5.3 セットアップ: Flutter と Firebase AI Logic SDK の導入

#### 実装内容

1. Firebase プロジェクトの作成
2. Flutter プロジェクトへの Firebase の追加（`flutterfire configure`）
3. 必要なパッケージの追加
   - `firebase_core`
   - `firebase_ai`（AI Logic SDK）
   - `flutter_riverpod`（状態管理）
   - `riverpod_annotation`（コード生成）
   - `build_runner`（開発時のみ）
   - `riverpod_generator`（開発時のみ）
4. Firebase の初期化コード
5. Riverpod の基本理解

#### 成果物

- `pubspec.yaml` に依存関係が追加されている
- `lib/firebase_options.dart` が生成されている
- `main.dart` で Firebase と Riverpod が初期化されている
- Riverpod の基本的な使い方を理解している

#### 確認方法

- アプリが起動してエラーが出ないこと
- Firebase コンソールで Flutter アプリが登録されていること

### 5.4 日記の自動要約

#### 実装内容

##### 5.4.1 Riverpod の基本セットアップ

状態管理に Riverpod を導入します。Google の公式 Codelab でも採用されているパターンです。

**パッケージの追加:**

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_ai: ^0.3.0
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1

dev_dependencies:
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.2
```

**main.dart の更新:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // ProviderScopeでアプリ全体をラップ
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

##### 5.4.2 GenerativeModel Provider の作成

`GenerativeModel` を Provider として提供します。

**実装するファイル:**

- `lib/providers/generative_model_provider.dart`（新規作成）

**サンプルコード:**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_ai/firebase_ai.dart';

part 'generative_model_provider.g.dart';

@riverpod
GenerativeModel generativeModel(GenerativeModelRef ref) {
  return FirebaseAI.instance.generativeModel(
    model: 'gemini-2.0-flash-exp',
  );
}
```

**コード生成:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

##### 5.4.3 基本的なテキスト生成 Provider

シンプルなテキスト生成を Riverpod で実装します。

**実装するファイル:**

- `lib/providers/simple_text_provider.dart`（新規作成）

**処理フロー:**

1. `@riverpod` アノテーションで Provider を定義
2. `GenerativeModel` を使ってテキスト生成
3. `AsyncValue` で状態（ローディング、成功、エラー）を管理

**サンプルコード構造:**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'generative_model_provider.dart';

part 'simple_text_provider.g.dart';

@riverpod
class SimpleText extends _$SimpleText {
  @override
  FutureOr<String> build() async {
    // 初期状態は空文字列
    return '';
  }

  Future<void> generate(String prompt) async {
    // ローディング状態に変更
    state = const AsyncValue.loading();
    
    // エラーハンドリング付きでAPI呼び出し
    state = await AsyncValue.guard(() async {
      final model = ref.read(generativeModelProvider);
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? '';
    });
  }
}
```

##### 5.4.4 日記フィードバック Provider

AI に「日記アプリのメンター」としての役割を与え、日記に対して共感的なフィードバックを生成します。

**実装するファイル:**

- `lib/providers/diary_feedback_provider.dart`（新規作成）

**システムプロンプトの内容:**

```
あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 内容に共感し、ポジティブな側面を見つける
- 気づきや学びがあれば指摘する
- 簡潔に2-3文でまとめる
- 親しみやすいトーンで
```

**処理フロー:**

1. 日記 ID をパラメータとする Provider を定義
2. システムプロンプトと日記内容を組み合わせる
3. `AsyncValue.guard()` でエラーハンドリング付きで API 呼び出し
4. `AsyncValue` で状態を管理（loading/data/error）

**サンプルコード:**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'generative_model_provider.dart';

part 'diary_feedback_provider.g.dart';

@riverpod
class DiaryFeedback extends _$DiaryFeedback {
  @override
  FutureOr<String> build(String diaryId) async {
    // 初期状態は空文字列
    return '';
  }

  Future<void> generateFeedback(String diaryContent) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final model = ref.read(generativeModelProvider);
      final prompt = _buildPrompt(diaryContent);
      
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? '';
    });
  }

  String _buildPrompt(String diaryContent) {
    return '''
あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、以下の観点でフィードバックを提供してください:
- 内容に共感し、ポジティブな側面を見つける
- 気づきや学びがあれば指摘する
- 簡潔に2-3文でまとめる
- 親しみやすいトーンで

日記:
$diaryContent
''';
  }
}
```

**UI実装:**

日記詳細画面を `ConsumerWidget` として実装します。

**実装するファイル:**

- `lib/screens/diary_detail_screen.dart`

**サンプルコード:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/diary_feedback_provider.dart';
import '../models/diary_entry.dart';

class DiaryDetailScreen extends ConsumerWidget {
  final DiaryEntry diary;

  const DiaryDetailScreen({required this.diary, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider を監視
    final feedbackAsync = ref.watch(diaryFeedbackProvider(diary.id));

    return Scaffold(
      appBar: AppBar(title: const Text('日記詳細')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日記内容
            Text(
              diary.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            // AIフィードバックボタン
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(diaryFeedbackProvider(diary.id).notifier)
                    .generateFeedback(diary.content);
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AIフィードバック'),
            ),
            const SizedBox(height: 16),
            
            // AsyncValue を使った状態表示
            feedbackAsync.when(
              data: (feedback) {
                if (feedback.isEmpty) return const SizedBox.shrink();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.psychology,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AIフィードバック',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(feedback),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'エラーが発生しました: $error',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(diaryFeedbackProvider(diary.id).notifier)
                              .generateFeedback(diary.content);
                        },
                        child: const Text('再試行'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**画面要素:**

- `ConsumerWidget`: Riverpod の状態を監視できる Widget
- `AsyncValue.when()`: loading/data/error を一括で処理
- `ElevatedButton`: AI フィードバックボタン
- `CircularProgressIndicator`: 生成中の表示（自動）
- `Card` ウィジェット: フィードバック表示エリア

### 5.5 ストリーミング応答

#### 実装内容

AI の応答をリアルタイムに表示するストリーミング機能を実装します。

**実装するファイル:**

- `lib/providers/diary_feedback_stream_provider.dart`（新規作成）

**処理フロー:**

1. `@riverpod` で Stream を返す Provider を定義
2. `generateContentStream()` メソッドでストリーム取得
3. `yield` で部分的なテキストを流す
4. UI 側で StreamProvider を購読し、テキストを逐次更新

**サンプルコード構造:**

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'generative_model_provider.dart';

part 'diary_feedback_stream_provider.g.dart';

@riverpod
class DiaryFeedbackStream extends _$DiaryFeedbackStream {
  @override
  Stream<String> build(String diaryId, String diaryContent) async* {
    final model = ref.read(generativeModelProvider);
    final prompt = _buildPrompt(diaryContent);
    
    final stream = model.generateContentStream([Content.text(prompt)]);
    
    var fullText = '';
    await for (final chunk in stream) {
      fullText += chunk.text ?? '';
      yield fullText; // 累積したテキストを流す
    }
  }

  String _buildPrompt(String diaryContent) {
    return '''
あなたは優しく共感的な日記メンターです。
ユーザーの日記を読んで、共感的なフィードバックを提供してください。

日記:
$diaryContent
''';
  }
}
```

**UI実装:**

ストリーミング用のボタンと表示エリアを追加します。

```dart
class DiaryDetailScreen extends ConsumerWidget {
  final DiaryEntry diary;

  const DiaryDetailScreen({required this.diary, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackAsync = ref.watch(diaryFeedbackProvider(diary.id));

    return Scaffold(
      appBar: AppBar(title: const Text('日記詳細')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... 日記内容
            
            // 通常のフィードバックボタン
            ElevatedButton(
              onPressed: () {
                ref
                    .read(diaryFeedbackProvider(diary.id).notifier)
                    .generateFeedback(diary.content);
              },
              child: const Text('AIフィードバック'),
            ),
            
            // ストリーミングボタン
            ElevatedButton.icon(
              onPressed: () {
                // StreamProvider を再読み込みしてストリーミング開始
                ref.invalidate(diaryFeedbackStreamProvider(diary.id, diary.content));
              },
              icon: const Icon(Icons.stream),
              label: const Text('ストリーミングで生成'),
            ),
            
            // ストリーミング結果の表示
            Consumer(
              builder: (context, ref, child) {
                final streamAsync = ref.watch(
                  diaryFeedbackStreamProvider(diary.id, diary.content),
                );
                
                return streamAsync.when(
                  data: (text) {
                    if (text.isEmpty) return const SizedBox.shrink();
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.stream,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'ストリーミング中...',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(text),
                          ],
                        ),
                      ),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stack) => Text('エラー: $error'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

**画面要素:**

- `StreamProvider`: ストリームを Riverpod で管理
- `AsyncValue.when()`: ストリームの状態を一括処理
- `LinearProgressIndicator`: ストリーミング中の表示
- アニメーション効果（オプション）

### 5.6 マルチターンでチャット

#### 実装内容

会話履歴を保持し、文脈に沿った対話を実現するマルチターンチャット機能を実装します。

**実装するファイル:**

- `lib/models/chat_message.dart`（新規作成）
- `lib/providers/chat_messages_provider.dart`（新規作成）
- `lib/screens/ai_chat_screen.dart`（新規作成）

**データ構造:**

```dart
// models/chat_message.dart
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
```

**チャットメッセージ Provider の実装:**

```dart
// providers/chat_messages_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import '../models/chat_message.dart';
import 'generative_model_provider.dart';

part 'chat_messages_provider.g.dart';

@riverpod
class ChatMessages extends _$ChatMessages {
  @override
  List<ChatMessage> build() {
    // 初期状態は空のリスト
    return [];
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  Future<void> sendMessage(String text) async {
    // ユーザーメッセージを追加
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    addMessage(userMessage);

    // 会話履歴をContentリストに変換
    final history = _buildContentHistory();

    // AIメッセージをストリーミングで取得
    final model = ref.read(generativeModelProvider);
    final chat = model.startChat(history: history);
    
    var aiResponseText = '';
    final stream = chat.sendMessageStream(Content.text(text));
    
    await for (final chunk in stream) {
      aiResponseText += chunk.text ?? '';
      // リアルタイムで更新する場合は、一時的なメッセージを追加
    }

    // 最終的なAIメッセージを追加
    final aiMessage = ChatMessage(
      text: aiResponseText,
      isUser: false,
      timestamp: DateTime.now(),
    );
    addMessage(aiMessage);
  }

  List<Content> _buildContentHistory() {
    final contents = <Content>[];
    for (final message in state) {
      if (message.isUser) {
        contents.add(Content.text(message.text));
      } else {
        contents.add(Content.model([TextPart(message.text)]));
      }
    }
    return contents;
  }

  void clear() {
    state = [];
  }
}
```

**UI実装:**

チャット画面を `ConsumerStatefulWidget` として実装します。

```dart
// screens/ai_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_messages_provider.dart';
import '../models/chat_message.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  final String initialDiaryContent;
  final String initialFeedback;

  const AIChatScreen({
    required this.initialDiaryContent,
    required this.initialFeedback,
    super.key,
  });

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 初期コンテキストの設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatMessagesProvider.notifier).addMessage(
            ChatMessage(
              text: '日記: ${widget.initialDiaryContent}',
              isUser: true,
              timestamp: DateTime.now(),
            ),
          );
      ref.read(chatMessagesProvider.notifier).addMessage(
            ChatMessage(
              text: widget.initialFeedback,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() => _isLoading = true);

    try {
      await ref.read(chatMessagesProvider.notifier).sendMessage(text);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AIチャット'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(chatMessagesProvider.notifier).clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // メッセージリスト
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _ChatBubble(message: message);
              },
            ),
          ),
          
          // 入力エリア
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'メッセージを入力...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
```

**画面要素:**

- `ConsumerStatefulWidget`: 状態と Riverpod を併用
- `ListView.builder`: メッセージリスト
- `TextField`: メッセージ入力欄
- `IconButton`: 送信ボタン
- メッセージバブル（カスタムウィジェット）
- 自動スクロール

**初期コンテキスト:**

日記詳細画面から遷移する際に、日記の内容とフィードバックを初期履歴として渡します。これにより、AI は日記の文脈を理解した上で対話できます。

## テストシナリオ

### 基本的なテキスト生成のテスト

1. **正常系**: シンプルなプロンプトでテキストが生成される
2. **エラー系**: ネットワークエラー時にエラーメッセージが表示される

### フィードバック機能のテスト

1. **正常系**: 日記に対して共感的なフィードバックが生成される
2. **長文**: 長い日記でもフィードバックが生成される
3. **短文**: 短い日記でもフィードバックが生成される
4. **エラー系**: API エラー時に適切なエラーメッセージが表示される

### ストリーミング応答のテスト

1. **正常系**: テキストが少しずつ表示される
2. **視覚効果**: ユーザーが「AI が考えている」ことを認識できる
3. **中断**: 画面遷移時にストリームが適切にキャンセルされる

### マルチターンチャットのテスト

1. **正常系**: 前の会話を踏まえた応答が得られる
2. **コンテキスト保持**:「それについてもっと教えて」などの文脈依存の質問が機能する
3. **履歴制限**: 会話が長くなった場合の動作（メモリ管理）
4. **初期化**: 日記とフィードバックが初期コンテキストとして設定されている

## エラーハンドリング

### 対応するエラー

1. **ネットワークエラー**: インターネット接続がない場合
2. **API エラー**: Gemini API がエラーを返す場合
3. **レート制限**: API 呼び出しが制限を超えた場合
4. **タイムアウト**: レスポンスが遅い場合

### エラー表示

- `SnackBar` でエラーメッセージを表示
- リトライボタンの表示
- ユーザーフレンドリーなメッセージ

## パフォーマンス考慮事項

### 応答性

- ストリーミングで体感速度を向上
- ローディング状態を明確に表示

### メモリ管理

- 長い会話履歴の管理（古い履歴の削減）
- Stream の適切な dispose

### ネットワーク最適化

- 不要な API 呼び出しを避ける
- キャンセル可能な処理の実装

## UI/UX ガイドライン

### デザイン原則

- Material Design 3 に準拠
- 読みやすいフォントサイズ（本文: 16sp、フィードバック: 14sp）
- 適切な余白とパディング

### アクセシビリティ

- ボタンに適切なラベル
- 十分なタップ領域（最小44×44pt）
- スクリーンリーダー対応

### フィードバック

- ボタンタップ時の視覚的フィードバック
- ローディング中の明確な表示
- 成功・失敗の明確な通知

## 実装の優先順位

### 必須（MVP）

1. Firebase AI Logic SDK の導入
2. 基本的なテキスト生成
3. システムプロンプトを使ったフィードバック生成
4. ストリーミング応答
5. マルチターンチャット

### 推奨

1. エラーハンドリング
2. ローディング状態の表示
3. UI/UX の改善

### オプション

1. アニメーション効果
2. カスタムテーマ
3. 会話履歴の永続化

## 実装時の注意事項

### セキュリティ

- API キーをクライアントに埋め込まない（Firebase AI Logic を使うことで自動的に対応）
- ユーザー入力のサニタイズ（SQL インジェクション等の対策は不要だが、適切な長さ制限は実装）

### コスト管理

- 不要な API 呼び出しを避ける
- ストリーミングの中断処理を適切に実装

### デバッグ

- ログ出力の実装（`print` または `logger` パッケージ）
- エラー時のスタックトレース取得

## サンプルデータ

### テスト用の日記サンプル

```
今日は久しぶりに友人と会ってランチをした。
仕事の話や最近の趣味の話で盛り上がって、
あっという間に3時間も経っていた。
こういう時間って本当に大切だなと思った。
```

### 期待されるフィードバック例

```
友人との楽しい時間を過ごせて良かったですね！
3時間もあっという間に過ぎるほど充実した会話ができたのは、
お互いに心を開いて話せる関係があるからこそですね。
そういった人との繋がりを大切にしているあなたは素敵です。
```

## 参考資料

### 公式ドキュメント

- [Firebase AI in Dart](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter)
- [Gemini API ドキュメント](https://ai.google.dev/docs)

### サンプルコード

- [Flutter AI Toolkit](https://pub.dev/packages/flutter_ai_toolkit)
- [Google AI Dart SDK Examples](https://github.com/google/generative-ai-dart/tree/main/samples)
