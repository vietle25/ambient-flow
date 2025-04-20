import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/services/audio/audio_service.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_button_state.dart';

class AudioButtonCubit extends Cubit<AudioButtonState> {
  final AudioService audioService;
  final AppState appState;
  late final SoundModel _sound;

  AudioButtonCubit({
    required this.audioService,
    required this.appState,
  }) : super(const AudioButtonState());

  /// Initialize with a sound model
  Future<void> initialize(SoundModel sound) async {
    _sound = sound;
    await audioService.initialize();
    await loadAudio();

    // Check if this sound is active in the global app state
    final bool isActive = appState.isSoundActive(sound.id);

    emit(state.copyWith(
      isActive: isActive,
    ));
  }

  Future<bool> loadAudio() async {
    final bool loaded = await audioService.loadSound(_sound);
    emit(state.copyWith(isLoaded: loaded));

    return loaded;
  }

  /// Toggle sound active state and playback
  Future<void> toggleSound() async {
    // Toggle active state
    final bool newActiveState = !state.isActive;

    if (newActiveState) {
      appState.addActiveSound(_sound.id);
      await _playSound();
    } else {
      appState.removeActiveSound(_sound.id);
      await _stopSound();
    }

    emit(state.copyWith(isActive: newActiveState));
  }

  Future<void> _playSound() async {
    if (!state.isLoaded) {
      final bool loaded = await loadAudio();
      if (!loaded) return;
    }

    await audioService.setVolume(_sound.id, state.volume / 100);
    await audioService.playSound(_sound.id);
  }

  /// Stop the sound
  Future<void> _stopSound() async {
    await audioService.stopSound(_sound.id);
  }

  /// Change the volume
  Future<void> onChangeVolume(double volume) async {
    await audioService.setVolume(_sound.id, volume / 100);
    emit(state.copyWith(volume: volume));
  }

  @override
  Future<void> close() async {
    if (state.isActive) {
      await audioService.stopSound(_sound.id);
    }
    await audioService.dispose();
    return super.close();
  }
}
