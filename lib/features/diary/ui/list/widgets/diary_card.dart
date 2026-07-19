import 'package:ai_diary_hands_on/core/core.dart';
import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:ai_diary_hands_on/features/sentiment_analysis/sentiment_ui_extension.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DiaryCard extends StatelessWidget {
  const DiaryCard({
    super.key,
    required this.diary,
    required this.onTap,
  });

  final DiaryEntry diary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final analysis = diary.sentimentAnalysis;

    return Card(
      margin: const .only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(12),
        side: BorderSide(
          color: colorScheme.primary.withAlpha(50),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(8),
        child: Padding(
          padding: const .symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      overflow: .ellipsis,
                      diary.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.navigate_next_sharp),
                    visualDensity: .compact,
                    onPressed: () {
                      logger.info('Show diary options');
                    },
                  ),
                ],
              ),
              Text(
                diary.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: .ellipsis,
              ),
              Padding(
                padding: const .symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12),
                    const Gap(2),
                    Text(
                      DateTime.parse(diary.date).formattedDate,
                      style: theme.textTheme.labelMedium,
                    ),
                    const Spacer(),
                    if (analysis != null) ...[
                      Icon(
                        analysis.sentiment.icon,
                        color: analysis.sentiment.color,
                      ),
                      const Gap(8),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
