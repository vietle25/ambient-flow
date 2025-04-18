import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/app_colors.dart';
import 'cubits/auth/auth_cubit.dart';
import 'firebase_options.dart';
import 'navigation/app_router.dart';
import 'services/di/service_locator.dart';
import 'utils/scroll_behavior.dart';
import 'widgets/cookie_consent_overlay.dart';

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
    return BlocProvider<AuthCubit>(
      create: (BuildContext context) =>
          ServiceLocator.instance.authCubit..checkAuthStatus(),
      child: MaterialApp.router(
        title: 'Ambient Flow',
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
        // Add the cookie consent overlay as a builder
        builder: (context, child) {
          return CookieConsentOverlay(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
