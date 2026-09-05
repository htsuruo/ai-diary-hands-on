// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'google_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoogleUser)
const googleUserProvider = GoogleUserProvider._();

final class GoogleUserProvider
    extends $AsyncNotifierProvider<GoogleUser, GoogleSignInAccount?> {
  const GoogleUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleUserHash();

  @$internal
  @override
  GoogleUser create() => GoogleUser();
}

String _$googleUserHash() => r'b0fb159c28b64b8308d0c3cf5868d416f3b00872';

abstract class _$GoogleUser extends $AsyncNotifier<GoogleSignInAccount?> {
  FutureOr<GoogleSignInAccount?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<GoogleSignInAccount?>, GoogleSignInAccount?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<GoogleSignInAccount?>,
                GoogleSignInAccount?
              >,
              AsyncValue<GoogleSignInAccount?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(googleUserAccessToken)
const googleUserAccessTokenProvider = GoogleUserAccessTokenProvider._();

final class GoogleUserAccessTokenProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  const GoogleUserAccessTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleUserAccessTokenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleUserAccessTokenHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return googleUserAccessToken(ref);
  }
}

String _$googleUserAccessTokenHash() =>
    r'8fec243bb0180c605b2d1fe35ad466ed4e6d11f1';

@ProviderFor(GoogleAuthNotifier)
const googleAuthProvider = GoogleAuthNotifierProvider._();

final class GoogleAuthNotifierProvider
    extends $AsyncNotifierProvider<GoogleAuthNotifier, String?> {
  const GoogleAuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleAuthNotifierHash();

  @$internal
  @override
  GoogleAuthNotifier create() => GoogleAuthNotifier();
}

String _$googleAuthNotifierHash() =>
    r'd577b73a13e9c1434f09dd762f88c3b2d268e014';

abstract class _$GoogleAuthNotifier extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
