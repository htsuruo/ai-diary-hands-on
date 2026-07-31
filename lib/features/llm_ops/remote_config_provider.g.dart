// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'remote_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(remoteConfig)
const remoteConfigProvider = RemoteConfigProvider._();

final class RemoteConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<FirebaseRemoteConfig>,
          FirebaseRemoteConfig,
          FutureOr<FirebaseRemoteConfig>
        >
    with
        $FutureModifier<FirebaseRemoteConfig>,
        $FutureProvider<FirebaseRemoteConfig> {
  const RemoteConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigHash();

  @$internal
  @override
  $FutureProviderElement<FirebaseRemoteConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FirebaseRemoteConfig> create(Ref ref) {
    return remoteConfig(ref);
  }
}

String _$remoteConfigHash() => r'9888de1ab1f4e81aa61f514627618a14d05d40f0';

@ProviderFor(aiFeedbackTemplateId)
const aiFeedbackTemplateIdProvider = AiFeedbackTemplateIdProvider._();

final class AiFeedbackTemplateIdProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const AiFeedbackTemplateIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiFeedbackTemplateIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiFeedbackTemplateIdHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return aiFeedbackTemplateId(ref);
  }
}

String _$aiFeedbackTemplateIdHash() =>
    r'7fbdd2ca2998663d58798de54d589dbc88dc4f58';
