import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/features/details/details_screen.dart';
import '/features/home/home_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details/:itemId',
          builder: (BuildContext context, GoRouterState state) {
            final extra = state.extra as Map<String, dynamic>?;
            final String? title = extra?['title'] as String?;
            final Color? color = extra?['color'] as Color?;

            return DetailsScreen(
              itemId: state.pathParameters['itemId'],
              title: title,
              // Pass the color to the DetailsScreen, with a default
              // color: color ?? Colors.blueGrey,
            );
          },
        ),
      ],
    ),
  ],
);
