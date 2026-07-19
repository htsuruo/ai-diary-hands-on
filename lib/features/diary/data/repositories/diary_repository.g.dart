// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiaryRepository)
const diaryRepositoryProvider = DiaryRepositoryProvider._();

final class DiaryRepositoryProvider
    extends $StreamNotifierProvider<DiaryRepository, List<DiaryEntry>> {
  const DiaryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryRepositoryHash();

  @$internal
  @override
  DiaryRepository create() => DiaryRepository();
}

String _$diaryRepositoryHash() => r'd9266be18c13cdd7da8419937f935a6e48d6bfa6';

abstract class _$DiaryRepository extends $StreamNotifier<List<DiaryEntry>> {
  Stream<List<DiaryEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<DiaryEntry>>, List<DiaryEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DiaryEntry>>, List<DiaryEntry>>,
              AsyncValue<List<DiaryEntry>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(diary)
const diaryProvider = DiaryFamily._();

final class DiaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DiaryEntry?>,
          DiaryEntry?,
          FutureOr<DiaryEntry?>
        >
    with $FutureModifier<DiaryEntry?>, $FutureProvider<DiaryEntry?> {
  const DiaryProvider._({
    required DiaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'diaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryHash();

  @override
  String toString() {
    return r'diaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<DiaryEntry?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DiaryEntry?> create(Ref ref) {
    final argument = this.argument as String;
    return diary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DiaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryHash() => r'3afdb952af227a78351a75756f2f0fa96833f9fd';

final class DiaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<DiaryEntry?>, String> {
  const DiaryFamily._()
    : super(
        retry: null,
        name: r'diaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DiaryProvider call(String diaryId) =>
      DiaryProvider._(argument: diaryId, from: this);

  @override
  String toString() => r'diaryProvider';
}
