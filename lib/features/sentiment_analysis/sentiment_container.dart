import 'package:ai_diary_hands_on/features/diary/data/models/diary_entry.dart';
import 'package:ai_diary_hands_on/shared/widgets/centered_circular_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'sentiment_analysis_provider.dart';
import 'sentiment_state.dart';
import 'sentiment_ui_extension.dart';

class SentimentContainer extends ConsumerWidget {
  const SentimentContainer({super.key, required this.diary});

  final DiaryEntry diary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(
      sentimentAnalysisProvider(diary: diary),
    );

    final hasNoAnalysis =
        analysisAsync.value == null &&
        analysisAsync.runtimeType == AsyncData<SentimentState?>;

    return hasNoAnalysis
        ? const SizedBox.shrink()
        : switch (analysisAsync) {
            AsyncData(:final value) =>
              value == null
                  ? const SizedBox.shrink()
                  : _SentimentResultBox(
                      backgroundColor: value.sentiment.backgroundColor,
                      child: _SentimentResult(state: value),
                    ),
            AsyncError(:final error) => _SentimentResultBox(
              child: Text('Error: $error'),
            ),
            _ => _SentimentResultBox(
              border: Border.all(color: Colors.grey.shade300),
              child: const CenteredCircularIndicator(),
            ),
          };
  }
}

class _SentimentResultBox extends StatelessWidget {
  const _SentimentResultBox({
    required this.child,
    this.backgroundColor,
    this.border,
  });

  final Widget child;
  final Color? backgroundColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _SentimentResult extends StatelessWidget {
  const _SentimentResult({required this.state});

  final SentimentState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sentiment = state.sentiment;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          sentiment.icon,
          color: sentiment.color,
        ),
        const Gap(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sentiment.label,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(4),
              Text(
                '理由: ${state.reason}',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
