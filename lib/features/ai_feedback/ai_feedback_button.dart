import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ai_feedback_provider.dart';

class AiFeedbackButton extends ConsumerWidget {
  const AiFeedbackButton({super.key, required this.diary});

  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ActionIconButton(
      iconData: Icons.auto_awesome,
      color: colorScheme.primary,
      action: ref.read(aiFeedbackProvider(diary).notifier).generate,
    );
  }
}
