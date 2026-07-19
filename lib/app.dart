import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuruo_kit/tsuruo_kit.dart';

import 'core/router/router.dart';
import 'core/theme/theme.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerProvider);
    final scaffoldMessengerKey = ref.watch(scaffoldMessengerKeyProvider);

    return MaterialApp.router(
      title: 'AI Diary',
      theme: AppTheme.light,
      // スクリーンショット撮影の都合上falseにしていますが、通常の開発ではtrue推奨
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
      scaffoldMessengerKey: scaffoldMessengerKey,
      builder: (context, child) => ProgressRootOverlay(child: child!),
      supportedLocales: const [
        Locale('ja'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
