import 'package:ai_diary_hands_on/features/sentiment_analysis/sentiment_state.dart';
import 'package:ai_diary_hands_on/shared/extensions/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_converter_helper/json_converter_helper.dart';

import 'json_converter.dart';

part 'diary_entry.freezed.dart';
part 'diary_entry.g.dart';

@freezed
abstract class DiaryEntry with _$DiaryEntry {
  @allJsonConvertersSerializable
  const factory DiaryEntry({
    @JsonKey(includeToJson: false) required String id,
    required String title,
    required String content,
    @Default('') String feedback,
    @SentimentStateConverter() SentimentState? sentimentAnalysis,
    required String date,
    @Default(UnionTimestamp.serverTimestamp()) UnionTimestamp createdAt,
    @Default(UnionTimestamp.serverTimestamp()) UnionTimestamp updatedAt,
  }) = _DiaryEntry;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryFromJson(json);
  const DiaryEntry._();

  factory DiaryEntry.empty() => DiaryEntry(
    id: '',
    title: '',
    content: '',
    date: DateTime.now().dateString,
  );
}
