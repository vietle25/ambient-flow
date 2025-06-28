import 'package:ambientflow/services/audio/audio_service.dart';
import 'package:ambientflow/services/di/service_locator.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/animated_background/animated_background_widget.dart';
import '../../widgets/animated_background/cubit/background_cubit.dart';
import '../../widgets/custom_app_bar.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';
import 'widgets/main_content_section.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCubit homeCubit = HomeCubit(
    appState: getIt<AppState>(),
    audioService: getIt<AudioService>(),
  );
  final BackgroundCubit backgroundCubit = BackgroundCubit();

  @override
  void dispose() {
    homeCubit.close();
    backgroundCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => homeCubit,
        ),
        BlocProvider<BackgroundCubit>(
          create: (BuildContext context) => backgroundCubit,
        ),
      ],
      child: BlocListener<HomeCubit, HomeState>(
        listener: (BuildContext context, HomeState state) {},
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Determine if we're on a mobile, tablet, or desktop
            final bool isDesktop = constraints.maxWidth > 1100;
            final bool isTablet = constraints.maxWidth > 650 && constraints.maxWidth <= 1100;
            final bool isMobile = constraints.maxWidth <= 650;

            return Scaffold(
              // Use a transparent background since we'll use our custom animated background
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: const CustomAppBar(),
              // Stack the background and content
              body: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: <Widget>[
                  // Animated background
                  const AnimatedBackgroundWidget(),
                  // Content
                  MainContentSection(
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
