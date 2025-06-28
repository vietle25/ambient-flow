import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/screens/home/cubit/home_cubit.dart';
import 'package:ambientflow/services/audio/audio_service.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_button_state.dart';

class AudioButtonCubit extends Cubit<AudioButtonState> {
  final AudioService audioService;
  final AppState appState;
  final HomeCubit? homeCubit; // Optional reference to HomeCubit for mute state
  late final SoundModel _sound;

  AudioButtonCubit({
    required this.audioService,
    required this.appState,
    this.homeCubit,
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
  }

  Future<void> _playSound() async {
    if (!state.isLoaded) {
      final bool loaded = await loadAudio();
      if (!loaded) return;
    }

    audioService.playSound(_sound.id);

    // Check if the app is muted via HomeCubit
    final bool isMuted = homeCubit?.isMuted ?? false;

    // Use the global app volume if available, otherwise use the local volume
    // If app is muted, set volume to 0
    double effectiveVolume;
    if (isMuted) {
      effectiveVolume = 0;
    } else {
      effectiveVolume = appState.appVolume > 0 ? appState.appVolume : state.volume;
    }

    audioService.setVolume(_sound.id, effectiveVolume / 100);
  }

  /// Stop the sound
  Future<void> _stopSound() async {
    audioService.stopSound(_sound.id);
  }

  /// Change the volume
  Future<void> onChangeVolume(double volume) async {
    emit(state.copyWith(volume: volume));

    // Check if the app is muted via HomeCubit
    final bool isMuted = homeCubit?.isMuted ?? false;

    // If muted, set volume to 0
    if (isMuted) {
      audioService.setVolume(_sound.id, 0);
      return;
    }

    // Apply the individual sound volume, but respect the global app volume
    // If global volume is lower, use that as a multiplier
    final double globalVolumeMultiplier = appState.appVolume / 100;
    final double effectiveVolume = volume * globalVolumeMultiplier;

    audioService.setVolume(_sound.id, effectiveVolume / 100);
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
}
