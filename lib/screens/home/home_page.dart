import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/animated_background.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/header_section.dart';
import '../../widgets/main_content_section.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Create a cubit instance directly in the screen
  final HomeCubit cubit = HomeCubit();

  @override
  void dispose() {
    // Don't forget to close the cubit when the screen is disposed
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => cubit,
      child: BlocListener<HomeCubit, HomeState>(
        listener: (BuildContext context, HomeState state) {
          // Handle state changes that require one-time actions
          // For example, showing snackbars, dialogs, or navigation
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Determine if we're on a mobile, tablet, or desktop
            final bool isDesktop = constraints.maxWidth > 1100;
            final bool isTablet =
                constraints.maxWidth > 650 && constraints.maxWidth <= 1100;
            final bool isMobile = constraints.maxWidth <= 650;

            return Scaffold(
              // Use a transparent background since we'll use our custom animated background
              backgroundColor: Colors.transparent,
              appBar: const CustomAppBar(),
              // Stack the background and content
              body: BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (HomeState previous, HomeState current) =>
                    previous.backgroundType != current.backgroundType ||
                    previous.backgroundTransitionProgress !=
                        current.backgroundTransitionProgress ||
                    previous.previousBackgroundType !=
                        current.previousBackgroundType,
                builder: (BuildContext context, HomeState state) {
                  return Stack(
                    children: <Widget>[
                      // Animated background
                      AnimatedBackground(
                        currentBackground: state.backgroundType,
                        previousBackground: state.previousBackgroundType,
                        transitionProgress: state.backgroundTransitionProgress,
                      ),
                      // Content
                      Column(
                        children: <Widget>[
                          HeaderSection(
                            isMobile: isMobile,
                            isTablet: isTablet,
                            isDesktop: isDesktop,
                          ),
                          MainContentSection(
                            isMobile: isMobile,
                            isTablet: isTablet,
                            isDesktop: isDesktop,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
