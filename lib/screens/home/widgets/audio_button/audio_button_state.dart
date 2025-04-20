part of 'audio_button_cubit.dart';

class AudioButtonState extends Equatable {
  final double volume;
  final bool isLoaded;
  final bool isActive;
  const AudioButtonState({
    this.volume = 50,
    this.isLoaded = false,
    this.isActive = false,
  });

  AudioButtonState copyWith({
    double? volume,
    bool? isLoaded,
    bool? isActive,
  }) {
    return AudioButtonState(
      volume: volume ?? this.volume,
      isLoaded: isLoaded ?? this.isLoaded,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        volume,
        isLoaded,
        isActive,
      ];
}
