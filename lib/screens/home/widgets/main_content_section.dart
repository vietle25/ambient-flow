import 'package:ambientflow/data/sound_data.dart';
import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/screens/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import 'audio_button/audio_button_with_volume.dart';

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
    int crossAxisCount = 4; // More columns for desktop

    if (isMobile) {
      crossAxisCount = 2;
    } else if (isTablet) {
      crossAxisCount = 3;
    }

    // Calculate the max width based on screen size
    // For desktop, we want it to take up only 50% of the screen width
    double maxWidth = MediaQuery.of(context).size.width;
    if (isDesktop) {
      maxWidth = maxWidth * 0.6;
    } else if (isTablet) {
      maxWidth = maxWidth * 0.8;
    }

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
          ),
          child: GridView.count(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 16 : 20,
            ),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: isMobile ? 12 : 16,
            crossAxisSpacing: isMobile ? 12 : 16,
            childAspectRatio: 1.0, // Square aspect ratio for buttons
            physics: const BouncingScrollPhysics(),
            children: _buildSoundButtons(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSoundButtons(BuildContext context) {
    final HomeCubit cubit = BlocProvider.of<HomeCubit>(context);

    return SoundData.sounds.map((SoundModel sound) {
      return BlocBuilder<HomeCubit, HomeState>(
          builder: (BuildContext context, HomeState state) {
        final bool isActive = state.activeSounds.contains(sound.id);
        return AudioButtonWithVolume(
          key: ValueKey<String>(sound.id),
          sound: sound,
          onTapItem: () =>
              cubit.onTapItem(soundId: sound.id, isActive: isActive),
          isActive: isActive,
        );
      });
    }).toList();
  }
}
