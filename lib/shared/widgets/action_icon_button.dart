import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionIconButton extends ConsumerWidget {
  const ActionIconButton({
    super.key,
    required this.iconData,
    required this.color,
    required this.action,
    this.tooltip,
  });

  final IconData iconData;
  final Color color;
  final VoidCallback action;
  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton.filledTonal(
      onPressed: action,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        foregroundColor: color,
        backgroundColor: color.withValues(alpha: 0.12),
      ),
      icon: Icon(iconData),
    );
  }
}
