part of 'background_cubit.dart';

enum BackgroundType {
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
