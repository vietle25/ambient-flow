part of 'audio_button_cubit.dart';

class AudioButtonState extends Equatable {
  final double volume;
  final bool isPlaying;
  final bool isLoaded;

  const AudioButtonState({
    this.volume = 50,
    this.isPlaying = false,
    this.isLoaded = false,
  });

  AudioButtonState copyWith({
    double? volume,
    bool? isPlaying,
    bool? isLoaded,
  }) {
    return AudioButtonState(
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        volume,
        isPlaying,
        isLoaded,
      ];
}
