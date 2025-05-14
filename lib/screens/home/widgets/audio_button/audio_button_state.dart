part of 'audio_button_cubit.dart';

class AudioButtonState extends Equatable {
  final double volume;
  final bool isLoaded;
  final bool isActive;
  final bool isHover;

  const AudioButtonState({
    this.volume = 50,
    this.isLoaded = false,
    this.isActive = false,
    this.isHover = false,
  });

  AudioButtonState copyWith({
    double? volume,
    bool? isLoaded,
    bool? isActive,
    bool? isHover,
  }) {
    return AudioButtonState(
      volume: volume ?? this.volume,
      isLoaded: isLoaded ?? this.isLoaded,
      isActive: isActive ?? this.isActive,
      isHover: isHover ?? this.isHover,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        volume,
        isLoaded,
        isActive,
        isHover,
      ];
}
