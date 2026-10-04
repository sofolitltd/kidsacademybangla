import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/features/details/details_screen.dart';
import '/features/details/focus_details_screen.dart';
import '/features/about/about_screen.dart';
import '/features/home/home_screen.dart';
import '/features/rewards/reward_page.dart';
import '/features/profile/profile_form_screen.dart';
import '/features/profile/profile_learn_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'about',
          builder: (BuildContext context, GoRouterState state) {
            return const AboutScreen();
          },
        ),
        GoRoute(
          path: 'stickers',
          builder: (BuildContext context, GoRouterState state) {
            return const TreasurePage();
          },
        ),
        GoRoute(
          path: 'profile/form',
          builder: (BuildContext context, GoRouterState state) {
            final profileId = state.uri.queryParameters['profileId'];
            return ProfileFormScreen(profileId: profileId);
          },
        ),
        GoRoute(
          path: 'profile/learn/:profileId',
          builder: (BuildContext context, GoRouterState state) {
            final profileId = state.pathParameters['profileId']!;
            return ProfileLearnScreen(profileId: profileId);
          },
        ),
        GoRoute(
          path: 'details/:itemId',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>?;
            final String? title = extra?['title'] as String?;
            final Color? color = extra?['color'] as Color?;

            return DetailsScreen(
              itemId: state.pathParameters['itemId'],
              title: title,
              color: color ?? Colors.blueGrey,
            );
          },
          routes: [
            GoRoute(
              path: 'focus/:initialIndex',
              builder: (BuildContext context, GoRouterState state) {
                final itemId = state.pathParameters['itemId']!;
                final initialIndex = int.parse(
                  state.pathParameters['initialIndex']!,
                );
                final extra = state.extra as Map<String, dynamic>?;
                final String? title = extra?['title'] as String?;
                final Color? color = extra?['color'] as Color?;

                return FocusDetailsScreen(
                  itemId: itemId,
                  initialIndex: initialIndex,
                  title: title,
                  color: color ?? Colors.blueGrey,
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
