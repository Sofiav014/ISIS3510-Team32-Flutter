import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
            context: context, state: state, child: const HomeView())),
    // GoRoute(
    //     path: '/search',
    //     pageBuilder: (context, state) => buildPageWithNoTransition(
    //         context: context, state: state, child: const SearchView())),
    // GoRoute(
    //     path: '/calendar',
    //     pageBuilder: (context, state) => buildPageWithNoTransition(
    //         context: context, state: state, child: const CalendarView())),
    // GoRoute(
    //     path: '/add',
    //     pageBuilder: (context, state) => buildPageWithNoTransition(
    //         context: context, state: state, child: const AddView())),
    // GoRoute(
    //     path: '/profile',
    //     pageBuilder: (context, state) => buildPageWithNoTransition(
    //         context: context, state: state, child: const ProfileView())),
  ],
);
