import 'dart:async';
import 'dart:math' as math;
import 'package:bloc/bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  Timer? _timer;
  Timer? _backgroundTimer;
  Timer? _transitionTimer;
  final math.Random _random = math.Random();

  HomeCubit() : super(const HomeState()) {
    // Start the background change timer
    _startBackgroundTimer();
  }

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

  // Background management methods
  void _startBackgroundTimer() {
    _backgroundTimer?.cancel();
    _backgroundTimer = Timer.periodic(const Duration(seconds: 10), (Timer _) {
      _changeBackground();
    });
  }

  void _changeBackground() {
    // Store the current background as previous
    final BackgroundType previousBackground = state.backgroundType;

    // Select a new background that's different from the current one
    BackgroundType newBackground;
    do {
      newBackground =
          BackgroundType.values[_random.nextInt(BackgroundType.values.length)];
    } while (newBackground == previousBackground);

    // Start with 0 transition progress
    emit(state.copyWith(
      previousBackgroundType: previousBackground,
      backgroundType: newBackground,
      backgroundTransitionProgress: 0.0,
    ));

    // Start the transition animation
    _startTransitionAnimation();
  }

  void _startTransitionAnimation() {
    _transitionTimer?.cancel();

    // We'll update 60 times per second for 1 second duration
    const int totalSteps = 60;
    const Duration stepDuration = Duration(milliseconds: 1000 ~/ 60);
    int currentStep = 0;

    _transitionTimer = Timer.periodic(stepDuration, (Timer timer) {
      currentStep++;
      final double progress = currentStep / totalSteps;

      if (currentStep >= totalSteps) {
        timer.cancel();
        emit(state.copyWith(backgroundTransitionProgress: 1.0));
      } else {
        // Use a curve for smoother transition
        final double curvedProgress = _applyCurve(progress);
        emit(state.copyWith(backgroundTransitionProgress: curvedProgress));
      }
    });
  }

  // Apply an ease-in-out curve for smoother transition
  double _applyCurve(double progress) {
    // Using a simple ease-in-out curve
    return progress < 0.5
        ? 2 * progress * progress
        : -1 + (4 - 2 * progress) * progress;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _backgroundTimer?.cancel();
    _transitionTimer?.cancel();
    return super.close();
  }
}
