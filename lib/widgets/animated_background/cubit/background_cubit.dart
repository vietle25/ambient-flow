import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'background_state.dart';

class BackgroundCubit extends Cubit<BackgroundState> {
  Timer? _backgroundTimer;
  Timer? _transitionTimer;

  // Define the color sequence
  final List<BackgroundType> _colorSequence = <BackgroundType>[
    BackgroundType.lightGreen,
    BackgroundType.darkGreen,
    BackgroundType.lightBlue,
    BackgroundType.darkBlue,
    BackgroundType.purple,
    BackgroundType.orange,
  ];
  int _currentColorIndex = 0;

  BackgroundCubit() : super(const BackgroundState()) {
    // Start the background change timer
    _startBackgroundTimer();
  }

  // Background management methods
  void _startBackgroundTimer() {
    _backgroundTimer?.cancel();
    _backgroundTimer = Timer.periodic(const Duration(seconds: 10), (Timer _) {
      _changeBackground();
    });
  }

  void _changeBackground() {
    final BackgroundType previousBackground = state.backgroundType;

    // Get next color in sequence
    _currentColorIndex = (_currentColorIndex + 1) % _colorSequence.length;
    final BackgroundType newBackground = _colorSequence[_currentColorIndex];

    emit(state.copyWith(
      previousBackgroundType: previousBackground,
      backgroundType: newBackground,
      backgroundTransitionProgress: 0.0,
    ));

    _startTransitionAnimation();
  }

  void _startTransitionAnimation() {
    _transitionTimer?.cancel();

    // Increase steps for smoother transition
    const int totalSteps = 120; // 2 seconds duration at 60fps
    const Duration stepDuration = Duration(milliseconds: 1000 ~/ 60);
    int currentStep = 0;

    _transitionTimer = Timer.periodic(stepDuration, (Timer timer) {
      currentStep++;
      final double progress = currentStep / totalSteps;

      if (currentStep >= totalSteps) {
        timer.cancel();
        emit(state.copyWith(backgroundTransitionProgress: 1.0));
      } else {
        final double curvedProgress = _applyCurve(progress);
        emit(state.copyWith(backgroundTransitionProgress: curvedProgress));
      }
    });
  }

  // Use a smoother easing curve
  double _applyCurve(double progress) {
    // Cubic ease-in-out curve
    return progress < 0.5
        ? 4 * progress * progress * progress
        : 1 - math.pow(-2 * progress + 2, 3) / 2;
  }

  // Manually change to a specific background type
  void changeToBackground(BackgroundType type) {
    if (state.backgroundType == type) return;

    final BackgroundType previousBackground = state.backgroundType;

    emit(state.copyWith(
      previousBackgroundType: previousBackground,
      backgroundType: type,
      backgroundTransitionProgress: 0.0,
    ));

    _startTransitionAnimation();
  }

  // Pause or resume background transitions
  void toggleBackgroundTransitions(bool enabled) {
    if (enabled) {
      _startBackgroundTimer();
    } else {
      _backgroundTimer?.cancel();
      _backgroundTimer = null;
    }
  }

  @override
  Future<void> close() {
    _backgroundTimer?.cancel();
    _transitionTimer?.cancel();
    return super.close();
  }
}
