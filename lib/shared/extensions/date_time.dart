import 'package:intl/intl.dart';

extension DateTimeEx on DateTime {
  String get formatted => DateFormat.yMMMd().add_Hms().format(this);

  /// 日付のみの表示用フォーマット（例: Dec 10, 2025）
  String get formattedDate => DateFormat.yMMMd().format(this);

  /// Firestoreに保存する日付文字列（例: 2025-12-10）
  String get dateString => DateFormat('yyyy-MM-dd').format(this);
}
