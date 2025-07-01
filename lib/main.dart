import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'firebase_options.dart';
import 'navigation/app_router.dart';
import 'services/di/service_locator.dart';
import 'utils/scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize service locator
  await ServiceLocator.instance.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ambient Flow - Perfect Ambient Soundscapes',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: AppColors.primaryBackground),
        useMaterial3: true,
      ),
      scrollBehavior: AppScrollBehavior(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
    );
  }
}
