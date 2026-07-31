import 'package:ai_diary_hands_on/core/utils/logger.dart';
import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'diary_feedback_models.dart';

part 'diary_feedback_service.g.dart';

@Riverpod(keepAlive: true)
class DiaryFeedbackService extends _$DiaryFeedbackService {
  @override
  DiaryFeedbackOutput? build(DiaryEntry diary) => null;

  Future<void> getFeedback() async {
    try {
      final callable = FirebaseFunctions.instanceFor(
        region: 'asia-northeast1',
      ).httpsCallable('diaryFeedback');

      final result = await callable.call<Map<String, dynamic>>(
        DiaryFeedbackInput(content: this.diary.content).toJson(),
      );

      state = DiaryFeedbackOutput.fromJson(result.data);
    } on FirebaseFunctionsException catch (e) {
      // エラーコードとスタックトレースを保持したまま呼び出し元へ伝える
      logger.severe('フィードバックの取得に失敗しました: ${e.code} ${e.message}');
      rethrow;
    }
  }

  Future<void> feedbackStream() async {
    final callable = FirebaseFunctions.instanceFor(
      region: 'asia-northeast1',
    ).httpsCallable('diaryFeedback');

    state = const DiaryFeedbackOutput(feedback: '');

    try {
      final stream = callable.stream<String, Map<Object?, Object?>>(
        DiaryFeedbackInput(content: this.diary.content).toJson(),
      );

      await for (final response in stream) {
        switch (response) {
          case Chunk(:final partialData):
            state = state!.copyWith(
              feedback: state!.feedback + partialData,
            );

          case Result(:final result):
            final json = Map<String, dynamic>.from(result.data);
            state = DiaryFeedbackOutput.fromJson(json).copyWith(
              isComplete: true,
            );
        }
      }
    } on FirebaseFunctionsException catch (e) {
      logger.severe('フィードバックの取得に失敗しました: ${e.code} ${e.message}');
      rethrow;
    }
  }
}
