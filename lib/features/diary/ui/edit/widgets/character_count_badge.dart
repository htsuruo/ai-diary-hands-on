import 'package:flutter/material.dart';

/// 文字数カウンターバッジ
class CharacterCountBadge extends StatelessWidget {
  const CharacterCountBadge({
    super.key,
    required this.currentLength,
    required this.maxLength,
  });

  final int currentLength;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOverLimit = currentLength > maxLength;

    return Container(
      padding: const .symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isOverLimit
            ? colorScheme.error.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
        borderRadius: .circular(12),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          children: [
            TextSpan(
              text: '$currentLength',
              style: theme.textTheme.labelMedium!.copyWith(
                color: isOverLimit ? colorScheme.error : null,
              ),
            ),
            WidgetSpan(
              alignment: .middle,
              child: Padding(
                padding: const .symmetric(horizontal: 1),
                child: Text(
                  '/',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            TextSpan(
              text: '$maxLength',
            ),
          ],
        ),
      ),
    );
  }
}
