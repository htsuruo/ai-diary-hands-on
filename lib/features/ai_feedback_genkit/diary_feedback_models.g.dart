// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_feedback_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryFeedbackInput _$DiaryFeedbackInputFromJson(Map<String, dynamic> json) =>
    _DiaryFeedbackInput(content: json['content'] as String);

const _$DiaryFeedbackInputFieldMap = <String, String>{'content': 'content'};

// ignore: unused_element
abstract class _$DiaryFeedbackInputPerFieldToJson {
  // ignore: unused_element
  static Object? content(String instance) => instance;
}

Map<String, dynamic> _$DiaryFeedbackInputToJson(_DiaryFeedbackInput instance) =>
    <String, dynamic>{'content': instance.content};

_DiaryFeedbackOutput _$DiaryFeedbackOutputFromJson(Map<String, dynamic> json) =>
    _DiaryFeedbackOutput(
      feedback: json['feedback'] as String,
      sentiment:
          $enumDecodeNullable(_$SentimentEnumMap, json['sentiment']) ??
          Sentiment.neutral,
      isComplete: json['isComplete'] as bool? ?? false,
    );

const _$DiaryFeedbackOutputFieldMap = <String, String>{
  'feedback': 'feedback',
  'sentiment': 'sentiment',
  'isComplete': 'isComplete',
};

// ignore: unused_element
abstract class _$DiaryFeedbackOutputPerFieldToJson {
  // ignore: unused_element
  static Object? feedback(String instance) => instance;
  // ignore: unused_element
  static Object? sentiment(Sentiment instance) => _$SentimentEnumMap[instance]!;
  // ignore: unused_element
  static Object? isComplete(bool instance) => instance;
}

Map<String, dynamic> _$DiaryFeedbackOutputToJson(
  _DiaryFeedbackOutput instance,
) => <String, dynamic>{
  'feedback': instance.feedback,
  'sentiment': _$SentimentEnumMap[instance.sentiment]!,
  'isComplete': instance.isComplete,
};

const _$SentimentEnumMap = {
  Sentiment.positive: 'positive',
  Sentiment.negative: 'negative',
  Sentiment.neutral: 'neutral',
};
