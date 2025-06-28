import 'dart:async';

import 'package:ambientflow/services/audio/audio_service.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:bloc/bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Timer? _timer;

  final AppState appState;
  final AudioService audioService;

  HomeCubit({
    required this.appState,
    required this.audioService,
  }) : super(const HomeState());

  // Note: Sound toggling is handled by AudioButtonCubit

  // Set the volume level
  void setVolume(double volume) {
    // This method is used for individual sound volume controls
    // Update UI state
    emit(state.copyWith(volume: volume));

    // If not muted, update all active sounds with this volume
    if (!state.isMuted) {
      _updateAllActiveSoundsVolume(volume);
    }
  }

  // Start or pause the timer
  void toggleTimer() {
    final bool isPlaying = !state.isPlaying;

    if (isPlaying) {
      _startTimer();
    } else {
      _pauseTimer();
    }

    emit(state.copyWith(isPlaying: isPlaying));
  }

  // Reset the timer
  void resetTimer() {
    _pauseTimer();
    emit(state.copyWith(
      timerRemaining: state.timerDuration,
      isPlaying: false,
    ));
  }

  // Set a new timer duration
  void setTimerDuration(int seconds) {
    _pauseTimer();
    emit(state.copyWith(
      timerDuration: seconds,
      timerRemaining: seconds,
      isPlaying: false,
    ));
  }

  // Clear all active sounds
  void clearSounds() {
    // Stop all active sounds
    if (appState.activeSoundIds != null) {
      for (final String soundId in appState.activeSoundIds!) {
        audioService.stopSound(soundId);
      }
      // Clear the active sounds in AppState
      appState.activeSoundIds?.clear();
    }
  }

  // This function was removed as it was unused and only a placeholder

  // Toggle the volume control sidebar for a specific sound
  void toggleVolumeControl(String soundId) {
    // If the same sound is clicked again, close the sidebar
    if (state.activeVolumeControlSoundId == soundId) {
      emit(state.copyWith(activeVolumeControlSoundId: null));
    } else {
      // Otherwise, show the sidebar for this sound
      emit(state.copyWith(activeVolumeControlSoundId: soundId));
    }
  }

  // Close the volume control sidebar
  void closeVolumeControl() {
    if (state.activeVolumeControlSoundId != null) {
      emit(state.copyWith(activeVolumeControlSoundId: null));
    }
  }

  // Private method to start the timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (state.timerRemaining <= 0) {
        _pauseTimer();
        emit(state.copyWith(isPlaying: false));
      } else {
        emit(state.copyWith(timerRemaining: state.timerRemaining - 1));
      }
    });
  }

  // Private method to pause the timer
  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // Format the remaining time as mm:ss
  String get formattedTime {
    final String minutes =
        (state.timerRemaining ~/ 60).toString().padLeft(2, '0');
    final String seconds =
        (state.timerRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void setAppVolume(double volume) {
    // Update app state
    appState.appVolume = volume;

    // Update all active sounds
    _updateAllActiveSoundsVolume(volume);

    // Update UI state
    emit(state.copyWith(volume: volume));
  }

  // Toggle mute/unmute
  void toggleMute() {
    final bool newMutedState = !state.isMuted;

    // Store the previous volume level if we're muting
    if (newMutedState) {
      _updateAllActiveSoundsVolume(0);

      emit(state.copyWith(isMuted: true));
    } else {
      // Unmute all active sounds
      _updateAllActiveSoundsVolume(appState.appVolume);

      // Update UI state
      emit(state.copyWith(isMuted: false));
    }
  }

  // Helper method to update volume for all active sounds
  void _updateAllActiveSoundsVolume(double volume) {
    // Convert volume from 0-100 scale to 0-1 scale for audio service
    final double normalizedVolume = volume / 100;

    // Apply volume to all active sounds from AppState
    if (appState.activeSoundIds != null) {
      for (final String soundId in appState.activeSoundIds!) {
        audioService.setVolume(soundId, normalizedVolume);
      }
    }
  }

  // Getter to check if the app is muted
  bool get isMuted => state.isMuted;
}
