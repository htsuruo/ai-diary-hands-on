import 'package:ai_diary_hands_on/features/ai_feedback/ai_feedback_container.dart';
import 'package:ai_diary_hands_on/features/diary/ui/edit/widgets/empty_screen.dart';
import 'package:ai_diary_hands_on/features/sentiment_analysis/sentiment_container.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../diary.dart';
import 'action_buttons.dart';
import 'diary_detail_view_model.dart';

class DiaryDetailPage extends ConsumerWidget {
  const DiaryDetailPage({
    required this.diaryId,
    super.key,
  });

  final String diaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryAsync = ref.watch(diaryDetailViewModelProvider(diaryId));

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const .symmetric(horizontal: 8),
            child: ActionButtons(diaryId: diaryId),
          ),
        ],
      ),
      body: switch (diaryAsync) {
        AsyncLoading() => const CenteredCircularIndicator(),
        AsyncValue(error: final error?) => Text('Error: $error'),
        AsyncValue(:final value) =>
          value == null ? const EmptyScreen() : _Body(diary: value),
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.diary});

  final DiaryEntry diary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const .symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // タイトル
            Text(
              diary.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: .bold,
              ),
            ),
            // 作成日時・更新日時
            Padding(
              padding: const .symmetric(vertical: 8),
              child: _DateTimeInfo(
                date: DateTime.parse(diary.date),
                createdAt: diary.createdAt.dateOrNow,
                updatedAt: diary.updatedAt.dateOrNow,
              ),
            ),
            SentimentContainer(diary: diary),
            AiFeedbackContainer(diary: diary),
            // 本文
            Text(
              diary.content,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
                letterSpacing: 1.2,
              ),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}

/// 日時情報表示ウィジェット
class _DateTimeInfo extends StatelessWidget {
  const _DateTimeInfo({
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 更新を判定する閾値（秒）
    const updateThresholdSeconds = 10;
    final isUpdated =
        updatedAt.difference(createdAt).inSeconds > updateThresholdSeconds;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const Gap(4),
            Text(
              date.formattedDate,
              style: theme.textTheme.bodySmall,
            ),
            if (isUpdated) ...[
              const Gap(8),
              Text(
                '（更新: ${updatedAt.formatted}）',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
