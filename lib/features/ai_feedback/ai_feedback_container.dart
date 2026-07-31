import 'package:ai_diary_hands_on/core/router/router.dart';
import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../chat/widgets/chat_start_button.dart';
import 'ai_feedback_provider.dart';

class AiFeedbackContainer extends ConsumerWidget {
  const AiFeedbackContainer({super.key, required this.diary});
  final DiaryEntry diary;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme.bodySmall!;
    final aiFeedbackAsync = ref.watch(aiFeedbackProvider(diary));

    final isEmpty = aiFeedbackAsync.value?.feedback.isEmpty ?? true;

    // フィードバックが存在しないか否かの条件分岐
    final hasNoFeedback =
        isEmpty && aiFeedbackAsync.runtimeType == AsyncData<DiaryEntry>;

    return hasNoFeedback
        ? const SizedBox.shrink()
        : Container(
            width: double.infinity,
            padding: const .all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colorScheme.primaryContainer.withValues(alpha: 0.6),
            ),
            child: switch (aiFeedbackAsync) {
              AsyncData(:final value) => Column(
                children: [
                  const _FeedbackHeaderRow(),
                  const Gap(8),
                  Text(value.feedback, style: textTheme),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ChatStartButton(
                      onPressed: () {
                        ChatPageRoute(id: diary.id).push<void>(context);
                      },
                    ),
                  ),
                ],
              ),
              AsyncLoading() => const _GeneratingIndicator(),
              AsyncError(:final error) => _ErrorWidget(error: error),
            },
          );
  }
}

class _FeedbackHeaderRow extends StatelessWidget {
  const _FeedbackHeaderRow();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = colorScheme.primary;
    const iconSize = 20.0;
    return Row(
      children: [
        Icon(
          Icons.auto_awesome,
          size: iconSize,
          color: color,
        ),
        const Gap(8),
        Text(
          'AIからのフィードバック',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: color,
            fontWeight: .w600,
          ),
        ),
      ],
    );
  }
}

class _GeneratingIndicator extends StatelessWidget {
  const _GeneratingIndicator();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        const CenteredCircularIndicator(),
        const Gap(16),
        Text(
          'フィードバックを生成中…',
          style: theme.textTheme.bodySmall!.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Text(
      'エラーが発生しました: $error',
      style: theme.textTheme.bodySmall!.copyWith(
        color: colorScheme.error,
      ),
    );
  }
}
