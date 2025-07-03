import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'background_state.dart';

class BackgroundCubit extends Cubit<BackgroundState> {
  Timer? _backgroundTimer;
  Timer? _transitionTimer;

  // Define the comprehensive color sequence from medium tones to deep dramatic colors
  final List<BackgroundType> _colorSequence = <BackgroundType>[
    // Medium tones
    BackgroundType.grey200,
    BackgroundType.pink100,
    BackgroundType.pink200,
    BackgroundType.red100,
    BackgroundType.red200,
    BackgroundType.red300,
    BackgroundType.orange100,
    BackgroundType.orange200,
    BackgroundType.orange300,
    BackgroundType.yellow100,
    BackgroundType.yellow200,

    // Transition to browns
    BackgroundType.burntSienna,
    BackgroundType.darkChocolate,
    BackgroundType.espressoBrown,
    BackgroundType.deepMahogany,

    // Green progression to dark
    BackgroundType.green100,
    BackgroundType.green200,
    BackgroundType.green300,
    BackgroundType.forestGreen,
    BackgroundType.hunterGreen,
    BackgroundType.deepEmerald,
    BackgroundType.darkOlive,
    BackgroundType.auroraGreen,

    // Teal to ocean colors
    BackgroundType.teal100,
    BackgroundType.teal200,
    BackgroundType.teal300,
    BackgroundType.darkTeal,
    BackgroundType.deepSeaBlue,
    BackgroundType.abyssalBlueGreen,
    BackgroundType.midnightOcean,

    // Blue progression to deep blues
    BackgroundType.blue100,
    BackgroundType.blue200,
    BackgroundType.blue300,
    BackgroundType.royalBlue,
    BackgroundType.deepOceanBlue,
    BackgroundType.navyBlue,
    BackgroundType.midnightBlue,
    BackgroundType.twilightBlue,
    BackgroundType.deepCosmicBlue,
    BackgroundType.darkMatterBlue,
    BackgroundType.midnightSky,
    BackgroundType.starlessBlue,

    // Indigo to deep indigo
    BackgroundType.indigo100,
    BackgroundType.indigo200,
    BackgroundType.indigo300,
    BackgroundType.deepIndigo,

    // Purple progression to deep purples
    BackgroundType.purple100,
    BackgroundType.purple200,
    BackgroundType.purple300,
    BackgroundType.violet100,
    BackgroundType.violet200,
    BackgroundType.violet300,
    BackgroundType.deepViolet,
    BackgroundType.eggplantPurple,
    BackgroundType.darkPlum,
    BackgroundType.royalPurple,
    BackgroundType.nebulaPurple,
    BackgroundType.duskPurple,

    // Deep grays and storm colors
    BackgroundType.charcoalGray,
    BackgroundType.slateGray,
    BackgroundType.gunmetalGray,
    BackgroundType.stormGray,
    BackgroundType.stormCloudGray,
    BackgroundType.asteroidGray,

    // Deep sunset transition back
    BackgroundType.deepSunsetOrange,
  ];
  int _currentColorIndex = 0;

  BackgroundCubit() : super(const BackgroundState()) {
    // Start the background change timer
    _startBackgroundTimer();
  }

  // Background management methods
  void _startBackgroundTimer() {
    _backgroundTimer?.cancel();
    // Transition time: 15s, Stay time: 7.5s (0.5 * transition time), Total: 22.5s
    _backgroundTimer =
        Timer.periodic(const Duration(milliseconds: 22500), (Timer _) {
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

    // Much slower, more gradual transition - 15 seconds duration
    const int totalSteps = 900; // 15 seconds duration at 60fps
    const Duration stepDuration = Duration(milliseconds: 1000 ~/ 60);
    int currentStep = 0;

    _transitionTimer = Timer.periodic(stepDuration, (Timer timer) {
      currentStep++;
      final double progress = currentStep / totalSteps;

      if (currentStep >= totalSteps) {
        timer.cancel();
        emit(state.copyWith(backgroundTransitionProgress: 1.0));
      } else {
        final double curvedProgress = _applySmoothCurve(progress);
        emit(state.copyWith(backgroundTransitionProgress: curvedProgress));
      }
    });
  }

  // Use an extremely smooth easing curve for gradual color transitions
  double _applySmoothCurve(double progress) {
    // Quintic ease-in-out curve for ultra-smooth transitions
    return progress < 0.5
        ? 16 * progress * progress * progress * progress * progress
        : 1 - math.pow(-2 * progress + 2, 5) / 2;
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
