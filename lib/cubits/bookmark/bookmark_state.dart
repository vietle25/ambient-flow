part of 'bookmark_cubit.dart';

/// Enumeration of bookmark operation statuses.
enum BookmarkStatus {
  /// Initial state, no operations performed yet.
  initial,

  /// Loading bookmarks from storage.
  loading,

  /// Bookmarks loaded successfully.
  loaded,

  /// Saving a bookmark.
  saving,

  /// Bookmark saved successfully.
  saved,

  /// Applying a bookmark (restoring sound combination).
  applying,

  /// Bookmark applied successfully.
  applied,

  /// UI refresh needed after bookmark application.
  uiRefreshNeeded,

  /// Deleting a bookmark.
  deleting,

  /// Bookmark deleted successfully.
  deleted,

  /// An error occurred during an operation.
  error,
}

/// State class for bookmark management.
class BookmarkState extends Equatable {
  /// The current status of bookmark operations.
  final BookmarkStatus status;

  /// The collection of bookmarks.
  final BookmarkCollection bookmarks;

  /// The currently selected bookmark for operations.
  final SoundBookmark? selectedBookmark;

  /// Error message if an operation failed.
  final String? errorMessage;

  /// Whether the save bookmark dialog is visible.
  final bool showSaveDialog;

  /// Whether the bookmark list is visible.
  final bool showBookmarkList;

  /// The name being entered for a new bookmark.
  final String newBookmarkName;

  /// The icon being selected for a new bookmark.
  final String newBookmarkIcon;

  /// Whether auto-restore is enabled.
  final bool autoRestoreEnabled;

  /// The last operation performed (for UI feedback).
  final String? lastOperation;

  /// Creates a new [BookmarkState] instance.
  const BookmarkState({
    this.status = BookmarkStatus.initial,
    this.bookmarks = const BookmarkCollection(),
    this.selectedBookmark,
    this.errorMessage,
    this.showSaveDialog = false,
    this.showBookmarkList = false,
    this.newBookmarkName = '',
    this.newBookmarkIcon = '🎵',
    this.autoRestoreEnabled = true,
    this.lastOperation,
  });

  /// Creates the initial state.
  factory BookmarkState.initial() {
    return const BookmarkState();
  }

  /// Creates a copy of this [BookmarkState] with the given fields replaced with new values.
  BookmarkState copyWith({
    BookmarkStatus? status,
    BookmarkCollection? bookmarks,
    SoundBookmark? selectedBookmark,
    String? errorMessage,
    bool? showSaveDialog,
    bool? showBookmarkList,
    String? newBookmarkName,
    String? newBookmarkIcon,
    bool? autoRestoreEnabled,
    String? lastOperation,
    bool clearSelectedBookmark = false,
    bool clearErrorMessage = false,
    bool clearLastOperation = false,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      selectedBookmark: clearSelectedBookmark
          ? null
          : (selectedBookmark ?? this.selectedBookmark),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      showSaveDialog: showSaveDialog ?? this.showSaveDialog,
      showBookmarkList: showBookmarkList ?? this.showBookmarkList,
      newBookmarkName: newBookmarkName ?? this.newBookmarkName,
      newBookmarkIcon: newBookmarkIcon ?? this.newBookmarkIcon,
      autoRestoreEnabled: autoRestoreEnabled ?? this.autoRestoreEnabled,
      lastOperation:
          clearLastOperation ? null : (lastOperation ?? this.lastOperation),
    );
  }

  /// Checks if the current status indicates a loading operation.
  bool get isLoading =>
      status == BookmarkStatus.loading ||
      status == BookmarkStatus.saving ||
      status == BookmarkStatus.applying ||
      status == BookmarkStatus.deleting;

  /// Checks if there's an error.
  bool get hasError => status == BookmarkStatus.error && errorMessage != null;

  /// Checks if bookmarks are loaded and available.
  bool get hasBookmarks => bookmarks.isNotEmpty;

  /// Checks if a bookmark is currently selected.
  bool get hasSelectedBookmark => selectedBookmark != null;

  /// Checks if the new bookmark name is valid.
  bool get isNewBookmarkNameValid => newBookmarkName.trim().isNotEmpty;

  /// Gets the number of bookmarks.
  int get bookmarkCount => bookmarks.length;

  /// Checks if the bookmark limit is reached.
  bool get isAtBookmarkLimit => bookmarks.isAtMaxCapacity;

  @override
  List<Object?> get props => [
        status,
        bookmarks,
        selectedBookmark,
        errorMessage,
        showSaveDialog,
        showBookmarkList,
        newBookmarkName,
        newBookmarkIcon,
        autoRestoreEnabled,
        lastOperation,
      ];

  @override
  String toString() =>
      'BookmarkState(status: $status, bookmarkCount: $bookmarkCount)';
}
