import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/form_validator.dart';
import 'character_count_badge.dart';

class ContentFormField extends ConsumerWidget {
  const ContentFormField({
    super.key,
    required this.contentController,
  });

  final TextEditingController contentController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: contentController,
      builder: (context, _) {
        final characterCount = contentController.text.length;
        return Stack(
          children: [
            TextFormField(
              controller: contentController,
              style: theme.textTheme.bodyLarge,
              expands: true,
              maxLines: null,
              textAlignVertical: .top,
              validator: FormValidator.validateContent,
              decoration: InputDecoration(
                fillColor: colorScheme.surfaceContainer,
                hintText: '本文を書く',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                counterText: '', // デフォルトのカウンターを非表示
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: CharacterCountBadge(
                currentLength: characterCount,
                maxLength: FormValidator.contentMaxLength,
              ),
            ),
          ],
        );
      },
    );
  }
}
