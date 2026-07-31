// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'sentiment_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SentimentState _$SentimentStateFromJson(Map<String, dynamic> json) =>
    _SentimentState(
      sentiment: $enumDecode(_$SentimentEnumMap, json['sentiment']),
      reason: json['reason'] as String,
    );

const _$SentimentStateFieldMap = <String, String>{
  'sentiment': 'sentiment',
  'reason': 'reason',
};

// ignore: unused_element
abstract class _$SentimentStatePerFieldToJson {
  // ignore: unused_element
  static Object? sentiment(Sentiment instance) => _$SentimentEnumMap[instance]!;
  // ignore: unused_element
  static Object? reason(String instance) => instance;
}

Map<String, dynamic> _$SentimentStateToJson(_SentimentState instance) =>
    <String, dynamic>{
      'sentiment': _$SentimentEnumMap[instance.sentiment]!,
      'reason': instance.reason,
    };

const _$SentimentEnumMap = {
  Sentiment.positive: 'positive',
  Sentiment.negative: 'negative',
  Sentiment.neutral: 'neutral',
};
