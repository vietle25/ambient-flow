import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final List<String> activeSounds;
  final double volume;
  final bool isPlaying;
  final int timerDuration; // in seconds
  final int timerRemaining; // in seconds
  final String?
      activeVolumeControlSoundId; // Track which sound's volume control is active

  const HomeState({
    this.activeSounds = const <String>[],
    this.volume = 0.5,
    this.isPlaying = false,
    this.timerDuration = 1500, // 25 minutes by default
    this.timerRemaining = 1500,
    this.activeVolumeControlSoundId,
  });

  HomeState copyWith({
    List<String>? activeSounds,
    double? volume,
    bool? isPlaying,
    int? timerDuration,
    int? timerRemaining,
    String? activeVolumeControlSoundId,
  }) {
    return HomeState(
      activeSounds: activeSounds ?? this.activeSounds,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      timerDuration: timerDuration ?? this.timerDuration,
      timerRemaining: timerRemaining ?? this.timerRemaining,
      activeVolumeControlSoundId:
          activeVolumeControlSoundId ?? this.activeVolumeControlSoundId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        activeSounds,
        volume,
        isPlaying,
        timerDuration,
        timerRemaining,
        activeVolumeControlSoundId,
      ];
}
