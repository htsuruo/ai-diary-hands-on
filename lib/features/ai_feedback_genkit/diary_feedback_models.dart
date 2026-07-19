import 'package:ai_diary_hands_on/features/sentiment_analysis/sentiment.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_feedback_models.freezed.dart';
part 'diary_feedback_models.g.dart';

@freezed
abstract class DiaryFeedbackInput with _$DiaryFeedbackInput {
  const factory DiaryFeedbackInput({
    required String content, // ①
  }) = _DiaryFeedbackInput;

  factory DiaryFeedbackInput.fromJson(Map<String, dynamic> json) =>
      _$DiaryFeedbackInputFromJson(json);
}

@freezed
abstract class DiaryFeedbackOutput with _$DiaryFeedbackOutput {
  const factory DiaryFeedbackOutput({
    required String feedback, // ②
    @Default(Sentiment.neutral) Sentiment sentiment, // ③
    @Default(false) bool isComplete, // ④
  }) = _DiaryFeedbackOutput;

  factory DiaryFeedbackOutput.fromJson(Map<String, dynamic> json) =>
      _$DiaryFeedbackOutputFromJson(json);
}
