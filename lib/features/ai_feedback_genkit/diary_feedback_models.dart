import 'package:ai_diary_hands_on/features/sentiment_analysis/sentiment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_feedback_models.freezed.dart';
part 'diary_feedback_models.g.dart';

@freezed
abstract class DiaryFeedbackInput with _$DiaryFeedbackInput {
  const factory DiaryFeedbackInput({
    required String content,
  }) = _DiaryFeedbackInput;

  factory DiaryFeedbackInput.fromJson(Map<String, dynamic> json) =>
      _$DiaryFeedbackInputFromJson(json);
}

@freezed
abstract class DiaryFeedbackOutput with _$DiaryFeedbackOutput {
  const factory DiaryFeedbackOutput({
    required String feedback,
    @Default(Sentiment.neutral) Sentiment sentiment,
    @Default(false) bool isComplete,
  }) = _DiaryFeedbackOutput;

  factory DiaryFeedbackOutput.fromJson(Map<String, dynamic> json) =>
      _$DiaryFeedbackOutputFromJson(json);
}
