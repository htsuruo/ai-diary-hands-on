import 'package:ai_diary_hands_on/core/core.dart';
import 'package:ai_diary_hands_on/features/diary/diary.dart';
import 'package:json_converter_helper/json_converter_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../detail/diary_detail_view_model.dart';

part 'diary_form_view_model.g.dart';

@riverpod
class DiaryFormViewModel extends _$DiaryFormViewModel {
  @override
  FutureOr<DiaryEntry> build(String? diaryId) async {
    if (diaryId == null) {
      logger.warning('Diary not found for editing: $diaryId');
      return DiaryEntry.empty();
    }
    if (diaryId.isEmpty) {
      logger.info('Diary ID is for creating');
      return DiaryEntry.empty();
    }
    final diary = await ref.watch(diaryDetailViewModelProvider(diaryId).future);

    if (diary == null) {
      logger.severe('Diary not found for editing: $diaryId');
      throw Exception('Diary not found');
    }
    return diary;
  }

  /// 日記を保存（新規作成または更新）
  Future<void> save(DiaryEntry diary) async {
    if (diary.id.isEmpty) {
      await ref.read(diaryRepositoryProvider.notifier).create(diary);
    } else {
      await ref
          .read(diaryRepositoryProvider.notifier)
          .updateEntry(
            diary.copyWith(
              updatedAt: const UnionTimestamp.serverTimestamp(),
            ),
          );
      // 詳細画面が参照する日記を再取得
      ref.invalidate(diaryProvider(diary.id));
    }
  }
}
