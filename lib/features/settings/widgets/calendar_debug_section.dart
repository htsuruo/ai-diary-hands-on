import 'package:ai_diary_hands_on/features/calendar_integration/google_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'debug_list_tile.dart';
import 'debug_section.dart';

/// カレンダーAPIデバッグ機能を提供するセクション
class CalendarDebugSection extends ConsumerWidget {
  const CalendarDebugSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DebugSection(
      title: 'カレンダーAPI',
      children: [
        _AuthorizationTile(),
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
