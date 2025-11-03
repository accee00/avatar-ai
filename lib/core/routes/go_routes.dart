import 'package:avatar_ai/core/routes/app_routes.dart';
import 'package:avatar_ai/features/auth/view/auth_screen.dart';
import 'package:avatar_ai/features/auth/view/forgot_password.dart';
import 'package:avatar_ai/features/auth/view/splash_screen.dart';
import 'package:avatar_ai/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRoutes {
  ///
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  ///
  static BuildContext? get context => navigatorKey.currentContext;

  ///
  static GoRouter get router => _router;

  static final _router = GoRouter(
    initialLocation: AppRoutes.initialRoute,
    routes: <RouteBase>[
      GoRoute(
        name: AppRoutes.initialRoute,
        path: AppRoutes.initialRoute,
        builder: (BuildContext context, GoRouterState state) => SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.auth,
        path: AppRoutes.auth,
        builder: (context, state) => AuthScreen(),
      ),
      GoRoute(
        name: AppRoutes.forgotPass,
        path: AppRoutes.forgotPass,
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        name: AppRoutes.mainScreen,
        path: AppRoutes.mainScreen,
        builder: (context, state) => HomeScreen(),
      ),
    ],
  );
}
