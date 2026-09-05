import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:ai_diary_hands_on/features/sentiment_analysis/sentiment_ui_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'diary_feedback_service.dart';

class FeedbackResultWidget extends ConsumerWidget {
  const FeedbackResultWidget({super.key, required this.diary});

  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final output = ref.watch(diaryFeedbackServiceProvider(diary));

    if (output == null) {
      return const SizedBox.shrink();
    }

    final sentiment = output.sentiment;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const .only(top: 8),
      padding: const .all(12),
      decoration: BoxDecoration(
        color: sentiment.backgroundColor,
        borderRadius: .circular(8),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fact_check_outlined,
                size: 20,
                color: colorScheme.tertiary,
              ),
              const Gap(8),
              Text(
                'AIによる日記分析',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: .bold,
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              Icon(sentiment.icon, color: sentiment.color),
              const Gap(8),
              Text(sentiment.label),
              if (!output.isComplete) ...[
                const Gap(8),
                const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ],
          ),
          const Gap(8),
          Text(
            '分析結果をもとにしたフィードバック',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Gap(4),
          Text(output.feedback),
        ],
      ),
    );
  }
}
