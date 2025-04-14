import 'package:flutter/material.dart';

import '../screens/home/widgets/audio_button_with_volume.dart';

class MainContentSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const MainContentSection({
    super.key,
    this.isMobile = false,
    this.isTablet = false,
    this.isDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    // Determine grid columns based on screen size
    int crossAxisCount = 5; // More columns for desktop

    if (isMobile) {
      crossAxisCount = 2;
    } else if (isTablet) {
      crossAxisCount = 4;
    }

    // Calculate the max width based on screen size
    // For desktop, we want it to take up only 50% of the screen width
    double maxWidth = MediaQuery.of(context).size.width;
    if (isDesktop) {
      maxWidth = maxWidth * 0.5; // 50% of screen width for desktop
    } else if (isTablet) {
      maxWidth = maxWidth * 0.7; // 70% of screen width for tablet
    }

    return Expanded(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: GridView.count(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 16 : 20,
            ),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: isMobile ? 12 : 16,
            crossAxisSpacing: isMobile ? 12 : 16,
            childAspectRatio: 1.0, // Square aspect ratio for buttons
            children: _buildSoundButtons(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSoundButtons(BuildContext context) {
    // Create a list of sound definitions
    final List<Map<String, Object>> soundDefinitions = <Map<String, Object>>[
      // First row - weather sounds
      <String, Object>{
        'icon': Icons.cloud_outlined,
        'id': 'light_rain',
        'name': 'Light Rain'
      },
      <String, Object>{
        'icon': Icons.cloud,
        'id': 'heavy_rain',
        'name': 'Heavy Rain'
      },
      <String, Object>{'icon': Icons.air, 'id': 'wind', 'name': 'Wind'},
      <String, Object>{
        'icon': Icons.forest_outlined,
        'id': 'forest',
        'name': 'Forest'
      },

      // Second row - nature sounds
      <String, Object>{
        'icon': Icons.eco_outlined,
        'id': 'leaves',
        'name': 'Leaves'
      },
      <String, Object>{
        'icon': Icons.waves_outlined,
        'id': 'waves',
        'name': 'Waves'
      },
      <String, Object>{
        'icon': Icons.water_outlined,
        'id': 'stream',
        'name': 'Stream'
      },
      <String, Object>{
        'icon': Icons.water_drop_outlined,
        'id': 'water_drops',
        'name': 'Water Drops'
      },

      // Third row - fire and ambience
      <String, Object>{
        'icon': Icons.local_fire_department_outlined,
        'id': 'fire',
        'name': 'Fire'
      },
      <String, Object>{
        'icon': Icons.mode_night_outlined,
        'id': 'night',
        'name': 'Night'
      },
      <String, Object>{
        'icon': Icons.coffee_outlined,
        'id': 'cafe',
        'name': 'Cafe'
      },
      <String, Object>{
        'icon': Icons.train_outlined,
        'id': 'train',
        'name': 'Train'
      },

      // Fourth row - sound patterns
      <String, Object>{'icon': Icons.air_outlined, 'id': 'fan', 'name': 'Fan'},
      <String, Object>{
        'icon': Icons.graphic_eq,
        'id': 'white_noise',
        'name': 'White Noise'
      },
      <String, Object>{
        'icon': Icons.equalizer,
        'id': 'brown_noise',
        'name': 'Brown Noise'
      },
      <String, Object>{
        'icon': Icons.graphic_eq_outlined,
        'id': 'pink_noise',
        'name': 'Pink Noise'
      },
    ];

    return soundDefinitions.map((Map<String, Object> sound) {
      return AudioButtonWithVolume(
        icon: sound['icon'] as IconData,
        soundId: sound['id'] as String,
        soundName: (sound['name'] as String?) ?? (sound['id'] as String),
      );
    }).toList();
  }
}
