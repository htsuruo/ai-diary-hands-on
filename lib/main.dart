import 'package:ai_diary_hands_on/app.dart';
import 'package:ai_diary_hands_on/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'features/calendar_integration/google_auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
    providerApple: const AppleDebugProvider(),
  );

  Intl.defaultLocale = 'ja';
  runApp(
    ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          // すでに認証済みの場合はアプリ起動時に呼んでおく
          ref.read(googleUserProvider);
          return const MainApp();
        },
      ),
    ),
  );
}
