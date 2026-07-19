import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/form_validator.dart';
import 'character_count_badge.dart';

class TitleFormField extends ConsumerWidget {
  const TitleFormField({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: titleController,
      builder: (context, _) {
        final characterCount = titleController.text.length;
        return TextFormField(
          controller: titleController,
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: .w700,
          ),
          textInputAction: .next,
          autofocus: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            filled: false,
            hintText: 'タイトル',
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            visualDensity: .compact,
            contentPadding: .zero,
            counter: CharacterCountBadge(
              currentLength: characterCount,
              maxLength: FormValidator.titleMaxLength,
            ),
          ),
          validator: FormValidator.validateTitle,
        );
      },
    );
  }
}
