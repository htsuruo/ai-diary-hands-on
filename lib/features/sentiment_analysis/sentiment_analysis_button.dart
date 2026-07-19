import 'package:ai_diary_hands_on/features/diary/data/models/diary_entry.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sentiment_analysis_provider.dart';

class SentimentAnalysisButton extends ConsumerWidget {
  const SentimentAnalysisButton({super.key, required this.diary});

  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ActionIconButton(
      iconData: Icons.sentiment_very_satisfied,
      color: colorScheme.primary,
      action: () async {
        await ref
            .read(sentimentAnalysisProvider(diary: diary).notifier)
            .analyze();
      },
    );
  }
}
