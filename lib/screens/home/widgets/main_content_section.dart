import 'package:ambientflow/data/sound_data.dart';
import 'package:ambientflow/models/sound_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'audio_button/audio_button_with_volume.dart';

class MainContentSection extends StatefulWidget {
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
  State<MainContentSection> createState() => _MainContentSectionState();
}

class _MainContentSectionState extends State<MainContentSection> {
  // Cache the sound buttons to prevent rebuilding them on every scroll
  late final List<Widget> _soundButtons;

  @override
  void initState() {
    super.initState();
    // Pre-build the sound buttons once
    _soundButtons = _buildSoundButtons();
  }

  @override
  Widget build(BuildContext context) {
    // Determine grid columns based on screen size
    int crossAxisCount = 4; // More columns for desktop

    if (widget.isMobile) {
      crossAxisCount = 2;
    } else if (widget.isTablet) {
      crossAxisCount = 3;
    }

    // Calculate the max width based on screen size
    // For desktop, we want it to take up only 50% of the screen width
    double maxWidth = MediaQuery.of(context).size.width;
    if (widget.isDesktop) {
      maxWidth = maxWidth * 0.6;
    } else if (widget.isTablet) {
      maxWidth = maxWidth * 0.8;
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: maxWidth / 2.5,
          vertical: kToolbarHeight + 40,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: widget.isMobile ? 12 : 16,
          crossAxisSpacing: widget.isMobile ? 12 : 16,
          childAspectRatio: 1.0, // Square aspect ratio for buttons
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: _soundButtons.length,
        itemBuilder: (BuildContext context, int index) => _soundButtons[index],
        addAutomaticKeepAlives: true,
        cacheExtent: 500, // Increase cache extent to reduce rebuilds
      ),
    );
  }

  List<Widget> _buildSoundButtons() {
    return SoundData.sounds.map((SoundModel sound) {
      return BlocBuilder<HomeCubit, HomeState>(
        key: ValueKey<String>('sound_state_${sound.id}'),
        buildWhen: (HomeState previous, HomeState current) {
          // Only rebuild when the active state of this specific sound changes
          final bool wasActive = previous.activeSounds.contains(sound.id);
          final bool isActive = current.activeSounds.contains(sound.id);
          return wasActive != isActive;
        },
        builder: (BuildContext context, HomeState state) {
          final bool isActive = state.activeSounds.contains(sound.id);
          return AudioButtonWithVolume(
            key: ValueKey<String>(sound.id),
            sound: sound,
            isActive: isActive,
            onTapItem: () {
              // Toggle the sound in the HomeCubit
              context.read<HomeCubit>().toggleSound(sound.id);
            },
          );
        },
      );
    }).toList();
  }
}
