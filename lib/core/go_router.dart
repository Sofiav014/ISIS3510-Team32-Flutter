import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/views/login_view.dart';
import 'package:isis3510_team32_flutter/views/home_view.dart';

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

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithNoTransition(
            context: context, state: state, child: const LoginView())),
    GoRoute(
        path: '/home',
        pageBuilder: (context, state) => buildPageWithNoTransition(
            context: context,
            state: state,
            child: const HomeView(
              userId:
                  'DM1xP0TG8jMlIlxGyTRPojB7CM23', // TODO: Replace with actual user ID
            ))),
  ],
);
