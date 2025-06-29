import 'package:equatable/equatable.dart';

import 'sound_bookmark_item.dart';

/// Model class representing a saved bookmark of sound combinations.
///
/// A bookmark contains a collection of sounds with their volume levels,
/// along with metadata like name, creation time, and global app volume.
class SoundBookmark extends Equatable {
  /// The unique identifier for the bookmark.
  final String id;

  /// The user-defined name for the bookmark.
  final String name;

  /// The icon for the bookmark (emoji or icon name).
  final String icon;

  /// The list of sounds and their volumes in this bookmark.
  final List<SoundBookmarkItem> sounds;

  /// The global app volume when this bookmark was created.
  final double globalVolume;

  /// Whether the app was muted when this bookmark was created.
  final bool isMuted;

  /// The timestamp when this bookmark was created.
  final DateTime createdAt;

  /// The timestamp when this bookmark was last updated.
  final DateTime updatedAt;

  /// Whether this is the last used bookmark (for auto-restore).
  final bool isLastUsed;

  /// Creates a new [SoundBookmark] instance.
  const SoundBookmark({
    required this.id,
    required this.name,
    required this.icon,
    required this.sounds,
    required this.globalVolume,
    required this.isMuted,
    required this.createdAt,
    required this.updatedAt,
    this.isLastUsed = false,
  });

  /// Creates a copy of this [SoundBookmark] with the given fields replaced with new values.
  SoundBookmark copyWith({
    String? id,
    String? name,
    String? icon,
    List<SoundBookmarkItem>? sounds,
    double? globalVolume,
    bool? isMuted,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLastUsed,
  }) {
    return SoundBookmark(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      sounds: sounds ?? this.sounds,
      globalVolume: globalVolume ?? this.globalVolume,
      isMuted: isMuted ?? this.isMuted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLastUsed: isLastUsed ?? this.isLastUsed,
    );
  }

  /// Converts this [SoundBookmark] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'sounds': sounds.map((sound) => sound.toJson()).toList(),
      'globalVolume': globalVolume,
      'isMuted': isMuted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isLastUsed': isLastUsed,
    };
  }

  /// Creates a [SoundBookmark] from a JSON map.
  factory SoundBookmark.fromJson(Map<String, dynamic> json) {
    return SoundBookmark(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '🎵', // Default icon if not present
      sounds: (json['sounds'] as List<dynamic>)
          .map((soundJson) =>
              SoundBookmarkItem.fromJson(soundJson as Map<String, dynamic>))
          .toList(),
      globalVolume: (json['globalVolume'] as num).toDouble(),
      isMuted: json['isMuted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isLastUsed: json['isLastUsed'] as bool? ?? false,
    );
  }

  /// Creates a new bookmark with updated timestamp.
  SoundBookmark withUpdatedTimestamp() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Creates a new bookmark marked as last used.
  SoundBookmark markAsLastUsed() {
    return copyWith(isLastUsed: true, updatedAt: DateTime.now());
  }

  /// Creates a new bookmark marked as not last used.
  SoundBookmark unmarkAsLastUsed() {
    return copyWith(isLastUsed: false);
  }

  /// Gets the number of sounds in this bookmark.
  int get soundCount => sounds.length;

  /// Checks if this bookmark is empty (no sounds).
  bool get isEmpty => sounds.isEmpty;

  /// Checks if this bookmark is not empty.
  bool get isNotEmpty => sounds.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        sounds,
        globalVolume,
        isMuted,
        createdAt,
        updatedAt,
        isLastUsed,
      ];

  @override
  String toString() =>
      'SoundBookmark(id: $id, name: $name, soundCount: $soundCount)';
}
