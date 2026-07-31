// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'ai_feedback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiFeedback)
const aiFeedbackProvider = AiFeedbackFamily._();

final class AiFeedbackProvider
    extends $AsyncNotifierProvider<AiFeedback, DiaryEntry> {
  const AiFeedbackProvider._({
    required AiFeedbackFamily super.from,
    required DiaryEntry super.argument,
  }) : super(
         retry: null,
         name: r'aiFeedbackProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiFeedbackHash();

  @override
  String toString() {
    return r'aiFeedbackProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AiFeedback create() => AiFeedback();

  @override
  bool operator ==(Object other) {
    return other is AiFeedbackProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiFeedbackHash() => r'26e0c552629ef6cf9e6102d741cb49fce0ec7d0f';

final class AiFeedbackFamily extends $Family
    with
        $ClassFamilyOverride<
          AiFeedback,
          AsyncValue<DiaryEntry>,
          DiaryEntry,
          FutureOr<DiaryEntry>,
          DiaryEntry
        > {
  const AiFeedbackFamily._()
    : super(
        retry: null,
        name: r'aiFeedbackProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AiFeedbackProvider call(DiaryEntry diary) =>
      AiFeedbackProvider._(argument: diary, from: this);

  @override
  String toString() => r'aiFeedbackProvider';
}

abstract class _$AiFeedback extends $AsyncNotifier<DiaryEntry> {
  late final _$args = ref.$arg as DiaryEntry;
  DiaryEntry get diary => _$args;

  FutureOr<DiaryEntry> build(DiaryEntry diary);
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
