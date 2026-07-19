// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'diary_feedback_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiaryFeedbackService)
const diaryFeedbackServiceProvider = DiaryFeedbackServiceFamily._();

final class DiaryFeedbackServiceProvider
    extends $NotifierProvider<DiaryFeedbackService, DiaryFeedbackOutput?> {
  const DiaryFeedbackServiceProvider._({
    required DiaryFeedbackServiceFamily super.from,
    required DiaryEntry super.argument,
  }) : super(
         retry: null,
         name: r'diaryFeedbackServiceProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$diaryFeedbackServiceHash();

  @override
  String toString() {
    return r'diaryFeedbackServiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DiaryFeedbackService create() => DiaryFeedbackService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiaryFeedbackOutput? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiaryFeedbackOutput?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DiaryFeedbackServiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$diaryFeedbackServiceHash() =>
    r'879468dec6bd33fec0e91f0a1ff9f90cb7ef259d';

final class DiaryFeedbackServiceFamily extends $Family
    with
        $ClassFamilyOverride<
          DiaryFeedbackService,
          DiaryFeedbackOutput?,
          DiaryFeedbackOutput?,
          DiaryFeedbackOutput?,
          DiaryEntry
        > {
  const DiaryFeedbackServiceFamily._()
    : super(
        retry: null,
        name: r'diaryFeedbackServiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  DiaryFeedbackServiceProvider call(DiaryEntry diary) =>
      DiaryFeedbackServiceProvider._(argument: diary, from: this);

  @override
  String toString() => r'diaryFeedbackServiceProvider';
}

abstract class _$DiaryFeedbackService extends $Notifier<DiaryFeedbackOutput?> {
  late final _$args = ref.$arg as DiaryEntry;
  DiaryEntry get diary => _$args;

  DiaryFeedbackOutput? build(DiaryEntry diary);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<DiaryFeedbackOutput?, DiaryFeedbackOutput?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiaryFeedbackOutput?, DiaryFeedbackOutput?>,
              DiaryFeedbackOutput?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
