import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/screens/home/widgets/audio_button/audio_button_cubit.dart';
import 'package:ambientflow/services/di/service_locator.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:colossus_flutter_common/utils/log/log_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_colors.dart';
import '../../../../services/audio/audio_service.dart';

class AudioButtonWidget extends StatefulWidget {
  final SoundModel sound;

  const AudioButtonWidget({
    super.key,
    required this.sound,
  });

  @override
  State<AudioButtonWidget> createState() => _AudioButtonWidgetState();
}

class _AudioButtonWidgetState extends State<AudioButtonWidget>
    with AutomaticKeepAliveClientMixin, LogMixin {
  final AudioButtonCubit _cubit = AudioButtonCubit(
    audioService: getIt<AudioService>(),
    appState: getIt<AppState>(),
  );
  bool _isHovered = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _cubit.initialize(widget.sound);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    logD('build ${widget.sound.id}');
    return BlocProvider<AudioButtonCubit>(
      create: (BuildContext context) => _cubit,
      child: _AudioButtonContent(
        sound: widget.sound,
        isHovered: _isHovered,
        onHoverChanged: (bool value) {
          if (mounted) {
            setState(() => _isHovered = value);
          }
        },
        onTap: () => _cubit.toggleSound(),
      ),
    );
  }
}

class _AudioButtonContent extends StatelessWidget {
  final SoundModel sound;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onTap;

  const _AudioButtonContent({
    required this.sound,
    required this.isHovered,
    required this.onHoverChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: BlocBuilder<AudioButtonCubit, AudioButtonState>(
          buildWhen: (AudioButtonState previous, AudioButtonState current) =>
              previous.isActive != current.isActive,
          builder: (BuildContext context, AudioButtonState state) {
            return Container(
              decoration: BoxDecoration(
                color: state.isActive
                    ? AppColors.categoryButtonSelected.withOpacity(0.5)
                    : (isHovered
                        ? AppColors.categoryButton.withOpacity(0.3)
                        : AppColors.categoryButton.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                    color: state.isActive
                        ? Colors.white.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    width: state.isActive ? 1.0 : 0.5),
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
                        Icon(
                          sound.icon,
                          color: state.isActive ? Colors.white : Colors.white60,
                          size: 25,
                        ),
                        _VolumeSlider(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

/// A separate widget for the volume slider to minimize rebuilds
class _VolumeSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioButtonCubit, AudioButtonState>(
      buildWhen: (AudioButtonState previous, AudioButtonState current) =>
          previous.volume != current.volume ||
          previous.isActive != current.isActive,
      builder: (BuildContext context, AudioButtonState state) {
        if (!state.isActive) {
          return const SizedBox.shrink();
        }

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
