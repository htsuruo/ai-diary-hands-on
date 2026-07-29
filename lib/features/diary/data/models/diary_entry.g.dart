// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiaryEntry _$DiaryEntryFromJson(Map<String, dynamic> json) => _DiaryEntry(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  feedback: json['feedback'] as String? ?? '',
  date: json['date'] as String,
  createdAt: json['createdAt'] == null
      ? const UnionTimestamp.serverTimestamp()
      : const UnionTimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: json['updatedAt'] == null
      ? const UnionTimestamp.serverTimestamp()
      : const UnionTimestampConverter().fromJson(json['updatedAt'] as Object),
);

const _$DiaryEntryFieldMap = <String, String>{
  'title': 'title',
  'content': 'content',
  'feedback': 'feedback',
  'date': 'date',
  'createdAt': 'createdAt',
  'updatedAt': 'updatedAt',
};

abstract final class _$DiaryEntryJsonKeys {
  static const String title = 'title';
  static const String content = 'content';
  static const String feedback = 'feedback';
  static const String date = 'date';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

// ignore: unused_element
abstract class _$DiaryEntryPerFieldToJson {
  // ignore: unused_element
  static Object? title(String instance) => instance;
  // ignore: unused_element
  static Object? content(String instance) => instance;
  // ignore: unused_element
  static Object? feedback(String instance) => instance;
  // ignore: unused_element
  static Object? date(String instance) => instance;
  // ignore: unused_element
  static Object? createdAt(UnionTimestamp instance) =>
      const UnionTimestampConverter().toJson(instance);
  // ignore: unused_element
  static Object? updatedAt(UnionTimestamp instance) =>
      const UnionTimestampConverter().toJson(instance);
}

Map<String, dynamic> _$DiaryEntryToJson(_DiaryEntry instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'feedback': instance.feedback,
      'date': instance.date,
      'createdAt': const UnionTimestampConverter().toJson(instance.createdAt),
      'updatedAt': const UnionTimestampConverter().toJson(instance.updatedAt),
    };
