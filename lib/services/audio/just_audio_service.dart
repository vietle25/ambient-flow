import 'package:ambientflow/models/sound_model.dart';
import 'package:colossus_flutter_common/utils/log/log_mixin.dart';
import 'package:just_audio/just_audio.dart';

import 'audio_service.dart';

/// Implementation of [AudioService] using the just_audio package.
class JustAudioService with LogMixin implements AudioService {
  final Map<String, AudioPlayer> _players = <String, AudioPlayer>{};
  final Map<String, SoundModel> _loadedSounds = <String, SoundModel>{};
  bool _isInitialized = false;
  bool _isDisposing = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  @override
  Future<bool> loadSound(SoundModel sound) async {
    if (!_isInitialized) await initialize();

    // Check if sound is already loaded
    if (_loadedSounds.containsKey(sound.id)) {
      return true;
    }

    // Check if sound has an audio path
    if (sound.audioPath == null) {
      logD('Sound ${sound.id} has no audio path');
      return false;
    }

    try {
      final AudioPlayer player = AudioPlayer();
      await player.setAsset(sound.audioPath!);
      await player.setLoopMode(LoopMode.one); // Loop the sound

      _players[sound.id] = player;
      _loadedSounds[sound.id] = sound;

      return true;
    } catch (e) {
      logE('Error loading sound ${sound.id}: $e');
      return false;
    }
  }

  @override
  Future<bool> playSound(String soundId) async {
    if (_isDisposing || !_loadedSounds.containsKey(soundId)) {
      logD('Sound $soundId not loaded or service is disposing');
      return false;
    }

    try {
      final AudioPlayer? player = _players[soundId];
      if (player == null) return false;
      await player.play();
      return true;
    } catch (e) {
      logE('Error playing sound $soundId: $e');
      return false;
    }
  }

  @override
  Future<bool> stopSound(String soundId) async {
    if (_isDisposing || !_loadedSounds.containsKey(soundId)) {
      return false;
    }

    try {
      final AudioPlayer? player = _players[soundId];
      if (player == null) return false;
      await player.stop();
      return true;
    } catch (e) {
      logE('Error stopping sound $soundId: $e');
      return false;
    }
  }

  @override
  Future<void> setVolume(String soundId, double volume) async {
    if (_isDisposing || !_loadedSounds.containsKey(soundId)) {
      return;
    }

    try {
      final AudioPlayer? player = _players[soundId];
      if (player == null) return;
      // Ensure volume is between 0.0 and 1.0
      final double normalizedVolume = volume.clamp(0.0, 1.0);
      await player.setVolume(normalizedVolume);
    } catch (e) {
      logE('Error setting volume for sound $soundId: $e');
    }
  }

  @override
  bool isPlaying(String soundId) {
    if (!_loadedSounds.containsKey(soundId)) {
      return false;
    }

    try {
      final AudioPlayer player = _players[soundId]!;
      return player.playing;
    } catch (e) {
      logE('Error checking if sound $soundId is playing: $e');
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    if (_isDisposing) return;
    _isDisposing = true;

    // Create a copy to avoid concurrent modification
    final List<AudioPlayer> playersToDispose = List.from(_players.values);
    for (final AudioPlayer player in playersToDispose) {
      try {
        await player.dispose();
      } catch (e) {
        // Continue disposing other players even if one fails
      }
    }
    _players.clear();
    _loadedSounds.clear();
    _isInitialized = false;
  }
}
