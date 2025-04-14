import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/volume_control_sidebar.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class AudioButtonWithVolume extends StatefulWidget {
  final IconData icon;
  final String soundId;
  final String soundName;

  const AudioButtonWithVolume({
    super.key,
    required this.icon,
    required this.soundId,
    required this.soundName,
  });

  @override
  State<AudioButtonWithVolume> createState() => _AudioButtonWithVolumeState();
}

class _AudioButtonWithVolumeState extends State<AudioButtonWithVolume> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      key: ValueKey<String>(widget.soundId),
      buildWhen: (HomeState previous, HomeState current) =>
          previous.activeVolumeControlSoundId !=
          current.activeVolumeControlSoundId,
      builder: (BuildContext context, HomeState state) {
        final bool isVolumeControlActive =
            state.activeVolumeControlSoundId == widget.soundId;
        final bool isActive = state.activeSounds.contains(widget.soundId);
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: Container(
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.categoryButtonSelected.withOpacity(0.5)
                  : (isHovered
                      ? AppColors.categoryButton.withOpacity(0.3)
                      : AppColors.categoryButton.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                  color: isActive
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
                  width: isActive ? 1.0 : 0.5),
            ),
            constraints: const BoxConstraints(
              minWidth: 100,
              minHeight: 100,
              maxWidth: 200,
              maxHeight: 200,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () => onTapItem(context, isActive),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  transform: isHovered
                      ? (Matrix4.identity()..scale(1.05))
                      : Matrix4.identity(),
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Icon(
                        widget.icon,
                        color: isActive ? Colors.white : Colors.white60,
                        size: 25,
                      ),
                      VolumeControlSidebar(
                        soundId: widget.soundId,
                        soundName: widget.soundName,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onTapItem(BuildContext context, bool isActive) {
    // Toggle the sound
    BlocProvider.of<HomeCubit>(context).toggleSound(widget.soundId);

    // If the sound is now active, show the volume control
    if (!isActive) {
      // Get the cubit before the async gap
      final HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
      // Short delay to show volume control after sound is activated
      Future<void>.delayed(const Duration(milliseconds: 100), () {
        cubit.toggleVolumeControl(widget.soundId);
      });
    }
  }
}
