import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/screens/home/widgets/audio_button/audio_button_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_colors.dart';

class AudioButtonWithVolume extends StatefulWidget {
  final SoundModel sound;
  final bool isActive;
  final Function() onTapItem;

  const AudioButtonWithVolume({
    super.key,
    required this.sound,
    required this.isActive,
    required this.onTapItem,
  });

  @override
  State<AudioButtonWithVolume> createState() => _AudioButtonWithVolumeState();
}

class _AudioButtonWithVolumeState extends State<AudioButtonWithVolume> {
  final AudioButtonCubit cubit = AudioButtonCubit();
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    // Initialize the cubit with the sound model
    cubit.initialize(widget.sound);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioButtonCubit>(
      create: (_) => cubit,
      key: widget.key,
      child: BlocBuilder<AudioButtonCubit, AudioButtonState>(
        builder: (BuildContext context, AudioButtonState state) {
          return MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.categoryButtonSelected.withOpacity(0.5)
                    : (isHovered
                        ? AppColors.categoryButton.withOpacity(0.3)
                        : AppColors.categoryButton.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                    color: widget.isActive
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    width: widget.isActive ? 1.0 : 0.5),
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
                  onTap: () {
                    // Toggle sound playback
                    cubit.toggleSound();
                    // Call the parent's onTapItem callback
                    widget.onTapItem();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    transform: isHovered
                        ? (Matrix4.identity()..scale(1.05))
                        : Matrix4.identity(),
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BlocBuilder<AudioButtonCubit, AudioButtonState>(
                          buildWhen: (AudioButtonState previous,
                                  AudioButtonState current) =>
                              previous.isPlaying != current.isPlaying,
                          builder:
                              (BuildContext context, AudioButtonState state) {
                            return Icon(
                              widget.sound.icon,
                              color: state.isPlaying || widget.isActive
                                  ? Colors.white
                                  : Colors.white60,
                              size: 25,
                            );
                          },
                        ),
                        !widget.isActive
                            ? const SizedBox.shrink()
                            : Container(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 3.0,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 5.0,
                                      elevation: 2,
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 16,
                                    child: Slider(
                                      value: state.volume,
                                      max: 100,
                                      min: 0,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white54,
                                      onChanged: (double value) =>
                                          cubit.onChangeVolume(value),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
