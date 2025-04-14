part of 'audio_button_cubit.dart';

class AudioButtonState extends Equatable {
  final double volume;

  const AudioButtonState({
    this.volume = 50,
  });

  AudioButtonState copyWith({
    double? volume,
  }) {
    return AudioButtonState(
      volume: volume ?? this.volume,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        volume,
      ];
}
