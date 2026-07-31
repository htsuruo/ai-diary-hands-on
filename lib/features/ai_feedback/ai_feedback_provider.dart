import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:ai_diary_hands_on/features/llm_ops/remote_config_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/ai/firebase_ai_provider.dart';

part 'ai_feedback_provider.g.dart';

@riverpod
class AiFeedback extends _$AiFeedback {
  @override
  FutureOr<DiaryEntry> build(DiaryEntry diary) {
    return diary;
  }

  Future<void> generate() async {
    state = const AsyncValue.loading();

    final content = this.diary.content;

    state = await AsyncValue.guard(() async {
      final templateId = await ref.watch(
        aiFeedbackTemplateIdProvider.future,
      );
      // サーバープロンプトテンプレートは実験的APIのため警告を抑制
      // ignore: experimental_member_use
      final model = ref.read(firebaseAIProvider).templateGenerativeModel();
      // ignore: experimental_member_use
      final responseStream = model.generateContentStream(
        templateId,
        inputs: {
          'content': content,
        },
      );

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
      // キャッシュを破棄し、チャット画面などが保存済みのフィードバックを参照できるようにする
      ref.invalidate(diaryProvider(this.diary.id));
    }
  }
}
