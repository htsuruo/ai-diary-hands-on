import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'diary_feedback_service.dart';

class AiFeedbackGenkitButton extends ConsumerWidget {
  const AiFeedbackGenkitButton({super.key, required this.diary});

  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return ActionIconButton(
      iconData: Icons.fact_check_outlined,
      color: colorScheme.tertiary,
      tooltip: '日記を分析してフィードバック',
      action: () async {
        await ref
            .read(diaryFeedbackServiceProvider(diary).notifier)
            .feedbackStream();
      },
    );
  }
}
