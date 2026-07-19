// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_detail_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiaryDetailViewModel)
const diaryDetailViewModelProvider = DiaryDetailViewModelFamily._();

final class DiaryDetailViewModelProvider
    extends $AsyncNotifierProvider<DiaryDetailViewModel, DiaryEntry?> {
  const DiaryDetailViewModelProvider._({
    required DiaryDetailViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'diaryDetailViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryDetailViewModelHash();

  @override
  String toString() {
    return r'diaryDetailViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiaryDetailViewModel create() => DiaryDetailViewModel();

  @override
  bool operator ==(Object other) {
    return other is DiaryDetailViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryDetailViewModelHash() =>
    r'16adc25c05815c364100d8732cac418b46d10528';

final class DiaryDetailViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryDetailViewModel,
          AsyncValue<DiaryEntry?>,
          DiaryEntry?,
          FutureOr<DiaryEntry?>,
          String
        > {
  const DiaryDetailViewModelFamily._()
    : super(
        retry: null,
        name: r'diaryDetailViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiaryDetailViewModelProvider call(String diaryId) =>
      DiaryDetailViewModelProvider._(argument: diaryId, from: this);

  @override
  String toString() => r'diaryDetailViewModelProvider';
}

abstract class _$DiaryDetailViewModel extends $AsyncNotifier<DiaryEntry?> {
  late final _$args = ref.$arg as String;
  String get diaryId => _$args;

  FutureOr<DiaryEntry?> build(String diaryId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<DiaryEntry?>, DiaryEntry?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DiaryEntry?>, DiaryEntry?>,
              AsyncValue<DiaryEntry?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
