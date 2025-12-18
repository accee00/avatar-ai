import 'package:avatar_ai/core/routes/app_routes.dart';
import 'package:avatar_ai/features/auth/view/auth_screen.dart';
import 'package:avatar_ai/features/auth/view/forgot_password.dart';
import 'package:avatar_ai/features/auth/view/splash_screen.dart';
import 'package:avatar_ai/features/home/view/main_screen.dart';
import 'package:avatar_ai/features/myavatar/view/create_character_form.dart';
import 'package:avatar_ai/features/myavatar/model/character_model.dart';
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
        builder: (context, state) => MainScreen(),
      ),
      GoRoute(
        name: AppRoutes.createAvatar,
        path: AppRoutes.createAvatar,
        builder: (BuildContext context, GoRouterState state) =>
            CreateCharacterForm(),
      ),
      GoRoute(
        name: AppRoutes.editAvatar,
        path: AppRoutes.editAvatar,
        builder: (BuildContext context, GoRouterState state) {
          final character = state.extra as Character;
          return CreateCharacterForm(character: character);
        },
      ),
    ],
  );
}
