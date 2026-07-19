import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ai_diary_hands_on/features/calendar_integration/google_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'debug_list_tile.dart';
import 'debug_section.dart';

/// Googleサインインセクションを表示するウィジェット
class GoogleSignInSection extends ConsumerWidget {
  const GoogleSignInSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleUser = ref.watch(googleUserProvider).value;
    final isAuthenticated = googleUser?.authentication != null;

    return DebugSection(
      title: 'Googleサインイン',
      children: [
        _AuthenticationSwitch(
          isAuthenticated: isAuthenticated,
        ),
        if (googleUser != null) ...[
          DebugInfoTile(
            icon: Icons.info,
            label: 'id',
            value: googleUser.id,
          ),
          DebugInfoTile(
            icon: Icons.email,
            label: 'email',
            value: googleUser.email,
          ),
          DebugInfoTile(
            icon: Icons.person,
            label: 'displayName',
            value: googleUser.displayName,
          ),
        ],
      ],
    );
  }
}

class _AuthenticationSwitch extends ConsumerWidget {
  const _AuthenticationSwitch({
    required this.isAuthenticated,
  });

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      title: const Text('認証'),
      secondary: DebugIconContainer(
        icon: isAuthenticated ? Icons.login : Icons.logout,
        isActive: isAuthenticated,
      ),
      value: isAuthenticated,
      onChanged: (value) async {
        if (value) {
          await ref.read(googleAuthProvider.notifier).authenticationRequest();
          return;
        }

        final result = await showOkCancelAlertDialog(
          context: context,
          title: 'サインアウト',
          message: '本当にサインアウトしますか?',
          okLabel: 'サインアウト',
          cancelLabel: 'キャンセル',
        );
        if (result == .ok) {
          await ref.read(googleAuthProvider.notifier).signOut();
        }
      },
    );
  }
}
