part of 'background_cubit.dart';

enum BackgroundType {
  grey200,
  grey100,
  grey50,
  grey20,
  lightCream,
  pink10,
  pink20,
  pink30,
  pink50,
  pink100,
  pink200,
  red50,
  red100,
  red200,
  red300,
  orange50,
  orange100,
  orange200,
  orange300,
  yellow50,
  yellow100,
  yellow200,
  green50,
  green100,
  green200,
  green300,
  teal100,
  teal200,
  teal300,
  blue50,
  blue100,
  blue200,
  blue300,
  indigo100,
  indigo200,
  indigo300,
  purple50,
  purple100,
  purple200,
  purple300,
  violet100,
  violet200,
  violet300,
  // Deep Blues
  navyBlue,
  midnightBlue,
  deepOceanBlue,
  royalBlue,
  // Dark Greens
  forestGreen,
  deepEmerald,
  darkOlive,
  hunterGreen,
  // Brown Tones
  darkChocolate,
  espressoBrown,
  deepMahogany,
  burntSienna,
  // Deep Purples
  eggplantPurple,
  deepViolet,
  darkPlum,
  royalPurple,
  // Deep Grays
  charcoalGray,
  slateGray,
  gunmetalGray,
  stormGray,
  // Universe/Space Colors
  deepCosmicBlue,
  nebulaPurple,
  asteroidGray,
  darkMatterBlue,
  // Ocean Colors
  deepSeaBlue,
  abyssalBlueGreen,
  darkTeal,
  midnightOcean,
  // Sky Colors
  twilightBlue,
  stormCloudGray,
  deepSunsetOrange,
  duskPurple,
  // Night Sky Colors
  midnightSky,
  deepIndigo,
  starlessBlue,
  auroraGreen,
  lightGreen,
  darkGreen,
  lightBlue,
  darkBlue,
  purple,
  orange
}

class BackgroundState extends Equatable {
  final BackgroundType backgroundType;
  final double backgroundTransitionProgress; // 0.0 to 1.0
  final BackgroundType previousBackgroundType;

  const BackgroundState({
    this.backgroundType = BackgroundType.lightBlue,
    this.backgroundTransitionProgress = 1.0,
    this.previousBackgroundType = BackgroundType.lightBlue,
  });

  BackgroundState copyWith({
    BackgroundType? backgroundType,
    double? backgroundTransitionProgress,
    BackgroundType? previousBackgroundType,
  }) {
    return BackgroundState(
      backgroundType: backgroundType ?? this.backgroundType,
      backgroundTransitionProgress:
          backgroundTransitionProgress ?? this.backgroundTransitionProgress,
      previousBackgroundType:
          previousBackgroundType ?? this.previousBackgroundType,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        backgroundType,
        backgroundTransitionProgress,
        previousBackgroundType,
      ];
}
