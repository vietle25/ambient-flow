import '../../data/sound_data.dart';
import '../../models/sound_bookmark.dart';
import '../../models/sound_bookmark_item.dart';
import '../../models/sound_model.dart';
import '../../state/app_state.dart';
import 'audio_service.dart';

/// Service for coordinating audio operations across the app.
///
/// This service provides high-level audio operations like applying bookmarks,
/// getting current sound states, and managing multiple sounds at once.
class AudioCoordinatorService {
  final AudioService _audioService;
  final AppState _appState;

  /// Creates a new [AudioCoordinatorService] instance.
  AudioCoordinatorService({
    required AudioService audioService,
    required AppState appState,
  })  : _audioService = audioService,
        _appState = appState;

  /// Applies a bookmark by stopping all current sounds and starting the bookmarked ones.
  Future<void> applyBookmark(SoundBookmark bookmark) async {
    try {
      // First, stop all currently playing sounds
      await stopAllSounds();

      // Clear the app state
      _appState.activeSoundIds?.clear();

      // Apply global volume settings
      _appState.appVolume = bookmark.globalVolume;

      // Start each sound in the bookmark
      for (final SoundBookmarkItem item in bookmark.sounds) {
        await _startSoundWithVolume(item.soundId, item.volume);
      }
    } catch (e) {
      throw Exception('Failed to apply bookmark: $e');
    }
  }

  /// Gets the current state of all sounds as bookmark items.
  List<SoundBookmarkItem> getCurrentSoundState() {
    final List<SoundBookmarkItem> items = [];
    final Set<String>? activeSoundIds = _appState.activeSoundIds;

    if (activeSoundIds != null && activeSoundIds.isNotEmpty) {
      // Create a copy to avoid concurrent modification
      final List<String> soundIdsCopy = List.from(activeSoundIds);

      for (final String soundId in soundIdsCopy) {
        // For now, we'll use a default volume since we can't easily access
        // individual AudioButtonCubit volumes. This could be improved by
        // maintaining a central volume state.
        items.add(SoundBookmarkItem(
          soundId: soundId,
          volume: 50.0, // Default volume
        ));
      }
    }

    return items;
  }

  /// Stops all currently playing sounds.
  Future<void> stopAllSounds() async {
    final Set<String>? activeSoundIds = _appState.activeSoundIds;

    if (activeSoundIds != null && activeSoundIds.isNotEmpty) {
      // Create a copy to avoid concurrent modification
      final List<String> soundsToStop = List.from(activeSoundIds);

      for (final String soundId in soundsToStop) {
        await _audioService.stopSound(soundId);
        _appState.removeActiveSound(soundId);
      }
    }
  }

  /// Starts a sound with a specific volume.
  Future<void> _startSoundWithVolume(String soundId, double volume) async {
    // Find the sound model
    final SoundModel? soundModel = _findSoundModel(soundId);
    if (soundModel == null) {
      throw Exception('Sound model not found for ID: $soundId');
    }

    // Load the sound if not already loaded
    final bool loaded = await _audioService.loadSound(soundModel);
    if (!loaded) {
      throw Exception('Failed to load sound: $soundId');
    }

    // Set the volume (convert from 0-100 to 0-1 range)
    await _audioService.setVolume(soundId, volume / 100.0);

    // Start playing the sound
    final bool started = await _audioService.playSound(soundId);
    if (!started) {
      throw Exception('Failed to start sound: $soundId');
    }

    // Update app state
    _appState.addActiveSound(soundId);
  }

  /// Finds a sound model by ID.
  SoundModel? _findSoundModel(String soundId) {
    try {
      return SoundData.sounds.firstWhere((sound) => sound.id == soundId);
    } catch (e) {
      return null;
    }
  }

  /// Gets the current global volume.
  double getCurrentGlobalVolume() {
    return _appState.appVolume;
  }

  /// Checks if any sounds are currently playing.
  bool hasActiveSounds() {
    return _appState.activeSoundIds?.isNotEmpty ?? false;
  }

  /// Gets the list of currently active sound IDs.
  Set<String> getActiveSoundIds() {
    return Set.from(_appState.activeSoundIds ?? <String>{});
  }

  /// Preloads all available sounds for better performance.
  Future<void> preloadAllSounds() async {
    await _audioService.initialize();

    for (final SoundModel sound in SoundData.sounds) {
      if (sound.audioPath != null) {
        try {
          await _audioService.loadSound(sound);
        } catch (e) {
          // Continue loading other sounds even if one fails
          print('Failed to preload sound ${sound.id}: $e');
        }
      }
    }
  }

  /// Sets the global volume and applies it to all active sounds.
  Future<void> setGlobalVolume(double volume) async {
    _appState.appVolume = volume;

    // Apply the global volume to all active sounds
    final Set<String>? activeSoundIds = _appState.activeSoundIds;
    if (activeSoundIds != null && activeSoundIds.isNotEmpty) {
      for (final String soundId in activeSoundIds) {
        // This applies the global volume, but individual sound volumes
        // would need to be factored in for a more sophisticated implementation
        await _audioService.setVolume(soundId, volume / 100.0);
      }
    }
  }

  /// Mutes or unmutes all sounds.
  Future<void> setMuted(bool muted) async {
    if (muted) {
      await setGlobalVolume(0);
    } else {
      // Restore previous volume
      final double restoredVolume =
          _appState.previousVolume > 0 ? _appState.previousVolume : 50.0;
      await setGlobalVolume(restoredVolume);
    }
  }
}
