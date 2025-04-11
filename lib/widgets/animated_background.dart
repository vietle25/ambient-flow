import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../screens/home/cubit/home_state.dart';

class AnimatedBackground extends StatelessWidget {
  final BackgroundType currentBackground;
  final BackgroundType previousBackground;
  final double transitionProgress;

  const AnimatedBackground({
    super.key,
    required this.currentBackground,
    required this.previousBackground,
    required this.transitionProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Previous background
        Opacity(
          opacity: 1.0 - transitionProgress,
          child: Container(
            decoration: BoxDecoration(
              gradient: _getGradientForBackground(previousBackground),
            ),
          ),
        ),
        // Current background
        Opacity(
          opacity: transitionProgress,
          child: Container(
            decoration: BoxDecoration(
              gradient: _getGradientForBackground(currentBackground),
            ),
          ),
        ),
      ],
    );
  }

  LinearGradient _getGradientForBackground(BackgroundType type) {
    switch (type) {
      case BackgroundType.day:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF4A90E2), // Sky blue
            Color(0xFF87CEFA), // Light sky blue
          ],
        );
      case BackgroundType.night:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0D1B2A), // Dark blue
            Color(0xFF1B263B), // Navy blue
          ],
        );
      case BackgroundType.sunset:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFF7E5F), // Sunset orange
            Color(0xFFFFB55F), // Light orange
            Color(0xFF4A90E2), // Sky blue
          ],
        );
      case BackgroundType.rain:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF616161), // Dark gray
            Color(0xFF9E9E9E), // Light gray
          ],
        );
      case BackgroundType.snow:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFE0E0E0), // Light gray
            Color(0xFFF5F5F5), // Almost white
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.primaryBackground,
            AppColors.primaryBackground.withOpacity(0.7),
          ],
        );
    }
  }
}
