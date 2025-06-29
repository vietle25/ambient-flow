import '../../models/bookmark_collection.dart';
import '../../models/sound_bookmark.dart';

/// Interface for bookmark storage services.
/// 
/// This service handles the persistence of bookmarks for both
/// logged-in users (cloud storage) and non-logged-in users (local storage).
abstract class BookmarkStorageServiceInterface {
  /// Loads all bookmarks for the current user.
  /// 
  /// For logged-in users, this loads from cloud storage.
  /// For non-logged-in users, this loads from local storage.
  Future<BookmarkCollection> loadBookmarks();

  /// Saves all bookmarks for the current user.
  /// 
  /// For logged-in users, this saves to cloud storage.
  /// For non-logged-in users, this saves to local storage.
  Future<void> saveBookmarks(BookmarkCollection collection);

  /// Saves a single bookmark.
  /// 
  /// This is a convenience method that loads existing bookmarks,
  /// adds/updates the provided bookmark, and saves the collection.
  Future<void> saveBookmark(SoundBookmark bookmark);

  /// Deletes a bookmark by ID.
  /// 
  /// This loads existing bookmarks, removes the specified bookmark,
  /// and saves the updated collection.
  Future<void> deleteBookmark(String bookmarkId);

  /// Gets the last used bookmark for auto-restore functionality.
  /// 
  /// Returns null if no bookmark is marked as last used.
  Future<SoundBookmark?> getLastUsedBookmark();

  /// Marks a bookmark as the last used one.
  /// 
  /// This unmarks all other bookmarks and marks the specified one as last used.
  Future<void> markBookmarkAsLastUsed(String bookmarkId);

  /// Clears all bookmarks for the current user.
  /// 
  /// This is useful for sign-out scenarios or data reset.
  Future<void> clearAllBookmarks();

  /// Checks if bookmark storage is available.
  /// 
  /// This can be used to determine if the storage service is properly initialized.
  Future<bool> isStorageAvailable();

  /// Gets the maximum number of bookmarks allowed for the current user.
  /// 
  /// This might differ between logged-in and non-logged-in users.
  int getMaxBookmarkLimit();

  /// Migrates bookmarks from local storage to cloud storage.
  /// 
  /// This is called when a user signs in and we want to merge
  /// their local bookmarks with their cloud bookmarks.
  Future<void> migrateLocalBookmarksToCloud();

  /// Exports bookmarks as a JSON string.
  /// 
  /// This can be used for backup or sharing purposes.
  Future<String> exportBookmarks();

  /// Imports bookmarks from a JSON string.
  /// 
  /// This can be used for restore or sharing purposes.
  /// Returns the number of bookmarks successfully imported.
  Future<int> importBookmarks(String jsonData);
}
