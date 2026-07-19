import 'package:ai_diary_hands_on/core/core.dart';
import 'package:ai_diary_hands_on/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../diary.dart';
import 'widgets/diary_card.dart';
import 'widgets/setting_button.dart';

class DiaryListPage extends ConsumerWidget {
  const DiaryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diariesAsync = ref.watch(diaryRepositoryProvider);

    return Scaffold(
      appBar: const _AppBar(),
      body: switch (diariesAsync) {
        AsyncData(:final value) =>
          value.isEmpty
              ? const _EmptyWidget()
              : ListView.builder(
                  padding: const .all(16),
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final diary = value[index];
                    return DiaryCard(
                      diary: diary,
                      onTap: () {
                        DiaryDetailPageRoute(id: diary.id).push<void>(context);
                      },
                    );
                  },
                ),
        AsyncError(:final error) => _ErrorWidget(error: error),
        _ => const CenteredCircularIndicator(),
      },
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          const DiaryCreatePageRoute().push<void>(context);
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 20,
      title: Image.asset(
        'assets/images/logo/symbol.png',
        height: 30,
      ),
      actions: const [SettingButton()],
      actionsPadding: const .symmetric(horizontal: 8),
    );
  }

  @override
  Size get preferredSize => const .fromHeight(kToolbarHeight);
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        icon: Icons.article_outlined,
        title: 'まだ日記がありません',
        message: '最初の日記を書いてみましょう',
        action: EmptyAction(
          label: '日記を書く',
          iconData: Icons.add,
          onPressed: () => const DiaryCreatePageRoute().push<void>(context),
        ),
      ),
    );
  }
}

class _ErrorWidget extends ConsumerWidget {
  const _ErrorWidget({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: EmptyWidget.error(
        title: 'エラーが発生しました',
        message: 'code: $error',
        action: EmptyAction(
          label: '再試行',
          iconData: Icons.refresh,
          onPressed: () {
            ref.invalidate(diaryRepositoryProvider);
            logger.info('Retry loading diaries');
          },
        ),
      ),
    );
  }
}
