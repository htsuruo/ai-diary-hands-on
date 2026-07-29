import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:firebase_ai/firebase_ai.dart';
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

    final prompt = '日記の内容についてフィードバックしてください。\n内容: ${this.diary.content}';

    state = await AsyncValue.guard(() async {
      final model = ref
          .read(firebaseAIProvider)
          .generativeModel(
            model: 'gemini-3.1-flash-lite',
          );
      final response = await model.generateContent([Content.text(prompt)]);
      final feedback = response.text ?? '';

      return this.diary.copyWith(feedback: feedback);
    });
  }
}
