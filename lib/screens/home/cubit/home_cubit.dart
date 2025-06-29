import 'dart:async';

import 'package:ambientflow/state/app_state.dart';
import 'package:bloc/bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Timer? _timer;

  final AppState appState;

  HomeCubit({
    required this.appState,
  }) : super(const HomeState());

  // Toggle a sound on/off
  void toggleSound(String soundId) {
    final List<String> currentSounds = List<String>.from(state.activeSounds);

    if (currentSounds.contains(soundId)) {
      currentSounds.remove(soundId);
    } else {
      currentSounds.add(soundId);
    }

    emit(state.copyWith(activeSounds: currentSounds));
  }

  // Set the volume level
  void setVolume(double volume) {
    emit(state.copyWith(volume: volume));
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
    emit(state.copyWith(activeSounds: <String>[]));
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
    appState.appVolume = volume;
    emit(state.copyWith(volume: volume));
  }

  // Toggle mute/unmute
  void toggleMute() {
    final bool newMutedState = !state.isMuted;

    // Store the previous volume level if we're muting
    if (newMutedState) {
      // Only store if volume is not already 0
      if (state.volume > 0) {
        appState.previousVolume = state.volume;
      }
      appState.appVolume = 0;
      emit(state.copyWith(isMuted: true, volume: 0));
    } else {
      // Restore previous volume or set to default if none stored
      final double restoredVolume =
          appState.previousVolume > 0 ? appState.previousVolume : 50;
      appState.appVolume = restoredVolume;
      emit(state.copyWith(isMuted: false, volume: restoredVolume));
    }
  }

  /// Syncs the home cubit state with the global app state.
  /// This should be called when bookmarks are applied.
  void syncWithAppState() {
    final double currentAppVolume = appState.appVolume;
    if (state.volume != currentAppVolume) {
      emit(state.copyWith(volume: currentAppVolume));
    }
  }
}
