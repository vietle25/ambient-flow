import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model class representing a sound item in the application.
///
/// Each sound has a unique identifier, a display name, and an associated icon.
class SoundModel extends Equatable {
  /// The unique identifier for the sound.
  final String id;

  /// The display name of the sound.
  final String name;

  /// The icon representing the sound in the UI.
  final IconData icon;

  /// The category this sound belongs to (e.g., 'weather', 'nature', 'ambient').
  final String category;

  /// Optional path to the sound file.
  final String? audioPath;

  /// Creates a new [SoundModel] instance.
  const SoundModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    this.audioPath,
  });

  /// Creates a copy of this [SoundModel] with the given fields replaced with new values.
  SoundModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? category,
    String? audioPath,
  }) {
    return SoundModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, icon, category, audioPath];

  @override
  String toString() => 'SoundModel(id: $id, name: $name, category: $category)';
}
