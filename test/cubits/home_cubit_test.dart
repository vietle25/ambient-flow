import 'package:ambientflow/screens/home/cubit/home_cubit.dart';
import 'package:ambientflow/screens/home/cubit/home_state.dart';
import 'package:ambientflow/services/audio/audio_coordinator_service.dart';
import 'package:ambientflow/state/app_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_cubit_test.mocks.dart';

@GenerateMocks([AudioCoordinatorService])
void main() {
  late MockAudioCoordinatorService mockAudioCoordinator;
  late AppState appState;
  late HomeCubit homeCubit;

  setUp(() {
    mockAudioCoordinator = MockAudioCoordinatorService();
    appState = AppState();
    homeCubit = HomeCubit(
      appState: appState,
      audioCoordinator: mockAudioCoordinator,
    );
  });

  tearDown(() {
    homeCubit.close();
  });

  group('HomeCubit Volume Control Tests', () {
    test('initial state has default volume of 50', () {
      expect(homeCubit.state.volume, 50);
      expect(homeCubit.state.isMuted, false);
    });

    blocTest<HomeCubit, HomeState>(
      'setAppVolume updates state and calls audio coordinator',
      build: () => homeCubit,
      setUp: () {
        when(mockAudioCoordinator.setGlobalVolume(75)).thenAnswer((_) async {});
      },
      act: (HomeCubit cubit) => cubit.setAppVolume(75),
      expect: () => [
        const HomeState(volume: 75),
      ],
      verify: (_) {
        verify(mockAudioCoordinator.setGlobalVolume(75)).called(1);
        expect(appState.appVolume, 75);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'toggleMute mutes and stores previous volume',
      build: () => homeCubit,
      setUp: () {
        when(mockAudioCoordinator.setMuted(true)).thenAnswer((_) async {});
        // Set initial volume to 60
        homeCubit.emit(const HomeState(volume: 60));
        appState.appVolume = 60;
      },
      act: (HomeCubit cubit) => cubit.toggleMute(),
      expect: () => [
        const HomeState(volume: 0, isMuted: true),
      ],
      verify: (_) {
        verify(mockAudioCoordinator.setMuted(true)).called(1);
        expect(appState.appVolume, 0);
        expect(appState.previousVolume, 60);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'toggleMute unmutes and restores previous volume',
      build: () => homeCubit,
      setUp: () {
        when(mockAudioCoordinator.setMuted(false)).thenAnswer((_) async {});
        // Set initial state as muted with previous volume stored
        homeCubit.emit(const HomeState(volume: 0, isMuted: true));
        appState.appVolume = 0;
        appState.previousVolume = 80;
      },
      act: (HomeCubit cubit) => cubit.toggleMute(),
      expect: () => [
        const HomeState(volume: 80, isMuted: false),
      ],
      verify: (_) {
        verify(mockAudioCoordinator.setMuted(false)).called(1);
        expect(appState.appVolume, 80);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'toggleMute restores default volume when no previous volume stored',
      build: () => homeCubit,
      setUp: () {
        when(mockAudioCoordinator.setMuted(false)).thenAnswer((_) async {});
        // Set initial state as muted with no previous volume
        homeCubit.emit(const HomeState(volume: 0, isMuted: true));
        appState.appVolume = 0;
        appState.previousVolume = 0; // No previous volume stored
      },
      act: (HomeCubit cubit) => cubit.toggleMute(),
      expect: () => [
        const HomeState(volume: 50, isMuted: false),
      ],
      verify: (_) {
        verify(mockAudioCoordinator.setMuted(false)).called(1);
        expect(appState.appVolume, 50);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'setAppVolume with zero volume does not affect mute state',
      build: () => homeCubit,
      setUp: () {
        when(mockAudioCoordinator.setGlobalVolume(0)).thenAnswer((_) async {});
      },
      act: (HomeCubit cubit) => cubit.setAppVolume(0),
      expect: () => [
        const HomeState(volume: 0),
      ],
      verify: (_) {
        verify(mockAudioCoordinator.setGlobalVolume(0)).called(1);
        expect(appState.appVolume, 0);
        // Should not be marked as muted when manually setting volume to 0
        expect(homeCubit.state.isMuted, false);
      },
    );
  });
}
