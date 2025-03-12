import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_router_notifier.dart';
import 'package:isis3510_team32_flutter/views/login_view.dart';
import '../views/home_view.dart';

CustomTransitionPage buildPageWithNoTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        child,
  );
}

GoRouter setupRouter(AuthBloc authBloc) {
  final authNotifier = AuthRouterNotifier(authBloc);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isAuthenticated = authBloc.state.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
          path: '/login',
          pageBuilder: (context, state) => buildPageWithNoTransition(
              context: context, state: state, child: const LoginView())),
      GoRoute(
          path: '/home',
          pageBuilder: (context, state) => buildPageWithNoTransition(
              context: context, state: state, child: const HomeView())),
    ],
  );
}
