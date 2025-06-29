import 'package:equatable/equatable.dart';

/// Model class representing a single sound item within a bookmark.
///
/// This stores the sound ID and its volume level when the bookmark was created.
class SoundBookmarkItem extends Equatable {
  /// The unique identifier for the sound.
  final String soundId;

  /// The volume level for this sound (0.0 to 100.0).
  final double volume;

  /// Creates a new [SoundBookmarkItem] instance.
  const SoundBookmarkItem({
    required this.soundId,
    required this.volume,
  });

  /// Creates a copy of this [SoundBookmarkItem] with the given fields replaced with new values.
  SoundBookmarkItem copyWith({
    String? soundId,
    double? volume,
  }) {
    return SoundBookmarkItem(
      soundId: soundId ?? this.soundId,
      volume: volume ?? this.volume,
    );
  }

  /// Converts this [SoundBookmarkItem] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'soundId': soundId,
      'volume': volume,
    };
  }

  /// Creates a [SoundBookmarkItem] from a JSON map.
  factory SoundBookmarkItem.fromJson(Map<String, dynamic> json) {
    return SoundBookmarkItem(
      soundId: json['soundId'] as String,
      volume: (json['volume'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [soundId, volume];

  @override
  String toString() => 'SoundBookmarkItem(soundId: $soundId, volume: $volume)';
}
