import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      // Grey progression - darker for better contrast
      case BackgroundType.grey200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF9CA3AF), // grey-400
            Color(0xFF6B7280), // grey-500
          ],
        );
      case BackgroundType.grey100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF3F4F6), // grey-100
            Color(0xFFE5E7EB), // grey-200
          ],
        );
      case BackgroundType.grey50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF9FAFB), // grey-50
            Color(0xFFF3F4F6), // grey-100
          ],
        );
      case BackgroundType.grey20:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFCFCFD), // very light grey
            Color(0xFFF9FAFB), // grey-50
          ],
        );
      case BackgroundType.lightCream:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFEFEFE), // very light cream
            Color(0xFFFCFCFD), // very light grey
          ],
        );

      // Pink progression
      case BackgroundType.pink10:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFDF2F8), // pink-50
            Color(0xFFFFFFFF), // white
          ],
        );
      case BackgroundType.pink20:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFCE7F3), // pink-100
            Color(0xFFFDF2F8), // pink-50
          ],
        );
      case BackgroundType.pink30:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFBBF24), // pink-200
            Color(0xFFFCE7F3), // pink-100
          ],
        );
      case BackgroundType.pink50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF9A8D4), // pink-300
            Color(0xFFFBBF24), // pink-200
          ],
        );
      case BackgroundType.pink100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEC4899), // pink-500
            Color(0xFFF472B6), // pink-400
          ],
        );
      case BackgroundType.pink200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEC4899), // pink-500
            Color(0xFFF472B6), // pink-400
          ],
        );

      // Red progression
      case BackgroundType.red50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFEF2F2), // red-50
            Color(0xFFF472B6), // pink-400
          ],
        );
      case BackgroundType.red100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF87171), // red-400
            Color(0xFFEF4444), // red-500
          ],
        );
      case BackgroundType.red200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFECACA), // red-200
            Color(0xFFFEE2E2), // red-100
          ],
        );
      case BackgroundType.red300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEF4444), // red-500
            Color(0xFFFECACA), // red-200
          ],
        );

      // Orange progression
      case BackgroundType.orange50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFF7ED), // orange-50
            Color(0xFFFECACA), // red-200
          ],
        );
      case BackgroundType.orange100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFB923C), // orange-400
            Color(0xFFF97316), // orange-500
          ],
        );
      case BackgroundType.orange200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFED7AA), // orange-200
            Color(0xFFFFEDD5), // orange-100
          ],
        );
      case BackgroundType.orange300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF97316), // orange-500
            Color(0xFFFED7AA), // orange-200
          ],
        );

      // Yellow progression
      case BackgroundType.yellow50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFEFCE8), // yellow-50
            Color(0xFFFED7AA), // orange-200
          ],
        );
      case BackgroundType.yellow100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFBBF24), // yellow-400
            Color(0xFFEAB308), // yellow-500
          ],
        );
      case BackgroundType.yellow200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEAB308), // yellow-500
            Color(0xFFFEF3C7), // yellow-100
          ],
        );

      // Green progression
      case BackgroundType.green50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF0FDF4), // green-50
            Color(0xFFFEF3C7), // yellow-100
          ],
        );
      case BackgroundType.green100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF4ADE80), // green-400
            Color(0xFF22C55E), // green-500
          ],
        );
      case BackgroundType.green200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF22C55E), // green-500
            Color(0xFFDCFCE7), // green-100
          ],
        );
      case BackgroundType.green300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF16A34A), // green-600
            Color(0xFF22C55E), // green-500
          ],
        );

      // Teal progression
      case BackgroundType.teal100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFCCFBF1), // teal-100
            Color(0xFF16A34A), // green-600
          ],
        );
      case BackgroundType.teal200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF14B8A6), // teal-500
            Color(0xFFCCFBF1), // teal-100
          ],
        );
      case BackgroundType.teal300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0D9488), // teal-600
            Color(0xFF14B8A6), // teal-500
          ],
        );

      // Blue progression
      case BackgroundType.blue50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEFF6FF), // blue-50
            Color(0xFFDCFCE7), // green-100
          ],
        );
      case BackgroundType.blue100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF60A5FA), // blue-400
            Color(0xFF3B82F6), // blue-500
          ],
        );
      case BackgroundType.blue200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF3B82F6), // blue-500
            Color(0xFFDBEAFE), // blue-100
          ],
        );
      case BackgroundType.blue300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF2563EB), // blue-600
            Color(0xFF3B82F6), // blue-500
          ],
        );

      // Indigo progression
      case BackgroundType.indigo100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFE0E7FF), // indigo-100
            Color(0xFF2563EB), // blue-600
          ],
        );
      case BackgroundType.indigo200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF6366F1), // indigo-500
            Color(0xFFE0E7FF), // indigo-100
          ],
        );
      case BackgroundType.indigo300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF4F46E5), // indigo-600
            Color(0xFF6366F1), // indigo-500
          ],
        );

      // Purple progression
      case BackgroundType.purple50:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFAF5FF), // purple-50
            Color(0xFFDBEAFE), // blue-100
          ],
        );
      case BackgroundType.purple100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFF3E8FF), // purple-100
            Color(0xFFFAF5FF), // purple-50
          ],
        );
      case BackgroundType.purple200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFA855F7), // purple-500
            Color(0xFFF3E8FF), // purple-100
          ],
        );
      case BackgroundType.purple300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF9333EA), // purple-600
            Color(0xFFA855F7), // purple-500
          ],
        );

      // Violet progression
      case BackgroundType.violet100:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEDE9FE), // violet-100
            Color(0xFF9333EA), // purple-600
          ],
        );
      case BackgroundType.violet200:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF8B5CF6), // violet-500
            Color(0xFFEDE9FE), // violet-100
          ],
        );
      case BackgroundType.violet300:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF7C3AED), // violet-600
            Color(0xFF8B5CF6), // violet-500
          ],
        );

      // Deep Blues
      case BackgroundType.navyBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF1E3A8A), // blue-800
            Color(0xFF1E40AF), // blue-700
          ],
        );
      case BackgroundType.midnightBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0F172A), // slate-900
            Color(0xFF1E293B), // slate-800
          ],
        );
      case BackgroundType.deepOceanBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0C4A6E), // sky-800
            Color(0xFF0369A1), // sky-700
          ],
        );
      case BackgroundType.royalBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF1D4ED8), // blue-700
            Color(0xFF2563EB), // blue-600
          ],
        );

      // Dark Greens
      case BackgroundType.forestGreen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF14532D), // green-900
            Color(0xFF166534), // green-800
          ],
        );
      case BackgroundType.deepEmerald:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF064E3B), // emerald-900
            Color(0xFF065F46), // emerald-800
          ],
        );
      case BackgroundType.darkOlive:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF365314), // lime-900
            Color(0xFF3F6212), // lime-800
          ],
        );
      case BackgroundType.hunterGreen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF15803D), // green-700
            Color(0xFF16A34A), // green-600
          ],
        );

      // Brown Tones
      case BackgroundType.darkChocolate:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF451A03), // amber-900
            Color(0xFF92400E), // amber-800
          ],
        );
      case BackgroundType.espressoBrown:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF78350F), // amber-800
            Color(0xFFB45309), // amber-700
          ],
        );
      case BackgroundType.deepMahogany:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF7C2D12), // red-800
            Color(0xFFB91C1C), // red-700
          ],
        );
      case BackgroundType.burntSienna:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEA580C), // orange-600
            Color(0xFFDC2626), // red-600
          ],
        );

      // Deep Purples
      case BackgroundType.eggplantPurple:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF581C87), // purple-900
            Color(0xFF6B21A8), // purple-800
          ],
        );
      case BackgroundType.deepViolet:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF4C1D95), // violet-900
            Color(0xFF5B21B6), // violet-800
          ],
        );
      case BackgroundType.darkPlum:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF7C3AED), // violet-600
            Color(0xFF8B5CF6), // violet-500
          ],
        );
      case BackgroundType.royalPurple:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF6D28D9), // violet-700
            Color(0xFF7C3AED), // violet-600
          ],
        );

      // Deep Grays
      case BackgroundType.charcoalGray:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF374151), // gray-700
            Color(0xFF4B5563), // gray-600
          ],
        );
      case BackgroundType.slateGray:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF334155), // slate-700
            Color(0xFF475569), // slate-600
          ],
        );
      case BackgroundType.gunmetalGray:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF1F2937), // gray-800
            Color(0xFF374151), // gray-700
          ],
        );
      case BackgroundType.stormGray:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0F172A), // slate-900
            Color(0xFF1E293B), // slate-800
          ],
        );

      // Universe/Space Colors
      case BackgroundType.deepCosmicBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0C4A6E), // sky-800
            Color(0xFF1E3A8A), // blue-800
          ],
        );
      case BackgroundType.nebulaPurple:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF581C87), // purple-900
            Color(0xFF4C1D95), // violet-900
          ],
        );
      case BackgroundType.asteroidGray:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF1F2937), // gray-800
            Color(0xFF0F172A), // slate-900
          ],
        );
      case BackgroundType.darkMatterBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0F172A), // slate-900
            Color(0xFF1E3A8A), // blue-800
          ],
        );

      // Ocean Colors
      case BackgroundType.deepSeaBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0C4A6E), // sky-800
            Color(0xFF0369A1), // sky-700
          ],
        );
      case BackgroundType.abyssalBlueGreen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF134E4A), // teal-900
            Color(0xFF0C4A6E), // sky-800
          ],
        );
      case BackgroundType.darkTeal:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF134E4A), // teal-900
            Color(0xFF155E63), // teal-800
          ],
        );
      case BackgroundType.midnightOcean:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0F172A), // slate-900
            Color(0xFF134E4A), // teal-900
          ],
        );

      // Sky Colors
      case BackgroundType.twilightBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF1E40AF), // blue-700
            Color(0xFF3730A3), // indigo-700
          ],
        );
      case BackgroundType.stormCloudGray:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF374151), // gray-700
            Color(0xFF1F2937), // gray-800
          ],
        );
      case BackgroundType.deepSunsetOrange:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFEA580C), // orange-600
            Color(0xFFB45309), // amber-700
          ],
        );
      case BackgroundType.duskPurple:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF6D28D9), // violet-700
            Color(0xFF581C87), // purple-900
          ],
        );

      // Night Sky Colors
      case BackgroundType.midnightSky:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF0F172A), // slate-900
            Color(0xFF1E293B), // slate-800
          ],
        );
      case BackgroundType.deepIndigo:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF312E81), // indigo-900
            Color(0xFF3730A3), // indigo-800
          ],
        );
      case BackgroundType.starlessBlue:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF1E3A8A), // blue-800
            Color(0xFF312E81), // indigo-900
          ],
        );
      case BackgroundType.auroraGreen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF064E3B), // emerald-900
            Color(0xFF14532D), // green-900
          ],
        );

      // Legacy colors for backward compatibility
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
    }
  }
}
