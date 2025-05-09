import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_bloc.dart';
import 'package:isis3510_team32_flutter/view_models/auth/auth_router_notifier.dart';
import 'package:isis3510_team32_flutter/views/initiation_view.dart';
import 'package:isis3510_team32_flutter/views/login_view.dart';
import 'package:isis3510_team32_flutter/views/search_view.dart';
import 'package:isis3510_team32_flutter/views/venue_list_view.dart';
import 'package:isis3510_team32_flutter/views/home_view.dart';
import 'package:isis3510_team32_flutter/views/profile_view.dart';

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
      final hasModel = authBloc.state.hasModel;
      final isLoginRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/initiation';

      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        if (hasModel) {
          return '/home';
        } else {
          return '/initiation';
        }
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
      GoRoute(
          path: '/search',
          pageBuilder: (context, state) => buildPageWithNoTransition(
              context: context, state: state, child: const SearchView())),
      GoRoute(
        path: '/venue_list/:sportId',
        pageBuilder: (context, state) {
          final sportId = state.pathParameters['sportId']!;
          return buildPageWithNoTransition(
            context: context,
            state: state,
            child: VenueListView(sportName: sportId),
          );
        },
      ),
      GoRoute(
          path: '/initiation',
          pageBuilder: (context, state) => buildPageWithNoTransition(
              context: context, state: state, child: const InitiationView())),
      GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => buildPageWithNoTransition(
              context: context, state: state, child: const ProfileView())),
    ],
  );
}
