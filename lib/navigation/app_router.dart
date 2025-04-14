import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../screens/home/home_page.dart';
import '../screens/settings/settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        // Define routes
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          initial: true,
        ),
        // Settings route
        AutoRoute(
          path: '/settings',
          page: SettingsRoute.page,
        ),
        // Add more routes as needed
      ];
}
