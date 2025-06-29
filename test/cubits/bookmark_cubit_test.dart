import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ambientflow/cubits/bookmark/bookmark_cubit.dart';
import 'package:ambientflow/models/bookmark_collection.dart';
import 'package:ambientflow/models/sound_bookmark.dart';
import 'package:ambientflow/models/sound_bookmark_item.dart';
import 'package:ambientflow/services/audio/audio_coordinator_service.dart';
import 'package:ambientflow/services/bookmark/bookmark_storage_service_interface.dart';
import 'package:ambientflow/state/app_state.dart';

// Mock classes
class MockBookmarkStorageService extends Mock
    implements BookmarkStorageServiceInterface {}

class MockAudioCoordinatorService extends Mock
    implements AudioCoordinatorService {}

class MockAppState extends Mock implements AppState {}

// Fake classes for fallback values
class FakeSoundBookmark extends Fake implements SoundBookmark {}

class FakeBookmarkCollection extends Fake implements BookmarkCollection {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSoundBookmark());
    registerFallbackValue(FakeBookmarkCollection());
  });
  group('BookmarkCubit', () {
    late BookmarkCubit bookmarkCubit;
    late MockBookmarkStorageService mockBookmarkStorage;
    late MockAudioCoordinatorService mockAudioCoordinator;
    late MockAppState mockAppState;

    late SoundBookmark testBookmark;
    late BookmarkCollection testCollection;

    setUp(() {
      mockBookmarkStorage = MockBookmarkStorageService();
      mockAudioCoordinator = MockAudioCoordinatorService();
      mockAppState = MockAppState();

      testBookmark = SoundBookmark(
        id: 'test_bookmark',
        name: 'Test Bookmark',
        icon: '🎵',
        sounds: [
          const SoundBookmarkItem(soundId: 'rain', volume: 70.0),
          const SoundBookmarkItem(soundId: 'wind', volume: 50.0),
        ],
        globalVolume: 80.0,
        isMuted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      testCollection = BookmarkCollection(bookmarks: [testBookmark]);

      bookmarkCubit = BookmarkCubit(
        bookmarkStorage: mockBookmarkStorage,
        audioCoordinator: mockAudioCoordinator,
        appState: mockAppState,
      );

      // Set up default mock behaviors
      when(() => mockBookmarkStorage.loadBookmarks())
          .thenAnswer((_) async => testCollection);
      when(() => mockBookmarkStorage.saveBookmark(any()))
          .thenAnswer((_) async {});
      when(() => mockBookmarkStorage.markBookmarkAsLastUsed(any()))
          .thenAnswer((_) async {});
      when(() => mockAudioCoordinator.getCurrentSoundState()).thenReturn([
        const SoundBookmarkItem(soundId: 'rain', volume: 70.0),
      ]);
      when(() => mockAudioCoordinator.applyBookmark(any()))
          .thenAnswer((_) async {});
    });

    tearDown(() {
      bookmarkCubit.close();
    });

    test('initial state is correct', () {
      expect(bookmarkCubit.state, equals(BookmarkState.initial()));
    });

    group('loadBookmarks', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'emits [loading, loaded] when loadBookmarks succeeds',
        build: () => bookmarkCubit,
        act: (cubit) => cubit.loadBookmarks(),
        expect: () => [
          const BookmarkState(status: BookmarkStatus.loading),
          BookmarkState(
            status: BookmarkStatus.loaded,
            bookmarks: testCollection,
          ),
        ],
        verify: (_) {
          verify(() => mockBookmarkStorage.loadBookmarks()).called(1);
        },
      );

      blocTest<BookmarkCubit, BookmarkState>(
        'emits [loading, error] when loadBookmarks fails',
        build: () {
          when(() => mockBookmarkStorage.loadBookmarks())
              .thenThrow(Exception('Load failed'));
          return bookmarkCubit;
        },
        act: (cubit) => cubit.loadBookmarks(),
        expect: () => [
          const BookmarkState(status: BookmarkStatus.loading),
          const BookmarkState(
            status: BookmarkStatus.error,
            errorMessage: 'Failed to load bookmarks: Exception: Load failed',
          ),
        ],
      );
    });

    group('showSaveDialog', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'shows save dialog with default name',
        build: () => bookmarkCubit,
        act: (cubit) => cubit.showSaveDialog(),
        expect: () => [
          predicate<BookmarkState>((state) =>
              state.showSaveDialog == true && state.newBookmarkName.isNotEmpty),
        ],
      );
    });

    group('hideSaveDialog', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'hides save dialog and clears form',
        build: () => bookmarkCubit,
        seed: () => const BookmarkState(
          showSaveDialog: true,
          newBookmarkName: 'Test Name',
          newBookmarkIcon: '🌧️',
        ),
        act: (cubit) => cubit.hideSaveDialog(),
        expect: () => [
          const BookmarkState(
            showSaveDialog: false,
            newBookmarkName: '',
            newBookmarkIcon: '🎵',
          ),
        ],
      );
    });

    group('updateNewBookmarkName', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'updates bookmark name',
        build: () => bookmarkCubit,
        act: (cubit) => cubit.updateNewBookmarkName('New Name'),
        expect: () => [
          const BookmarkState(newBookmarkName: 'New Name'),
        ],
      );
    });

    group('saveCurrentCombination', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'emits error when bookmark name is invalid',
        build: () => bookmarkCubit,
        seed: () => const BookmarkState(newBookmarkName: ''),
        act: (cubit) => cubit.saveCurrentCombination(),
        expect: () => [
          const BookmarkState(
            status: BookmarkStatus.error,
            errorMessage: 'Please enter a valid bookmark name',
            newBookmarkName: '',
          ),
        ],
      );

      blocTest<BookmarkCubit, BookmarkState>(
        'emits error when no sounds are playing',
        build: () {
          when(() => mockAudioCoordinator.getCurrentSoundState())
              .thenReturn([]);
          return bookmarkCubit;
        },
        seed: () => const BookmarkState(newBookmarkName: 'Valid Name'),
        act: (cubit) => cubit.saveCurrentCombination(),
        expect: () => [
          const BookmarkState(
            status: BookmarkStatus.saving,
            newBookmarkName: 'Valid Name',
          ),
          const BookmarkState(
            status: BookmarkStatus.error,
            errorMessage: 'No sounds are currently playing to bookmark',
            newBookmarkName: 'Valid Name',
          ),
        ],
      );

      blocTest<BookmarkCubit, BookmarkState>(
        'saves bookmark successfully',
        build: () => bookmarkCubit,
        seed: () => const BookmarkState(newBookmarkName: 'Valid Name'),
        act: (cubit) => cubit.saveCurrentCombination(),
        expect: () => [
          const BookmarkState(
            status: BookmarkStatus.saving,
            newBookmarkName: 'Valid Name',
          ),
          BookmarkState(
            status: BookmarkStatus.saved,
            bookmarks: testCollection,
            showSaveDialog: false,
            newBookmarkName: '',
            newBookmarkIcon: '🎵',
            lastOperation: 'Bookmark "Valid Name" saved successfully',
          ),
        ],
        verify: (_) {
          verify(() => mockAudioCoordinator.getCurrentSoundState()).called(1);
          verify(() => mockBookmarkStorage.saveBookmark(any())).called(1);
          verify(() => mockBookmarkStorage.markBookmarkAsLastUsed(any()))
              .called(1);
          verify(() => mockBookmarkStorage.loadBookmarks()).called(1);
        },
      );
    });

    group('applyBookmark', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'applies bookmark successfully',
        build: () => bookmarkCubit,
        act: (cubit) => cubit.applyBookmark(testBookmark),
        expect: () => [
          BookmarkState(
            status: BookmarkStatus.applying,
            selectedBookmark: testBookmark,
          ),
          BookmarkState(
            status: BookmarkStatus.applied,
            bookmarks: testCollection,
            selectedBookmark: testBookmark,
            lastOperation: 'Bookmark "Test Bookmark" applied successfully',
          ),
        ],
        verify: (_) {
          verify(() => mockAudioCoordinator.applyBookmark(testBookmark))
              .called(1);
          verify(() =>
                  mockBookmarkStorage.markBookmarkAsLastUsed(testBookmark.id))
              .called(1);
          verify(() => mockBookmarkStorage.loadBookmarks()).called(1);
        },
      );

      blocTest<BookmarkCubit, BookmarkState>(
        'emits error when apply fails',
        build: () {
          when(() => mockAudioCoordinator.applyBookmark(any()))
              .thenThrow(Exception('Apply failed'));
          return bookmarkCubit;
        },
        act: (cubit) => cubit.applyBookmark(testBookmark),
        expect: () => [
          BookmarkState(
            status: BookmarkStatus.applying,
            selectedBookmark: testBookmark,
          ),
          BookmarkState(
            status: BookmarkStatus.error,
            selectedBookmark: testBookmark,
            errorMessage: 'Failed to apply bookmark: Exception: Apply failed',
          ),
        ],
      );
    });

    group('deleteBookmark', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'deletes bookmark successfully',
        build: () => bookmarkCubit,
        act: (cubit) => cubit.deleteBookmark(testBookmark),
        expect: () => [
          BookmarkState(
            status: BookmarkStatus.deleting,
            selectedBookmark: testBookmark,
          ),
          BookmarkState(
            status: BookmarkStatus.deleted,
            bookmarks: testCollection,
            lastOperation: 'Bookmark "Test Bookmark" deleted successfully',
          ),
        ],
        verify: (_) {
          verify(() => mockBookmarkStorage.deleteBookmark(testBookmark.id))
              .called(1);
          verify(() => mockBookmarkStorage.loadBookmarks()).called(1);
        },
      );
    });

    group('toggleBookmarkList', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'toggles bookmark list visibility',
        build: () => bookmarkCubit,
        act: (cubit) => cubit.toggleBookmarkList(),
        expect: () => [
          const BookmarkState(showBookmarkList: true),
        ],
      );

      blocTest<BookmarkCubit, BookmarkState>(
        'toggles bookmark list visibility when already visible',
        build: () => bookmarkCubit,
        seed: () => const BookmarkState(showBookmarkList: true),
        act: (cubit) => cubit.toggleBookmarkList(),
        expect: () => [
          const BookmarkState(showBookmarkList: false),
        ],
      );
    });

    group('toggleAutoRestore', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'toggles auto restore setting',
        build: () => bookmarkCubit,
        act: (cubit) => cubit.toggleAutoRestore(),
        expect: () => [
          const BookmarkState(autoRestoreEnabled: false),
        ],
      );
    });

    group('clearError', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'clears error message',
        build: () => bookmarkCubit,
        seed: () => const BookmarkState(
          status: BookmarkStatus.error,
          errorMessage: 'Test error',
        ),
        act: (cubit) => cubit.clearError(),
        expect: () => [
          const BookmarkState(
            status: BookmarkStatus.error,
            errorMessage: null,
          ),
        ],
      );
    });

    group('clearLastOperation', () {
      blocTest<BookmarkCubit, BookmarkState>(
        'clears last operation message',
        build: () => bookmarkCubit,
        seed: () => const BookmarkState(lastOperation: 'Test operation'),
        act: (cubit) => cubit.clearLastOperation(),
        expect: () => [
          const BookmarkState(lastOperation: null),
        ],
      );
    });
  });
}
