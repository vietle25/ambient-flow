import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/screens/home/widgets/audio_button/audio_button_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_colors.dart';

/// A widget that displays an audio button with volume control.
///
/// This widget is optimized for performance when used in a scrollable list.
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

class _AudioButtonWithVolumeState extends State<AudioButtonWithVolume> with AutomaticKeepAliveClientMixin {
  late final AudioButtonCubit _cubit;
  bool _isHovered = false;

  @override
  bool get wantKeepAlive => true; // Keep this widget alive when scrolling

  @override
  void initState() {
    super.initState();
    _cubit = AudioButtonCubit();
    // Initialize the cubit with the sound model
    _cubit.initialize(widget.sound);
  }

  @override
  void dispose() {
    _cubit.close(); // Properly dispose the cubit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return BlocProvider<AudioButtonCubit>.value(
      value: _cubit, // Use .value constructor to avoid recreating the cubit
      child: _AudioButtonContent(
        sound: widget.sound,
        isActive: widget.isActive,
        isHovered: _isHovered,
        onHoverChanged: (bool value) {
          if (mounted) {
            setState(() => _isHovered = value);
          }
        },
        onTap: () {
          // Toggle sound playback
          _cubit.toggleSound();
          // Call the parent's onTapItem callback
          widget.onTapItem();
        },
      ),
    );
  }
}

/// A separate stateless widget for the content to minimize rebuilds
class _AudioButtonContent extends StatelessWidget {
  final SoundModel sound;
  final bool isActive;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onTap;

  const _AudioButtonContent({
    required this.sound,
    required this.isActive,
    required this.isHovered,
    required this.onHoverChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
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
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: isHovered
                  ? (Matrix4.identity()..scale(1.05))
                  : Matrix4.identity(),
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _AudioButtonIcon(sound: sound, isActive: isActive),
                  if (isActive) _VolumeSlider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A separate widget for the icon to minimize rebuilds
class _AudioButtonIcon extends StatelessWidget {
  final SoundModel sound;
  final bool isActive;

  const _AudioButtonIcon({
    required this.sound,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioButtonCubit, AudioButtonState>(
      buildWhen: (AudioButtonState previous, AudioButtonState current) =>
          previous.isPlaying != current.isPlaying,
      builder: (BuildContext context, AudioButtonState state) {
        return Icon(
          sound.icon,
          color: state.isPlaying || isActive ? Colors.white : Colors.white60,
          size: 25,
        );
      },
    );
  }
}

/// A separate widget for the volume slider to minimize rebuilds
class _VolumeSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioButtonCubit, AudioButtonState>(
      buildWhen: (AudioButtonState previous, AudioButtonState current) =>
          previous.volume != current.volume,
      builder: (BuildContext context, AudioButtonState state) {
        return Container(
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
                    context.read<AudioButtonCubit>().onChangeVolume(value),
              ),
            ),
          ),
        );
      },
    );
  }
}
