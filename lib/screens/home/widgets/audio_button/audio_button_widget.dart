import 'package:ambientflow/models/sound_model.dart';
import 'package:ambientflow/screens/home/cubit/home_cubit.dart';
import 'package:ambientflow/screens/home/widgets/audio_button/audio_button_cubit.dart';
import 'package:ambientflow/services/di/service_locator.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:colossus_flutter_common/utils/log/log_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slider_bar/slider_bar.dart';

import '../../../../constants/app_colors.dart';
import '../../../../services/audio/audio_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Dart',
      home: Scaffold(
        appBar: AppBar(title: const Text('🌟 Welcome')),
        body: const Center(child: Text('Hello, Dart & Flutter! 🚀')),
      ),
    );
  }
}

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
  AudioButtonCubit? _cubit;

  void _initCubit() {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    _cubit = AudioButtonCubit(
      audioService: getIt<AudioService>(),
      appState: getIt<AppState>(),
      homeCubit: homeCubit,
    );
  }

  final SliderController controller = SliderController(
    initialValue: 50,
    min: 0,
    max: 100,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Defer initialization to didChangeDependencies where context is available
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cubit == null) {
      _initCubit();
      _cubit!.initialize(widget.sound);
    }
  }

  @override
  void dispose() {
    _cubit?.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    logD('build ${widget.sound.id}');
    return BlocProvider<AudioButtonCubit>(
      create: (BuildContext context) => _cubit!,
      child: MouseRegion(
        onEnter: (_) => onHoverChanged(true),
        onExit: (_) => onHoverChanged(false),
        child: BlocBuilder<AudioButtonCubit, AudioButtonState>(
            builder: (BuildContext context, AudioButtonState state) {
          return Container(
            decoration: BoxDecoration(
              color: state.isActive
                  ? AppColors.categoryButtonSelected.withOpacity(0.5)
                  : (state.isHover
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
                  transform: state.isHover
                      ? (Matrix4.identity()..scale(1.05))
                      : Matrix4.identity(),
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        widget.sound.icon,
                        color: state.isActive ? Colors.white : Colors.white60,
                        size: 25,
                      ),
                      buildSlider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildSlider() {
    return BlocBuilder<AudioButtonCubit, AudioButtonState>(
      builder: (_, AudioButtonState state) {
        if (!state.isActive) return const SizedBox.shrink();

        return Column(
          children: <Widget>[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SliderBar(
                config: SliderConfig(
                  min: 0,
                  max: 100,
                  initialValue: 50,
                  direction: SliderDirection.horizontal,
                  trackConfig: TrackConfig(
                    activeColor: Colors.white.withOpacity(0.8),
                    inactiveColor: Colors.grey.shade300.withOpacity(0.6),
                    height: 6,
                    radius: 6,
                  ),
                  thumbConfig: const ThumbConfig(
                    color: Colors.white,
                    width: 12,
                    height: 12,
                    shape: BoxShape.circle,
                    radius: 18,
                    elevation: 2,
                    shadowColor: Colors.black26,
                  ),
                ),
                onChanged: (double value) {
                  if (_cubit != null) {
                    _cubit!.onChangeVolume(value);
                  }
                },
                onChangeStart: (double value) {
                  if (_cubit != null) {
                    _cubit!.onChangeVolume(value);
                  }
                },
                onChangeEnd: (double value) {
                  if (_cubit != null) {
                    _cubit!.onChangeVolume(value);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void onHoverChanged(bool value) {
    if (mounted && _cubit != null) {
      _cubit!.onHoverChange(value);
    }
  }

  void onTap() {
    if (_cubit != null) {
      _cubit!.toggleSound();
    }
  }
}
