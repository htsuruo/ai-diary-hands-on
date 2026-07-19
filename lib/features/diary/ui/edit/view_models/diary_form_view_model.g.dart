// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_form_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiaryFormViewModel)
const diaryFormViewModelProvider = DiaryFormViewModelFamily._();

final class DiaryFormViewModelProvider
    extends $AsyncNotifierProvider<DiaryFormViewModel, DiaryEntry> {
  const DiaryFormViewModelProvider._({
    required DiaryFormViewModelFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'diaryFormViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryFormViewModelHash();

  @override
  String toString() {
    return r'diaryFormViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiaryFormViewModel create() => DiaryFormViewModel();

  @override
  bool operator ==(Object other) {
    return other is DiaryFormViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryFormViewModelHash() =>
    r'b91260e4c8ff4506af923cd8652177791d579aa9';

final class DiaryFormViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryFormViewModel,
          AsyncValue<DiaryEntry>,
          DiaryEntry,
          FutureOr<DiaryEntry>,
          String?
        > {
  const DiaryFormViewModelFamily._()
    : super(
        retry: null,
        name: r'diaryFormViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiaryFormViewModelProvider call(String? diaryId) =>
      DiaryFormViewModelProvider._(argument: diaryId, from: this);

  @override
  String toString() => r'diaryFormViewModelProvider';
}

abstract class _$DiaryFormViewModel extends $AsyncNotifier<DiaryEntry> {
  late final _$args = ref.$arg as String?;
  String? get diaryId => _$args;

  FutureOr<DiaryEntry> build(String? diaryId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<DiaryEntry>, DiaryEntry>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DiaryEntry>, DiaryEntry>,
              AsyncValue<DiaryEntry>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
