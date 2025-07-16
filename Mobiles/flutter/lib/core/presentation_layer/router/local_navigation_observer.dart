// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/widgets.dart';

class LocalNavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  /// Extracts a meaningful description from a route
  String _getRouteDescription(Route<dynamic>? route) {
    if (route == null) return 'null';

    // Start with the route name if available
    var description = route.settings.name ?? '';
    final isUnnamed = description.isEmpty;

    // If no name, or we want additional info, add route type
    if (isUnnamed) {
      description = route.runtimeType.toString();

      // For PageRoute, try to extract the widget type
      if (route is PageRoute) {
        try {
          // Try to get more specific info from the route
          final routeStr = route.toString();
          if (routeStr.contains('Page')) {
            // Extract page info if available in string representation
            description = routeStr.split('(').first;
          }
        } catch (e) {
          // Fallback to just the runtime type
        }
      }

      // Add unnamed indicator when we fell back to type info
      description += ' (unnamed)';
    }

    return description.isEmpty ? 'unknown' : description;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    print(
        '🔙 Navigation: ${_getRouteDescription(route)} -> ${_getRouteDescription(previousRoute)}');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    print(
        '➡️ Navigation: ${_getRouteDescription(previousRoute)} -> ${_getRouteDescription(route)}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    print(
        '🔄 Navigation: ${_getRouteDescription(oldRoute)} -> ${_getRouteDescription(newRoute)}');
  }
}
