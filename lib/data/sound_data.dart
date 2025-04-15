import 'package:flutter/material.dart';

import '../models/sound_model.dart';

/// Data class that manages the collection of sound items available in the application.
///
/// This class provides access to all available sounds and methods to retrieve them
/// by various criteria such as category or ID.
class SoundData {
  /// Gets a sound by its ID.
  ///
  /// Returns null if no sound with the given ID exists.
  static SoundModel? getSoundById(String id) {
    try {
      return sounds.firstWhere((SoundModel sound) => sound.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Gets all sounds belonging to a specific category.
  static List<SoundModel> getSoundsByCategory(String category) {
    return sounds.where((SoundModel sound) => sound.category == category).toList();
  }

  /// Gets all available categories from the sounds list.
  static List<String> getAllCategories() {
    return sounds.map((SoundModel sound) => sound.category).toSet().toList();
  }

  static const String basePath = 'assets/sounds';

  /// List of all available sound models in the application.
  static final List<SoundModel> sounds = <SoundModel>[
    // Weather sounds
    const SoundModel(
      id: 'light_rain',
      name: 'Light Rain',
      icon: Icons.cloud_outlined,
      category: 'weather',
      audioPath: '$basePath/light-rain.mp3',
    ),
    const SoundModel(
      id: 'heavy_rain',
      name: 'Heavy Rain',
      icon: Icons.cloud,
      category: 'weather',
      audioPath: '$basePath/rain.mp3',
    ),
    const SoundModel(
      id: 'thunder',
      name: 'Thunder',
      icon: Icons.thunderstorm_outlined,
      category: 'weather',
      audioPath: '$basePath/thunder.mp3',
    ),

    const SoundModel(
      id: 'wind',
      name: 'Wind',
      icon: Icons.air,
      category: 'weather',
      audioPath: '$basePath/wind.mp3',
    ),
    const SoundModel(
      id: 'forest',
      name: 'Forest',
      icon: Icons.forest_outlined,
      category: 'weather',
      audioPath: '$basePath/forest.mp3',
    ),

    // Nature sounds
    const SoundModel(
      id: 'leaves',
      name: 'Leaves',
      icon: Icons.eco_outlined,
      category: 'nature',
      audioPath: '$basePath/leaves.m4a',
    ),
    const SoundModel(
      id: 'waves',
      name: 'Waves',
      icon: Icons.waves_outlined,
      category: 'nature',
      audioPath: '$basePath/waves.mp3',
    ),
    const SoundModel(
      id: 'stream',
      name: 'Stream',
      icon: Icons.water_outlined,
      category: 'nature',
      audioPath: '$basePath/flowing-water.mp3',
    ),
    const SoundModel(
      id: 'water_drops',
      name: 'Water Drops',
      icon: Icons.water_drop_outlined,
      category: 'nature',
      audioPath: '$basePath/water.mp3',
    ),

    // Fire and ambience
    const SoundModel(
      id: 'fire',
      name: 'Fire',
      icon: Icons.local_fire_department_outlined,
      category: 'ambience',
      audioPath: '$basePath/fire.mp3',
    ),
    const SoundModel(
      id: 'night',
      name: 'Night',
      icon: Icons.mode_night_outlined,
      category: 'ambience',
    ),
    const SoundModel(
      id: 'cafe',
      name: 'Cafe',
      icon: Icons.coffee_outlined,
      category: 'ambience',
      audioPath: '$basePath/coffee-shop.mp3',
    ),
    const SoundModel(
      id: 'train',
      name: 'Train',
      icon: Icons.train_outlined,
      category: 'ambience',
      audioPath: '$basePath/train.mp3',
    ),

    // Sound patterns
    const SoundModel(
      id: 'fan',
      name: 'Fan',
      icon: Icons.air_outlined,
      category: 'noise',
      audioPath: '$basePath/fan-room.mp3',
    ),
    const SoundModel(
      id: 'white_noise',
      name: 'White Noise',
      icon: Icons.graphic_eq,
      category: 'noise',
    ),
    const SoundModel(
      id: 'brown_noise',
      name: 'Brown Noise',
      icon: Icons.equalizer,
      category: 'noise',
    ),
    const SoundModel(
      id: 'pink_noise',
      name: 'Pink Noise',
      icon: Icons.graphic_eq_outlined,
      category: 'noise',
    ),

    // Desert sounds (based on the cactus icon in the image)
    const SoundModel(
      id: 'desert_wind',
      name: 'Desert Wind',
      icon: Icons.terrain_outlined,
      category: 'desert',
    ),
    const SoundModel(
      id: 'desert_night',
      name: 'Desert Night',
      icon: Icons.nightlight_outlined,
      category: 'desert',
    ),
    const SoundModel(
      id: 'desert_heat',
      name: 'Desert Heat',
      icon: Icons.wb_sunny_outlined,
      category: 'desert',
    ),

    // Urban sounds (based on the city/building icon in the image)
    const SoundModel(
      id: 'city_traffic',
      name: 'City Traffic',
      icon: Icons.directions_car_outlined,
      category: 'urban',
      audioPath: '$basePath/traffic.mp3',
    ),
    const SoundModel(
      id: 'city_park',
      name: 'City Park',
      icon: Icons.park_outlined,
      category: 'urban',
    ),
    const SoundModel(
      id: 'construction',
      name: 'Construction',
      icon: Icons.construction_outlined,
      category: 'urban',
    ),
    const SoundModel(
      id: 'subway',
      name: 'Subway',
      icon: Icons.subway_outlined,
      category: 'urban',
    ),

    // Fireplace sounds (based on the fireplace icon in the image)
    const SoundModel(
      id: 'fireplace',
      name: 'Fireplace',
      icon: Icons.fireplace_outlined,
      category: 'home',
    ),
    const SoundModel(
      id: 'home_ambience',
      name: 'Home Ambience',
      icon: Icons.home_outlined,
      category: 'home',
    ),
    const SoundModel(
      id: 'kitchen',
      name: 'Kitchen Sounds',
      icon: Icons.kitchen_outlined,
      category: 'home',
    ),

    // Beach sounds (based on the sunset icon in the image)
    const SoundModel(
      id: 'beach_waves',
      name: 'Beach Waves',
      icon: Icons.beach_access_outlined,
      category: 'beach',
      audioPath: '$basePath/waves.mp3',
    ),
    const SoundModel(
      id: 'seagulls',
      name: 'Seagulls',
      icon: Icons.flight_outlined,
      category: 'beach',
    ),
    const SoundModel(
      id: 'beach_bonfire',
      name: 'Beach Bonfire',
      icon: Icons.outdoor_grill_outlined,
      category: 'beach',
    ),

    // Camping sounds (based on the tent icon in the image)
    const SoundModel(
      id: 'campfire',
      name: 'Campfire',
      icon: Icons.outdoor_grill_outlined,
      category: 'camping',
    ),
    const SoundModel(
      id: 'forest_night',
      name: 'Forest Night',
      icon: Icons.dark_mode_outlined,
      category: 'camping',
    ),
    const SoundModel(
      id: 'tent_rain',
      name: 'Rain on Tent',
      icon: Icons.water_outlined,
      category: 'camping',
    ),

    // Underwater sounds (based on the jellyfish icon in the image)
    const SoundModel(
      id: 'underwater',
      name: 'Underwater',
      icon: Icons.water_outlined,
      category: 'underwater',
    ),
    const SoundModel(
      id: 'whale_song',
      name: 'Whale Song',
      icon: Icons.waves_outlined,
      category: 'underwater',
    ),
    const SoundModel(
      id: 'bubbles',
      name: 'Bubbles',
      icon: Icons.bubble_chart_outlined,
      category: 'underwater',
    ),

    // Washing machine (based on the washing machine icon in the image)
    const SoundModel(
      id: 'washing_machine',
      name: 'Washing Machine',
      icon: Icons.local_laundry_service_outlined,
      category: 'appliances',
    ),
    const SoundModel(
      id: 'dryer',
      name: 'Clothes Dryer',
      icon: Icons.dry_outlined,
      category: 'appliances',
    ),
    const SoundModel(
      id: 'dishwasher',
      name: 'Dishwasher',
      icon: Icons.countertops_outlined,
      category: 'appliances',
    ),

    // Tropical sounds (based on the tropical leaf icon in the image)
    const SoundModel(
      id: 'tropical_rain',
      name: 'Tropical Rain',
      icon: Icons.grain_outlined,
      category: 'tropical',
    ),
    const SoundModel(
      id: 'jungle',
      name: 'Jungle Sounds',
      icon: Icons.forest_outlined,
      category: 'tropical',
      audioPath: '$basePath/jungle.mp3',
    ),
    const SoundModel(
      id: 'tropical_birds',
      name: 'Tropical Birds',
      icon: Icons.flight_takeoff_outlined,
      category: 'tropical',
    ),

    // Bubbles sounds (based on the bubbles icon in the image)
    const SoundModel(
      id: 'bubbling_water',
      name: 'Bubbling Water',
      icon: Icons.bubble_chart_outlined,
      category: 'water',
    ),
    const SoundModel(
      id: 'boiling_water',
      name: 'Boiling Water',
      icon: Icons.whatshot_outlined,
      category: 'water',
    ),
    const SoundModel(
      id: 'fish_tank',
      name: 'Fish Tank',
      icon: Icons.waves_outlined,
      category: 'water',
    ),
  ];
}
