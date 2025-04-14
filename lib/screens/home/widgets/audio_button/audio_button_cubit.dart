import 'package:ambientflow/models/sound_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../services/audio/audio_service.dart';
import '../../../../services/audio/just_audio_service.dart';

part 'audio_button_state.dart';

class AudioButtonCubit extends Cubit<AudioButtonState> {
  final AudioService _audioService;
  late final SoundModel _sound;

  AudioButtonCubit({AudioService? audioService})
      : _audioService = audioService ?? JustAudioService(),
        super(const AudioButtonState());

  /// Initialize with a sound model
  Future<void> initialize(SoundModel sound) async {
    _sound = sound;
    await _audioService.initialize();
    loadAudio();
  }

  Future<bool> loadAudio() async {
    final bool loaded = await _audioService.loadSound(_sound);
    emit(state.copyWith(isLoaded: loaded));

    return loaded;
  }

  /// Toggle sound playback
  Future<void> toggleSound() async {
    if (!state.isLoaded) {
      final bool loaded = await loadAudio();
      if (!loaded) return;
    }

    if (state.isPlaying) {
      await _audioService.stopSound(_sound.id);
      emit(state.copyWith(isPlaying: false));
    } else {
      await _audioService.setVolume(_sound.id, state.volume / 100);
      final bool success = await _audioService.playSound(_sound.id);
      emit(state.copyWith(isPlaying: success));
    }
  }

  /// Change the volume
  Future<void> onChangeVolume(double volume) async {
    emit(state.copyWith(volume: volume));

    // Update the volume if the sound is playing
    if (state.isPlaying) {
      await _audioService.setVolume(_sound.id, volume / 100);
    }
  }

  @override
  Future<void> close() async {
    if (state.isPlaying) {
      await _audioService.stopSound(_sound.id);
    }
    await _audioService.dispose();
    return super.close();
  }
}
