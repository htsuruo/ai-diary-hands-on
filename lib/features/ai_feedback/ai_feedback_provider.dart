// ignore_for_file: unused_element

import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:ai_diary_hands_on/features/llm_ops/remote_config_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/ai/firebase_ai_provider.dart';

part 'ai_feedback_provider.g.dart';

@riverpod
class AiFeedback extends _$AiFeedback {
  @override
  FutureOr<DiaryEntry> build(DiaryEntry diary) {
    // Providerの初期状態として、引数で受け取ったdiaryインスタンスをそのまま返す
    return diary;
  }

  Future<void> generate() async {
    // 状態をローディング中に更新
    state = const AsyncValue.loading();

    final content = this.diary.content;
    // final userPrompt = _buildUserPrompt(content); // ①
    // final systemInstruction = // ①
    //     await GenerativeModelRole.aiFeedback.systemInstruction;

    // guard を使って非同期処理を実行し、成功/失敗をハンドリング
    state = await AsyncValue.guard(() async {
      final templateId = await ref.watch(
        aiFeedbackTemplateIdProvider.future,
      ); //
      final model = ref.read(firebaseAIProvider).templateGenerativeModel(); // ①
      final responseStream = model.generateContentStream(
        // 'diary-feedback-v1-0-0', // ②
        templateId,
        inputs: {
          'content': content, // ③
        },
      );

      // final model = ref
      //     .read(firebaseAIProvider)
      //     .generativeModel(
      //       model: 'gemini-3.1-flash-lite',
      //       systemInstruction: Content.system(systemInstruction),
      //     );
      // final responseStream = model.generateContentStream([
      //   Content.text(userPrompt),
      // ]);
      // 断片的に流れてくるチャンクを連結するための変数
      var feedback = '';

      await for (final chunk in responseStream) {
        final textChunk = chunk.text;
        if (textChunk != null) {
          feedback += textChunk;
          state = AsyncValue.data(
            this.diary.copyWith(feedback: feedback),
          );
        }
      }
      final newDiary = this.diary.copyWith(feedback: feedback);
      return newDiary;
    });

    if (!state.hasError) {
      // Firestoreへ新しいステートの値を保存
      await ref
          .read(diaryRepositoryProvider.notifier)
          .updateEntry(state.requireValue);
    }
  }
}

String _buildUserPrompt(String content) {
  return '''
ユーザーの日記の内容が次に提供されます。
$content

次の指示に従って、フィードバックを作成してください。

**タスク手順:**
1.  提供された日記の内容を注意深く読み、ユーザーの感情や出来事を理解します。
2.  日記に書かれている主要な感情（例：喜び、悲しみ、ストレス、達成感など）や出来事を特定します。
3.  特定した内容に基づき、共感的でユーザーをサポートするような応答を作成します。

**応答のルール:**
*   **トーン:** 常に親切で、優しく、ポジティブなトーンを心がけてください。
*   **長さ:** 応答は簡潔に、3~5文程度にまとめてください。
*   **内容:** ユーザーの感情や経験を認め、内容に共感し、励ましの言葉や、優しくポジティブな感想を伝えてください。気づきや学び、次に繋がる示唆があれば積極的に含めてください。
*   **禁止事項:** 具体的なアドバイス、批判、分析は絶対にしないでください。共感と励ましに徹し、専門家（医者やカウンセラー）のような言葉遣いは避けてください。
''';
}
