import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final List<String> activeSounds;
  final double volume;
  final bool isPlaying;
  final int timerDuration; // in seconds
  final int timerRemaining; // in seconds
  final String? activeVolumeControlSoundId; // Track which sound's volume control is active
  final bool isMuted; // Track if the volume is muted

  const HomeState({
    this.activeSounds = const <String>[],
    this.volume = 50,
    this.isPlaying = false,
    this.timerDuration = 1500, // 25 minutes by default
    this.timerRemaining = 1500,
    this.activeVolumeControlSoundId,
    this.isMuted = false,
  });

  HomeState copyWith({
    List<String>? activeSounds,
    double? volume,
    bool? isPlaying,
    int? timerDuration,
    int? timerRemaining,
    String? activeVolumeControlSoundId,
    bool? isMuted,
  }) {
    return HomeState(
      activeSounds: activeSounds ?? this.activeSounds,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      timerDuration: timerDuration ?? this.timerDuration,
      timerRemaining: timerRemaining ?? this.timerRemaining,
      activeVolumeControlSoundId: activeVolumeControlSoundId ?? this.activeVolumeControlSoundId,
      isMuted: isMuted ?? this.isMuted,
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
        isMuted,
      ];
}
