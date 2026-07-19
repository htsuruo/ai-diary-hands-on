import 'package:flutter/material.dart';

class ChatStartButton extends StatelessWidget {
  const ChatStartButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilledButton.tonalIcon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        textStyle: theme.textTheme.labelMedium,
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        padding: const .only(
          left: 24,
          right: 16,
        ),
      ),
      icon: const Icon(Icons.navigate_next),
      label: const Text('チャットで深堀り'),
      iconAlignment: .end,
    );
  }
}
