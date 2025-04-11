import 'package:equatable/equatable.dart';

// Define background types
enum BackgroundType { day, night, sunset, rain, snow }

class HomeState extends Equatable {
  final List<String> activeSounds;
  final double volume;
  final bool isPlaying;
  final int timerDuration; // in seconds
  final int timerRemaining; // in seconds
  final BackgroundType backgroundType;
  final double backgroundTransitionProgress; // 0.0 to 1.0
  final BackgroundType previousBackgroundType;

  const HomeState({
    this.activeSounds = const <String>[],
    this.volume = 0.5,
    this.isPlaying = false,
    this.timerDuration = 1500, // 25 minutes by default
    this.timerRemaining = 1500,
    this.backgroundType = BackgroundType.day,
    this.backgroundTransitionProgress = 1.0,
    this.previousBackgroundType = BackgroundType.day,
  });

  HomeState copyWith({
    List<String>? activeSounds,
    double? volume,
    bool? isPlaying,
    int? timerDuration,
    int? timerRemaining,
    BackgroundType? backgroundType,
    double? backgroundTransitionProgress,
    BackgroundType? previousBackgroundType,
  }) {
    return HomeState(
      activeSounds: activeSounds ?? this.activeSounds,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      timerDuration: timerDuration ?? this.timerDuration,
      timerRemaining: timerRemaining ?? this.timerRemaining,
      backgroundType: backgroundType ?? this.backgroundType,
      backgroundTransitionProgress:
          backgroundTransitionProgress ?? this.backgroundTransitionProgress,
      previousBackgroundType:
          previousBackgroundType ?? this.previousBackgroundType,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        activeSounds,
        volume,
        isPlaying,
        timerDuration,
        timerRemaining,
        backgroundType,
        backgroundTransitionProgress,
        previousBackgroundType,
      ];
}
