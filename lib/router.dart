import 'package:pma/screens/auth_screen.dart';
import 'package:pma/screens/change_password_screen.dart';
import 'package:pma/screens/confirm_security_code_screen.dart';
import 'package:pma/screens/forgot_password_screen.dart';
import 'package:pma/screens/hog_detail_screen.dart';
import 'package:pma/screens/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:pma/screens/signin_screen.dart';
import 'package:pma/screens/signup_screen.dart';
import 'package:pma/screens/update_password_screen.dart';
import 'package:pma/screens/dashboard_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case UpdatePasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UpdatePasswordScreen(),
      );
    case ConfirmSecurityCodeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ConfirmSecurityCodeScreen(),
      );
    case ForgotPasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ForgotPasswordScreen(),
      );
    case ChangePasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ChangePasswordScreen(),
      );
    case SigninScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SigninScreen(),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupScreen(),
      );
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
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
    case DashboardScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const DashboardScreen(),
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
