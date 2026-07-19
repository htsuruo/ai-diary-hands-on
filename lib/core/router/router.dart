import 'package:ai_diary_hands_on/features/chat/chat_page.dart';
import 'package:ai_diary_hands_on/features/diary/ui/detail/detail_page.dart';
import 'package:ai_diary_hands_on/features/diary/ui/edit/edit_page.dart';
import 'package:ai_diary_hands_on/features/diary/ui/list/list_page.dart';
import 'package:ai_diary_hands_on/features/settings/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

extension GoRouterX on GoRouter {
  NavigatorState get navigator => routerDelegate.navigatorKey.currentState!;
}

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: kDebugMode,
    initialLocation: const DiariesPageRoute().location,
    navigatorKey: _rootNavigatorKey,
  );
}

@TypedGoRoute<DiariesPageRoute>(
  path: '/',
  routes: [
    // ルーティングは上から行われるためパスパターンが似ている場合は変更するか順序の制御に注意
    TypedGoRoute<DiaryCreatePageRoute>(
      path: 'diaries/new',
    ),
    TypedGoRoute<ChatPageRoute>(
      path: 'diaries/:id/chat',
    ),
    TypedGoRoute<DiaryDetailPageRoute>(
      path: 'diaries/:id',
      routes: [
        TypedGoRoute<DiaryEditPageRoute>(
          path: 'edit',
        ),
      ],
    ),
    TypedGoRoute<SettingsPageRoute>(
      path: 'settings',
    ),
  ],
)
class DiariesPageRoute extends GoRouteData with $DiariesPageRoute {
  const DiariesPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DiaryListPage();
  }
}

class DiaryDetailPageRoute extends GoRouteData with $DiaryDetailPageRoute {
  const DiaryDetailPageRoute({required this.id});

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DiaryDetailPage(diaryId: id);
  }
}

class DiaryEditPageRoute extends GoRouteData with $DiaryEditPageRoute {
  const DiaryEditPageRoute({required this.id});
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DiaryEditPage(diaryId: id);
}

class ChatPageRoute extends GoRouteData with $ChatPageRoute {
  const ChatPageRoute({required this.id});
  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChatPage(diaryId: id);
}

class DiaryCreatePageRoute extends GoRouteData with $DiaryCreatePageRoute {
  const DiaryCreatePageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const MaterialPage(
        fullscreenDialog: true,
        child: DiaryEditPage(),
      );
}

class SettingsPageRoute extends GoRouteData with $SettingsPageRoute {
  // ref. https://github.com/flutter/packages/tree/main/packages/go_router_builder#typedshellroute-and-navigator-keys
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const MaterialPage(
        fullscreenDialog: true,
        child: SettingsPage(),
      );
}
