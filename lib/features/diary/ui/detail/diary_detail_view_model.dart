import 'package:ai_diary_hands_on/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../diary.dart';

part 'diary_detail_view_model.g.dart';

@riverpod
class DiaryDetailViewModel extends _$DiaryDetailViewModel {
  @override
  FutureOr<DiaryEntry?> build(String diaryId) =>
      ref.watch(diaryProvider(diaryId).future);

  Future<void> delete() async {
    try {
      final id = state.value?.id;
      if (id == null) {
        logger.warning('No diary to delete');
        return;
      }
      await ref.read(diaryRepositoryProvider.notifier).delete(id);
    } catch (e) {
      logger.severe('Failed to delete diary: $e');
      rethrow;
    }
  }
}
