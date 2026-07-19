import 'package:ai_diary_hands_on/features/calendar_integration/google_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/widgets.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleUser = ref.watch(googleUserProvider).value;
    final isAuthenticated = googleUser?.authentication != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const .symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const GoogleSignInSection(),
            if (isAuthenticated) ...[
              const CalendarDebugSection(),
            ],
          ],
        ),
      ),
    );
  }
}
