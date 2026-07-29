// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'firebase_ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseAI)
const firebaseAIProvider = FirebaseAIProvider._();

final class FirebaseAIProvider
    extends $FunctionalProvider<FirebaseAI, FirebaseAI, FirebaseAI>
    with $Provider<FirebaseAI> {
  const FirebaseAIProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAIProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAIHash();

  @$internal
  @override
  $ProviderElement<FirebaseAI> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAI create(Ref ref) {
    return firebaseAI(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAI value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAI>(value),
    );
  }
}

String _$firebaseAIHash() => r'3eaba7498a81302367a192b3c0255ed904747e83';
