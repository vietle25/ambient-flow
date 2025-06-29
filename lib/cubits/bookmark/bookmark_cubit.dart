import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/bookmark_collection.dart';
import '../../models/sound_bookmark.dart';
import '../../models/sound_bookmark_item.dart';
import '../../services/audio/audio_coordinator_service.dart';
import '../../services/bookmark/bookmark_storage_service_interface.dart';
import '../../state/app_state.dart';

part 'bookmark_state.dart';

/// Cubit for managing bookmark state and operations.
class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkStorageServiceInterface _bookmarkStorage;
  final AudioCoordinatorService _audioCoordinator;
  final AppState _appState;

  /// Creates a new [BookmarkCubit] instance.
  BookmarkCubit({
    required BookmarkStorageServiceInterface bookmarkStorage,
    required AudioCoordinatorService audioCoordinator,
    required AppState appState,
  })  : _bookmarkStorage = bookmarkStorage,
        _audioCoordinator = audioCoordinator,
        _appState = appState,
        super(BookmarkState.initial());

  /// Initializes the bookmark cubit by loading existing bookmarks.
  Future<void> initialize() async {
    await loadBookmarks();

    // Auto-restore last used bookmark if enabled
    if (state.autoRestoreEnabled) {
      await _autoRestoreLastBookmark();
    }
  }

  /// Loads all bookmarks from storage.
  Future<void> loadBookmarks() async {
    emit(state.copyWith(
        status: BookmarkStatus.loading, clearErrorMessage: true));

    try {
      final BookmarkCollection bookmarks =
          await _bookmarkStorage.loadBookmarks();
      emit(state.copyWith(
        status: BookmarkStatus.loaded,
        bookmarks: bookmarks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to load bookmarks: $e',
      ));
    }
  }

  /// Migrates local bookmarks to cloud storage when user logs in.
  Future<void> migrateLocalBookmarksToCloud() async {
    try {
      emit(state.copyWith(
        status: BookmarkStatus.loading,
        clearErrorMessage: true,
      ));

      await _bookmarkStorage.migrateLocalBookmarksToCloud();

      // Reload bookmarks after migration
      await loadBookmarks();

      emit(state.copyWith(
        status: BookmarkStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to migrate bookmarks: $e',
      ));
    }
  }

  /// Shows the save bookmark dialog.
  void showSaveDialog() {
    final String fancyName = _generateFancyBookmarkName();

    emit(state.copyWith(
      showSaveDialog: true,
      newBookmarkName: fancyName,
      newBookmarkIcon: '🎵',
    ));
  }

  /// Hides the save bookmark dialog.
  void hideSaveDialog() {
    emit(state.copyWith(
      showSaveDialog: false,
      newBookmarkName: '',
      newBookmarkIcon: '🎵',
    ));
  }

  /// Updates the new bookmark name.
  void updateNewBookmarkName(String name) {
    emit(state.copyWith(newBookmarkName: name));
  }

  /// Updates the new bookmark icon.
  void updateNewBookmarkIcon(String icon) {
    emit(state.copyWith(newBookmarkIcon: icon));
  }

  /// Saves the current sound combination as a bookmark.
  Future<void> saveCurrentCombination() async {
    if (!state.isNewBookmarkNameValid) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Please enter a valid bookmark name',
      ));
      return;
    }

    // Check for duplicate bookmark names
    final String trimmedName = state.newBookmarkName.trim();
    final bool nameExists = state.bookmarks.bookmarks.any(
      (bookmark) =>
          bookmark.name.trim().toLowerCase() == trimmedName.toLowerCase(),
    );

    if (nameExists) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage:
            'A bookmark with this name already exists. Please choose a different name.',
      ));
      return;
    }

    emit(
        state.copyWith(status: BookmarkStatus.saving, clearErrorMessage: true));

    try {
      // Get current active sounds and their volumes
      final List<SoundBookmarkItem> soundItems = _getCurrentSoundItems();

      if (soundItems.isEmpty) {
        emit(state.copyWith(
          status: BookmarkStatus.error,
          errorMessage: 'No sounds are currently playing to bookmark',
        ));
        return;
      }

      // Create the bookmark
      final SoundBookmark bookmark = SoundBookmark(
        id: _generateBookmarkId(),
        name: state.newBookmarkName.trim(),
        icon: state.newBookmarkIcon,
        sounds: soundItems,
        globalVolume: _appState.appVolume,
        isMuted: false, // We'll determine this from the home state
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save the bookmark
      await _bookmarkStorage.saveBookmark(bookmark);

      // Mark as last used
      await _bookmarkStorage.markBookmarkAsLastUsed(bookmark.id);

      // Reload bookmarks to get updated collection
      await loadBookmarks();

      emit(state.copyWith(
        status: BookmarkStatus.saved,
        showSaveDialog: false,
        newBookmarkName: '',
        newBookmarkIcon: '🎵',
        lastOperation: 'Bookmark "${bookmark.name}" saved successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to save bookmark: $e',
      ));
    }
  }

  /// Applies a bookmark (restores the sound combination).
  Future<void> applyBookmark(SoundBookmark bookmark) async {
    emit(state.copyWith(
      status: BookmarkStatus.applying,
      selectedBookmark: bookmark,
      clearErrorMessage: true,
    ));

    try {
      // Apply the bookmark using the audio coordinator
      await _audioCoordinator.applyBookmark(bookmark);

      await _bookmarkStorage.markBookmarkAsLastUsed(bookmark.id);
      await loadBookmarks();

      emit(state.copyWith(
        status: BookmarkStatus.applied,
        lastOperation: 'Bookmark "${bookmark.name}" applied successfully',
      ));

      // Emit a special state to trigger UI refresh
      emit(state.copyWith(
        status: BookmarkStatus.uiRefreshNeeded,
      ));

      // Reset status after a brief delay
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(
        status: BookmarkStatus.applied,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to apply bookmark: $e',
      ));
    }
  }

  /// Deletes a bookmark.
  Future<void> deleteBookmark(SoundBookmark bookmark) async {
    emit(state.copyWith(
      status: BookmarkStatus.deleting,
      selectedBookmark: bookmark,
      clearErrorMessage: true,
    ));

    try {
      await _bookmarkStorage.deleteBookmark(bookmark.id);
      await loadBookmarks();

      emit(state.copyWith(
        status: BookmarkStatus.deleted,
        clearSelectedBookmark: true,
        lastOperation: 'Bookmark "${bookmark.name}" deleted successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to delete bookmark: $e',
      ));
    }
  }

  /// Toggles the bookmark list visibility.
  void toggleBookmarkList() {
    emit(state.copyWith(showBookmarkList: !state.showBookmarkList));
  }

  /// Shows the bookmark list.
  void showBookmarkList() {
    emit(state.copyWith(showBookmarkList: true));
  }

  /// Hides the bookmark list.
  void hideBookmarkList() {
    emit(state.copyWith(showBookmarkList: false));
  }

  /// Toggles auto-restore functionality.
  void toggleAutoRestore() {
    emit(state.copyWith(autoRestoreEnabled: !state.autoRestoreEnabled));
  }

  /// Clears the last operation message.
  void clearLastOperation() {
    emit(state.copyWith(clearLastOperation: true));
  }

  /// Notifies that the app state has changed (sounds toggled).
  /// This triggers a rebuild of the bookmark list to update selected states.
  void notifyAppStateChanged() {
    // Emit a brief state change to trigger UI updates
    emit(state.copyWith(status: BookmarkStatus.uiRefreshNeeded));

    // Reset status after a brief delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!isClosed) {
        emit(state.copyWith(status: BookmarkStatus.loaded));
      }
    });
  }

  /// Clears any error message.
  void clearError() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  /// Clears all bookmarks.
  Future<void> clearAllBookmarks() async {
    emit(state.copyWith(
        status: BookmarkStatus.deleting, clearErrorMessage: true));

    try {
      await _bookmarkStorage.clearAllBookmarks();
      await loadBookmarks();

      emit(state.copyWith(
        status: BookmarkStatus.deleted,
        lastOperation: 'All bookmarks cleared successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to clear bookmarks: $e',
      ));
    }
  }

  /// Exports bookmarks as JSON.
  Future<String> exportBookmarks() async {
    try {
      return await _bookmarkStorage.exportBookmarks();
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to export bookmarks: $e',
      ));
      rethrow;
    }
  }

  /// Imports bookmarks from JSON.
  Future<void> importBookmarks(String jsonData) async {
    emit(state.copyWith(
        status: BookmarkStatus.loading, clearErrorMessage: true));

    try {
      final int importedCount =
          await _bookmarkStorage.importBookmarks(jsonData);
      await loadBookmarks();

      emit(state.copyWith(
        status: BookmarkStatus.loaded,
        lastOperation: 'Successfully imported $importedCount bookmark(s)',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: 'Failed to import bookmarks: $e',
      ));
    }
  }

  // Private helper methods

  Future<void> _autoRestoreLastBookmark() async {
    try {
      final SoundBookmark? lastBookmark =
          await _bookmarkStorage.getLastUsedBookmark();
      if (lastBookmark != null) {
        // Auto-apply the last bookmark
        await applyBookmark(lastBookmark);
      }
    } catch (e) {
      // Silently fail auto-restore to not disrupt app startup
      // Log error but don't throw to prevent app startup issues
    }
  }

  List<SoundBookmarkItem> _getCurrentSoundItems() {
    // Use the audio coordinator to get the current sound state
    return _audioCoordinator.getCurrentSoundState();
  }

  String _generateBookmarkId() {
    return 'bookmark_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Generates a fancy random name for bookmarks.
  String _generateFancyBookmarkName() {
    final Random random = Random();

    // Lists of fancy adjectives and nouns for ambient/relaxing themes
    final List<String> adjectives = [
      'Serene',
      'Tranquil',
      'Peaceful',
      'Mystic',
      'Ethereal',
      'Dreamy',
      'Gentle',
      'Soothing',
      'Calming',
      'Blissful',
      'Harmonious',
      'Zen',
      'Celestial',
      'Whispering',
      'Floating',
      'Drifting',
      'Flowing',
      'Soft',
      'Golden',
      'Silver',
      'Moonlit',
      'Starlit',
      'Twilight',
      'Dawn',
      'Velvet',
      'Silk',
      'Crystal',
      'Pearl',
      'Amber',
      'Jade'
    ];

    final List<String> nouns = [
      'Sanctuary',
      'Haven',
      'Oasis',
      'Garden',
      'Meadow',
      'Valley',
      'Stream',
      'Breeze',
      'Waves',
      'Clouds',
      'Mist',
      'Glow',
      'Harmony',
      'Symphony',
      'Melody',
      'Rhythm',
      'Echo',
      'Whisper',
      'Dreams',
      'Thoughts',
      'Moments',
      'Journey',
      'Path',
      'Escape',
      'Refuge',
      'Retreat',
      'Solace',
      'Peace',
      'Calm',
      'Serenity'
    ];

    final String adjective = adjectives[random.nextInt(adjectives.length)];
    final String noun = nouns[random.nextInt(nouns.length)];

    return '$adjective $noun';
  }
}
