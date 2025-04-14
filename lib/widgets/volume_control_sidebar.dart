import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_colors.dart';
import '../screens/home/cubit/home_cubit.dart';
import '../screens/home/cubit/home_state.dart';

class VolumeControlSidebar extends StatelessWidget {
  final String soundId;
  final String soundName;

  const VolumeControlSidebar({
    super.key,
    required this.soundId,
    required this.soundName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (HomeState previous, HomeState current) =>
          previous.volume != current.volume ||
          previous.activeVolumeControlSoundId !=
              current.activeVolumeControlSoundId,
      builder: (BuildContext context, HomeState state) {
        // Only show if this sound's volume control is active
        if (state.activeVolumeControlSoundId != soundId) {
          return const SizedBox.shrink();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 130, // Match button width
          height: 150, // Limit height
          constraints: const BoxConstraints(maxHeight: 200),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 16),
                // Sound name at the top
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    soundName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                // Horizontal slider for volume
                SizedBox(
                  width: 110,
                  child: Slider(
                    value: state.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.3),
                    onChanged: (double value) {
                      BlocProvider.of<HomeCubit>(context).setVolume(value);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Volume value as percentage
                Text(
                  '${(state.volume * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                // Close button
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 16),
                  onPressed: () {
                    BlocProvider.of<HomeCubit>(context).closeVolumeControl();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
