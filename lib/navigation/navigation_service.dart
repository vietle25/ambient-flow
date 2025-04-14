import 'package:auto_route/auto_route.dart';

import 'app_router.dart';

/// A service that provides navigation methods for the app
class NavigationService {
  final AppRouter router;

  NavigationService(this.router);

  Future<dynamic> push(PageRouteInfo route) async {
    return router.push(route);
  }

  Future<dynamic> pushReplace(PageRouteInfo route) async {
    return router.replace(route);
  }

  void pop() {
    router.back();
  }

  void popUntilRoute(String routeName) {
    router.popUntilRouteWithName(routeName);
  }

  bool canNavigateBack() {
    return router.canPop();
  }
}
