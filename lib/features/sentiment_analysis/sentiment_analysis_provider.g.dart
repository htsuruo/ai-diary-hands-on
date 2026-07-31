// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'sentiment_analysis_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SentimentAnalysis)
const sentimentAnalysisProvider = SentimentAnalysisFamily._();

final class SentimentAnalysisProvider
    extends $AsyncNotifierProvider<SentimentAnalysis, SentimentState?> {
  const SentimentAnalysisProvider._({
    required SentimentAnalysisFamily super.from,
    required DiaryEntry super.argument,
  }) : super(
         retry: null,
         name: r'sentimentAnalysisProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sentimentAnalysisHash();

  @override
  String toString() {
    return r'sentimentAnalysisProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SentimentAnalysis create() => SentimentAnalysis();

  @override
  bool operator ==(Object other) {
    return other is SentimentAnalysisProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sentimentAnalysisHash() => r'10232283ac821e1f7694862317494a80739f6d56';

final class SentimentAnalysisFamily extends $Family
    with
        $ClassFamilyOverride<
          SentimentAnalysis,
          AsyncValue<SentimentState?>,
          SentimentState?,
          FutureOr<SentimentState?>,
          DiaryEntry
        > {
  const SentimentAnalysisFamily._()
    : super(
        retry: null,
        name: r'sentimentAnalysisProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SentimentAnalysisProvider call({required DiaryEntry diary}) =>
      SentimentAnalysisProvider._(argument: diary, from: this);

  @override
  String toString() => r'sentimentAnalysisProvider';
}

abstract class _$SentimentAnalysis extends $AsyncNotifier<SentimentState?> {
  late final _$args = ref.$arg as DiaryEntry;
  DiaryEntry get diary => _$args;

  FutureOr<SentimentState?> build({required DiaryEntry diary});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(diary: _$args);
    final ref = this.ref as $Ref<AsyncValue<SentimentState?>, SentimentState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SentimentState?>, SentimentState?>,
              AsyncValue<SentimentState?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
