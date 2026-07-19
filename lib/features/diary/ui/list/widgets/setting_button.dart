import 'package:ai_diary_hands_on/core/core.dart';
import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return IconButton(
      icon: const Icon(Icons.settings),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHigh,
      ),
      onPressed: () {
        SettingsPageRoute().push<void>(context);
      },
    );
  }
}
