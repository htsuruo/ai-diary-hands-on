import 'package:freezed_annotation/freezed_annotation.dart';

import 'sentiment.dart';

part 'sentiment_state.freezed.dart';
part 'sentiment_state.g.dart';

@freezed
abstract class SentimentState with _$SentimentState {
  const factory SentimentState({
    required Sentiment sentiment, // ①
    required String reason, // ②
  }) = _SentimentState;
  factory SentimentState.fromJson(Map<String, dynamic> json) =>
      _$SentimentStateFromJson(json);
  const SentimentState._();
}
