import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_button_state.dart';

class AudioButtonCubit extends Cubit<AudioButtonState> {
  AudioButtonCubit() : super(const AudioButtonState());

  void onChangeVolume(double volume) {
    emit(state.copyWith(volume: volume));
  }
}
