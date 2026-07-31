import 'package:ai_diary_hands_on/features/sentiment_analysis/sentiment_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class SentimentStateConverter
    implements JsonConverter<SentimentState, Map<String, dynamic>> {
  const SentimentStateConverter();

  @override
  SentimentState fromJson(Map<String, dynamic> json) {
    return SentimentState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(SentimentState state) {
    return state.toJson();
  }
}
