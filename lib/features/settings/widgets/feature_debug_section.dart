import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ai_diary_hands_on/features/calendar_integration/calendar_ai_assistant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'debug_list_tile.dart';
import 'debug_section.dart';

/// 各章で実装する機能の動作確認に使用するセクションです。
class FeatureDebugSection extends ConsumerWidget {
  const FeatureDebugSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DebugSection(
      title: '機能実装デバッグ',
      children: [
        DebugListTile(
          icon: Icons.calendar_month,
          title: 'カレンダー予定追加',
          onTap: () async {
            // A. 関数呼び出しが機能し、予定が追加される想定のテキスト例
            const content =
                '明日の14時から、駅前のカフェで友人と会う約束をした。久しぶりに会えるので楽しみ。';

            // B. 関数呼び出しが発生しない想定のテキスト例
            // const content = '今日のプレゼンはうまくいった。とても嬉しい一日だった。';

            final event = await ref
                .read(calendarAiAssistantProvider)
                .createEventIfNeeded(content: content);
            await showOkAlertDialog(
              context: context,
              title: '結果',
              message: event != null
                  ? '予定が追加されました: ${event.title}'
                  : '予定は追加されませんでした',
            );
          },
        ),
      ],
    );
  }
}
