import 'dart:io';

import 'package:ai_diary_hands_on/core/utils/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_auth_provider.g.dart';

final bool _supportPlatform = Platform.isIOS || Platform.isAndroid;

/// サポートされていないプラットフォームの場合に例外をスロー
void _ensureSupportedPlatform() {
  if (!_supportPlatform) {
    throw UnimplementedError(
      'Google Sign-In is only implemented for iOS and Android platforms.',
    );
  }
}

/// GoogleSignInExceptionを処理し、キャンセル時はnullを返す
/// キャンセル以外の例外は再スロー
T? _handleGoogleSignInException<T>(GoogleSignInException e) {
  if (e.code == .canceled) {
    logger.info('Google Sign-In was canceled by the user.');
    return null;
  }
  logger.severe('Google Sign-In failed: $e');
  throw e;
}

@Riverpod(keepAlive: true)
class GoogleUser extends _$GoogleUser {
  @override
  Future<GoogleSignInAccount?> build() async {
    _ensureSupportedPlatform();
    try {
      // 既存のサインイン状態を軽量にチェック
      return GoogleSignIn.instance.attemptLightweightAuthentication();
    } on GoogleSignInException catch (e) {
      return _handleGoogleSignInException(e);
    }
  }

  void setUser(GoogleSignInAccount? user) {
    state = AsyncData(user);
  }
}

@Riverpod(keepAlive: true)
Future<String?> googleUserAccessToken(Ref ref) async {
  final user = await ref.watch(googleUserProvider.future);
  final authorization = await user?.authorizationClient.authorizationForScopes(
    GoogleAuthNotifier.scopes,
  );
  return authorization?.accessToken;
}

@Riverpod(keepAlive: true)
class GoogleAuthNotifier extends _$GoogleAuthNotifier {
  // ref. https://developers.google.com/workspace/calendar/api/auth
  static const List<String> scopes = [
    CalendarApi.calendarEventsOwnedScope,
  ];

  @override
  FutureOr<String?> build() => null;

  Future<void> authenticationRequest() async {
    _ensureSupportedPlatform();
    try {
      await GoogleSignIn.instance.initialize();
      final googleUser = await GoogleSignIn.instance.authenticate(
        scopeHint: scopes,
      );

      if (googleUser.authentication.idToken == null) {
        throw Exception('Google Signin Failed because idToken is null');
      }
      ref.read(googleUserProvider.notifier).setUser(googleUser);
    } on GoogleSignInException catch (e) {
      _handleGoogleSignInException<void>(e);
    }
  }

  Future<void> authorizeRequest() async {
    final googleUser = ref.read(googleUserProvider).value;
    if (googleUser == null) {
      throw Exception('User is not signed in.');
    }
    try {
      await googleUser.authorizationClient.authorizeScopes(scopes);
      ref.invalidate(googleUserAccessTokenProvider);
    } on GoogleSignInException catch (e) {
      _handleGoogleSignInException<void>(e);
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    ref.read(googleUserProvider.notifier).setUser(null);
  }
}
