import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';

/// 日記の日付を選択するフィールド
///
/// デフォルトは当日の日付で、タップすると日付ピッカーで変更できる。
class DateFormField extends StatelessWidget {
  const DateFormField({
    super.key,
    required this.dateNotifier,
  });

  /// 選択中の日付（yyyy-MM-dd形式の文字列）
  final ValueNotifier<String?> dateNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: dateNotifier,
      builder: (context, value, _) {
        final date = value != null ? DateTime.parse(value) : DateTime.now();
        return Align(
          alignment: .centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.calendar_today, size: 16),
            label: Text(date.formattedDate),
            onPressed: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (selected != null) {
                dateNotifier.value = selected.dateString;
              }
            },
          ),
        );
      },
    );
  }
}
