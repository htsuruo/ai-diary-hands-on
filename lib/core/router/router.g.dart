// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$diariesPageRoute];

RouteBase get $diariesPageRoute => GoRouteData.$route(
  path: '/',
  factory: $DiariesPageRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'diaries/new',
      factory: $DiaryCreatePageRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'diaries/:id/chat',
      factory: $ChatPageRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'diaries/:id',
      factory: $DiaryDetailPageRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'edit',
          factory: $DiaryEditPageRoute._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: 'settings',
      parentNavigatorKey: SettingsPageRoute.$parentNavigatorKey,
      factory: $SettingsPageRoute._fromState,
    ),
  ],
);

mixin $DiariesPageRoute on GoRouteData {
  static DiariesPageRoute _fromState(GoRouterState state) =>
      const DiariesPageRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DiaryCreatePageRoute on GoRouteData {
  static DiaryCreatePageRoute _fromState(GoRouterState state) =>
      const DiaryCreatePageRoute();

  @override
  String get location => GoRouteData.$location('/diaries/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChatPageRoute on GoRouteData {
  static ChatPageRoute _fromState(GoRouterState state) =>
      ChatPageRoute(id: state.pathParameters['id']!);

  ChatPageRoute get _self => this as ChatPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/diaries/${Uri.encodeComponent(_self.id)}/chat');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DiaryDetailPageRoute on GoRouteData {
  static DiaryDetailPageRoute _fromState(GoRouterState state) =>
      DiaryDetailPageRoute(id: state.pathParameters['id']!);

  DiaryDetailPageRoute get _self => this as DiaryDetailPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/diaries/${Uri.encodeComponent(_self.id)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DiaryEditPageRoute on GoRouteData {
  static DiaryEditPageRoute _fromState(GoRouterState state) =>
      DiaryEditPageRoute(id: state.pathParameters['id']!);

  DiaryEditPageRoute get _self => this as DiaryEditPageRoute;

  @override
  String get location =>
      GoRouteData.$location('/diaries/${Uri.encodeComponent(_self.id)}/edit');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsPageRoute on GoRouteData {
  static SettingsPageRoute _fromState(GoRouterState state) =>
      SettingsPageRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(router)
const routerProvider = RouterProvider._();

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  const RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'4671321d4f16b8df45da1ed0f5f4b01cabc9f9f0';
