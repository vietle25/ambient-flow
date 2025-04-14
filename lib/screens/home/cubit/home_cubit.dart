import 'dart:async';

import 'package:bloc/bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Timer? _timer;

  HomeCubit() : super(const HomeState());

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

  // Save the current sound combination (placeholder for future implementation)
  void saveSoundCombination(String name) {
    // This would typically save to a database or local storage
    // For now, we'll just log the combination
    // In a real app, use a proper logging framework
    // ignore: avoid_print
    print('Saved sound combination "$name": ${state.activeSounds}');
  }

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
    final String minutes = (state.timerRemaining ~/ 60).toString().padLeft(2, '0');
    final String seconds = (state.timerRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void onTapItem({required String soundId, required bool isActive}) {
    toggleSound(soundId);

    if (!isActive) {
      toggleVolumeControl(soundId);
    }
  }
}
