import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ai_diary_hands_on/core/core.dart';
import 'package:ai_diary_hands_on/features/ai_feedback/ai_feedback_button.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuruo_kit/tsuruo_kit.dart';

import 'diary_detail_view_model.dart';

class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key, required this.diaryId});

  final String diaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = diaryDetailViewModelProvider(diaryId);

    final diary = ref.watch(provider).value;

    // 日記削除処理
    Future<void> deleteDiary() async {
      final res = await showOkCancelAlertDialog(
        context: context,
        title: '確認',
        message: 'この日記を削除しますか?',
        okLabel: '削除する',
        isDestructiveAction: true,
      );

      if (res == .ok) {
        await ref.read(provider.notifier).delete();
        context.pop();
        ref
            .read(scaffoldMessengerKeyProvider)
            .currentState
            ?.showMessage('日記を削除しました');
      }
    }

    return diary == null
        ? const SizedBox.shrink()
        : Row(
            children: [
              // フィードバック生成ボタン（追記）
              AiFeedbackButton(diary: diary),

              // 編集ボタン
              ActionIconButton(
                iconData: Icons.edit,
                color: colorScheme.primary,
                action: () =>
                    DiaryEditPageRoute(id: diary.id).push<void>(context),
              ),

              // 削除ボタン
              ActionIconButton(
                iconData: Icons.delete,
                color: colorScheme.error,
                action: deleteDiary,
              ),
            ],
          );
  }
}
