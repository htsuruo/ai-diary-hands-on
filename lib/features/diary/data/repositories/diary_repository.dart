import 'package:ai_diary_hands_on/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/diary_entry.dart' show DiaryEntry;

part 'diary_repository.g.dart';

@Riverpod(keepAlive: true)
class DiaryRepository extends _$DiaryRepository {
  CollectionReference<DiaryEntry> get _collectionRef => FirebaseFirestore
      .instance
      .collection('users')
      .doc('user1')
      .collection('diaries')
      .withConverter<DiaryEntry>(
        fromFirestore: (snapshot, _) {
          final diary = DiaryEntry.fromJson({
            'id': snapshot.id,
            ...snapshot.data()!,
          });
          return diary.copyWith(id: snapshot.id);
        },
        toFirestore: (diary, _) => diary.toJson(),
      );

  @override
  Stream<List<DiaryEntry>> build() {
    return _collectionRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => doc.data(),
              )
              .toList(),
        );
  }

  Future<void> create(DiaryEntry entry) => _collectionRef.add(entry);

  // (update命名は重複するため末尾にEntryを追記
  Future<void> updateEntry(DiaryEntry entry) =>
      _collectionRef.doc(entry.id).update(entry.toJson());

  Future<void> delete(String id) => _collectionRef.doc(id).delete();

  Future<DiaryEntry?> fetchById(String id) async {
    final doc = await _collectionRef.doc(id).get();
    if (!doc.exists) {
      logger.warning('Document not found: $id');
    }
    return doc.data();
  }
}

@riverpod
Future<DiaryEntry?> diary(Ref ref, String diaryId) async {
  final diary = await ref
      .watch(diaryRepositoryProvider.notifier)
      .fetchById(diaryId);
  return diary;
}
