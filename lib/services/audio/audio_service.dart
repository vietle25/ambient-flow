import 'package:ambientflow/models/sound_model.dart';

/// Abstract class defining the interface for audio playback services.
abstract class AudioService {
  /// Initialize the audio service.
  Future<void> initialize();

  /// Load a sound for playback.
  /// 
  /// Returns true if the sound was successfully loaded.
  Future<bool> loadSound(SoundModel sound);

  /// Play a loaded sound.
  /// 
  /// Returns true if the sound started playing successfully.
  Future<bool> playSound(String soundId);

  /// Stop playing a sound.
  /// 
  /// Returns true if the sound was successfully stopped.
  Future<bool> stopSound(String soundId);

  /// Set the volume for a specific sound.
  /// 
  /// [volume] should be a value between 0.0 and 1.0.
  Future<void> setVolume(String soundId, double volume);

  /// Check if a sound is currently playing.
  bool isPlaying(String soundId);

  /// Dispose of resources used by the audio service.
  Future<void> dispose();
}
