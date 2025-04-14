import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import 'cubit/background_cubit.dart';

class AnimatedBackgroundWidget extends StatelessWidget {
  const AnimatedBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackgroundCubit, BackgroundState>(
      buildWhen: (BackgroundState previous, BackgroundState current) =>
          previous.backgroundType != current.backgroundType ||
          previous.backgroundTransitionProgress !=
              current.backgroundTransitionProgress ||
          previous.previousBackgroundType != current.previousBackgroundType,
      builder: (BuildContext context, BackgroundState state) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Previous background
            Opacity(
              opacity: 1.0 - state.backgroundTransitionProgress,
              child: Container(
                decoration: BoxDecoration(
                  gradient:
                      _getGradientForBackground(state.previousBackgroundType),
                ),
              ),
            ),
            // Current background
            Opacity(
              opacity: state.backgroundTransitionProgress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: _getGradientForBackground(state.backgroundType),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  LinearGradient _getGradientForBackground(BackgroundType type) {
    switch (type) {
      case BackgroundType.lightGreen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF2E8B57), // Darker green
            Color(0xFF228B22), // Forest green
          ],
        );
      case BackgroundType.darkGreen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF006400), // Dark green
            Color(0xFF004D00), // Darker forest green
          ],
        );
      case BackgroundType.lightBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF4682B4), // Steel blue
            Color(0xFF1E6091), // Darker steel blue
          ],
        );
      case BackgroundType.darkBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF00008B), // Dark blue
            Color(0xFF000066), // Deeper blue
          ],
        );
      case BackgroundType.purple:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF4B0082), // Indigo
            Color(0xFF3A006F), // Darker indigo
          ],
        );
      case BackgroundType.orange:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFD2691E), // Chocolate
            Color(0xFFA0522D), // Sienna
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.primaryBackground.withOpacity(0.9),
            AppColors.primaryBackground.withOpacity(0.6),
          ],
        );
    }
  }
}
