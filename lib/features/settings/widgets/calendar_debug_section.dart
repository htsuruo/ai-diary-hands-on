import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ai_diary_hands_on/features/calendar_integration/google_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:tsuruo_kit/widgets/widgets.dart';

import 'debug_list_tile.dart';
import 'debug_section.dart';

/// カレンダーAPIデバッグ機能を提供するセクション
class CalendarDebugSection extends ConsumerWidget {
  const CalendarDebugSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DebugSection(
      title: 'カレンダーAPI',
      children: [
        const _AuthorizationTile(),
        DebugListTile(
          icon: Icons.event_note,
          title: '予定取得テスト',
          onTap: () async {
            final events = await ref
                .read(progressProvider.notifier)
                .runWithProgress(
                  () async {
                    return <Event>[];
                    // TODO: 差し替え
                    // ref
                    //   .read(calendarApiServiceProvider)
                    //   .fetchUpcomingEvents()
                  },
                );

            if (events.isEmpty) {
              await showOkAlertDialog(
                context: context,
                title: '予定取得',
                message: '取得できる予定がありませんでした。',
              );
              return;
            }

            await showOkAlertDialog(
              context: context,
              title: '予定取得',
              message: events
                  .map(
                    (e) => '・${e.summary} (${e.start?.dateTime?.toLocal()})',
                  )
                  .join('\n'),
            );
          },
        ),
        DebugListTile(
          icon: Icons.event_available,
          title: '登録テスト',
          onTap: () async {
            final event = await ref
                .read(progressProvider.notifier)
                .runWithProgress(
                  () async {
                    return null;
                    // TODO: 差し替え
                    // ref
                    //     .read(calendarAiAssistantProvider)
                    //     .createEventIfNeeded(
                    //       content: '明日は18:00から友達とディナーの予定があるので楽しみだ。',
                    //     )
                  },
                );

            await showOkAlertDialog(
              context: context,
              title: '登録完了',
              message:
                  '${event.title} (${event.startTime.toLocal()})で予定を登録しました。',
            );
          },
        ),
      ],
    );
  }
}

/// カレンダー認可状態を表示・操作するタイル
class _AuthorizationTile extends ConsumerWidget {
  const _AuthorizationTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessToken = ref.watch(googleUserAccessTokenProvider).value;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAuthorized = accessToken != null;

    return ListTile(
      leading: DebugIconContainer(
        icon: Icons.calendar_today,
        isActive: isAuthorized,
      ),
      title: const Text('カレンダー認可'),
      trailing: isAuthorized
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : FilledButton.tonal(
              onPressed: () async {
                await ref.read(googleAuthProvider.notifier).authorizeRequest();
              },
              child: const Text('権限をリクエスト'),
            ),
    );
  }
}
