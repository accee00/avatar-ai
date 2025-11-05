// ignore_for_file: deprecated_member_use

import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/core/routes/go_routes.dart';
import 'package:avatar_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogger(level: kDebugMode ? Level.ALL : Level.SEVERE);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: GoRoutes.navigatorKey,
      routerConfig: GoRoutes.router,
      title: 'Avatar ai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFF6C63FF),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF00D9FF),
          surface: const Color(0xFF1A1A1A),
        ),
      ),
    );
  }
}
