import 'package:pma/screens/hog_detail_screen.dart';
import 'package:pma/screens/home_screen.dart';

import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case RaiseScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RaiseScreen(),
      );
    case HogDetailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HogDetailScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
