import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/services/audio/audio_service.dart';
import 'package:ambientflow/services/di/service_locator.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../cubits/bookmark/bookmark_cubit.dart';

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
    loadAudio();

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
    emit(state.copyWith(isActive: newActiveState));

    if (newActiveState) {
      appState.addActiveSound(_sound.id);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      _playSound();
    } else {
      appState.removeActiveSound(_sound.id);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      _stopSound();
    }

    // Notify bookmark cubit that app state has changed
    try {
      getIt<BookmarkCubit>().notifyAppStateChanged();
    } catch (e) {
      // Ignore errors if bookmark cubit is not available
    }
  }

  Future<void> _playSound() async {
    if (!state.isLoaded) {
      final bool loaded = await loadAudio();
      if (!loaded) return;
    }

    audioService.playSound(_sound.id);
    // Apply the global app volume when starting the sound
    audioService.setVolume(_sound.id, appState.appVolume / 100);
  }

  /// Stop the sound
  Future<void> _stopSound() async {
    audioService.stopSound(_sound.id);
  }

  /// Change the volume
  Future<void> onChangeVolume(double volume) async {
    emit(state.copyWith(volume: volume));
    audioService.setVolume(_sound.id, volume / 100);
  }

  @override
  Future<void> close() async {
    if (state.isActive) {
      await audioService.stopSound(_sound.id);
    }
    await audioService.dispose();
    return super.close();
  }

  void onHoverChange(bool val) {
    emit(state.copyWith(isHover: val));
  }

  /// Syncs the button state with the global app state.
  /// This should be called when bookmarks are applied or when the global state changes.
  void syncWithAppState() {
    final bool isActive = appState.isSoundActive(_sound.id);
    if (state.isActive != isActive) {
      emit(state.copyWith(isActive: isActive));
    }
  }
}
