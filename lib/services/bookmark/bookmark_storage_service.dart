import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/bookmark_collection.dart';
import '../../models/sound_bookmark.dart';
import '../../models/user_model.dart';
import '../auth/auth_service_interface.dart';
import '../storage/storage_service_interface.dart';
import 'bookmark_storage_service_interface.dart';

/// Implementation of [BookmarkStorageServiceInterface].
/// 
/// This service handles bookmark persistence using different storage mechanisms
/// based on user authentication status:
/// - Logged-in users: Secure storage (cloud-synced)
/// - Non-logged-in users: SharedPreferences (local only)
class BookmarkStorageService implements BookmarkStorageServiceInterface {
  final StorageServiceInterface _secureStorage;
  final AuthServiceInterface _authService;
  
  // Storage keys
  static const String _localBookmarksKey = 'ambient_flow_local_bookmarks';
  static const String _cloudBookmarksKey = 'ambient_flow_cloud_bookmarks';
  
  // Limits
  static const int _maxBookmarksLoggedIn = 50;
  static const int _maxBookmarksLocal = 10;

  /// Creates a new [BookmarkStorageService] instance.
  BookmarkStorageService({
    required StorageServiceInterface secureStorage,
    required AuthServiceInterface authService,
  })  : _secureStorage = secureStorage,
        _authService = authService;

  @override
  Future<BookmarkCollection> loadBookmarks() async {
    try {
      final bool isLoggedIn = await _authService.isSignedIn();
      
      if (isLoggedIn) {
        return await _loadCloudBookmarks();
      } else {
        return await _loadLocalBookmarks();
      }
    } catch (e) {
      // If loading fails, return empty collection
      return const BookmarkCollection();
    }
  }

  @override
  Future<void> saveBookmarks(BookmarkCollection collection) async {
    try {
      final bool isLoggedIn = await _authService.isSignedIn();
      
      if (isLoggedIn) {
        await _saveCloudBookmarks(collection);
      } else {
        await _saveLocalBookmarks(collection);
      }
    } catch (e) {
      // Log error but don't throw to prevent app crashes
      print('Error saving bookmarks: $e');
    }
  }

  @override
  Future<void> saveBookmark(SoundBookmark bookmark) async {
    final BookmarkCollection collection = await loadBookmarks();
    final BookmarkCollection updatedCollection = collection.addBookmark(bookmark);
    await saveBookmarks(updatedCollection);
  }

  @override
  Future<void> deleteBookmark(String bookmarkId) async {
    final BookmarkCollection collection = await loadBookmarks();
    final BookmarkCollection updatedCollection = collection.removeBookmark(bookmarkId);
    await saveBookmarks(updatedCollection);
  }

  @override
  Future<SoundBookmark?> getLastUsedBookmark() async {
    final BookmarkCollection collection = await loadBookmarks();
    return collection.getLastUsedBookmark();
  }

  @override
  Future<void> markBookmarkAsLastUsed(String bookmarkId) async {
    final BookmarkCollection collection = await loadBookmarks();
    final BookmarkCollection updatedCollection = collection.markBookmarkAsLastUsed(bookmarkId);
    await saveBookmarks(updatedCollection);
  }

  @override
  Future<void> clearAllBookmarks() async {
    const BookmarkCollection emptyCollection = BookmarkCollection();
    await saveBookmarks(emptyCollection);
  }

  @override
  Future<bool> isStorageAvailable() async {
    try {
      final bool isLoggedIn = await _authService.isSignedIn();
      
      if (isLoggedIn) {
        // Test secure storage
        await _secureStorage.saveSecure('test_key', 'test_value');
        await _secureStorage.removeSecure('test_key');
        return true;
      } else {
        // Test SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('test_key', 'test_value');
        await prefs.remove('test_key');
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  int getMaxBookmarkLimit() {
    // This is synchronous, so we can't check auth status
    // We'll return the higher limit and enforce it during save operations
    return _maxBookmarksLoggedIn;
  }

  @override
  Future<void> migrateLocalBookmarksToCloud() async {
    try {
      final bool isLoggedIn = await _authService.isSignedIn();
      if (!isLoggedIn) return;

      // Load local bookmarks
      final BookmarkCollection localCollection = await _loadLocalBookmarks();
      if (localCollection.isEmpty) return;

      // Load existing cloud bookmarks
      final BookmarkCollection cloudCollection = await _loadCloudBookmarks();

      // Merge collections (local bookmarks take precedence for duplicates)
      List<SoundBookmark> mergedBookmarks = List.from(cloudCollection.bookmarks);
      
      for (final SoundBookmark localBookmark in localCollection.bookmarks) {
        // Remove any existing bookmark with the same ID
        mergedBookmarks.removeWhere((b) => b.id == localBookmark.id);
        // Add the local bookmark
        mergedBookmarks.add(localBookmark);
      }

      // Sort by updated date (newest first) and limit to max capacity
      mergedBookmarks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      if (mergedBookmarks.length > _maxBookmarksLoggedIn) {
        mergedBookmarks = mergedBookmarks.take(_maxBookmarksLoggedIn).toList();
      }

      // Save merged collection to cloud
      final BookmarkCollection mergedCollection = BookmarkCollection(bookmarks: mergedBookmarks);
      await _saveCloudBookmarks(mergedCollection);

      // Clear local bookmarks after successful migration
      await _clearLocalBookmarks();
    } catch (e) {
      print('Error migrating local bookmarks to cloud: $e');
    }
  }

  @override
  Future<String> exportBookmarks() async {
    final BookmarkCollection collection = await loadBookmarks();
    return jsonEncode(collection.toJson());
  }

  @override
  Future<int> importBookmarks(String jsonData) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonData) as Map<String, dynamic>;
      final BookmarkCollection importedCollection = BookmarkCollection.fromJson(data);
      
      if (importedCollection.isEmpty) return 0;

      // Load existing bookmarks
      final BookmarkCollection existingCollection = await loadBookmarks();
      
      // Merge collections
      List<SoundBookmark> mergedBookmarks = List.from(existingCollection.bookmarks);
      int importedCount = 0;
      
      for (final SoundBookmark importedBookmark in importedCollection.bookmarks) {
        // Remove any existing bookmark with the same ID
        mergedBookmarks.removeWhere((b) => b.id == importedBookmark.id);
        // Add the imported bookmark
        mergedBookmarks.add(importedBookmark);
        importedCount++;
      }

      // Apply limits
      final int maxLimit = await _getEffectiveMaxLimit();
      if (mergedBookmarks.length > maxLimit) {
        // Sort by updated date and keep the most recent ones
        mergedBookmarks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        mergedBookmarks = mergedBookmarks.take(maxLimit).toList();
      }

      // Save merged collection
      final BookmarkCollection mergedCollection = BookmarkCollection(bookmarks: mergedBookmarks);
      await saveBookmarks(mergedCollection);

      return importedCount;
    } catch (e) {
      print('Error importing bookmarks: $e');
      return 0;
    }
  }

  // Private helper methods

  Future<BookmarkCollection> _loadLocalBookmarks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString(_localBookmarksKey);
      
      if (jsonData == null) return const BookmarkCollection();
      
      final Map<String, dynamic> data = jsonDecode(jsonData) as Map<String, dynamic>;
      return BookmarkCollection.fromJson(data);
    } catch (e) {
      return const BookmarkCollection();
    }
  }

  Future<BookmarkCollection> _loadCloudBookmarks() async {
    try {
      final String? jsonData = await _secureStorage.getSecure(_cloudBookmarksKey);
      
      if (jsonData == null) return const BookmarkCollection();
      
      final Map<String, dynamic> data = jsonDecode(jsonData) as Map<String, dynamic>;
      return BookmarkCollection.fromJson(data);
    } catch (e) {
      return const BookmarkCollection();
    }
  }

  Future<void> _saveLocalBookmarks(BookmarkCollection collection) async {
    // Apply local storage limits
    BookmarkCollection limitedCollection = collection;
    if (collection.length > _maxBookmarksLocal) {
      final List<SoundBookmark> limitedBookmarks = collection.sortedByUpdated
          .take(_maxBookmarksLocal)
          .toList();
      limitedCollection = BookmarkCollection(bookmarks: limitedBookmarks);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonData = jsonEncode(limitedCollection.toJson());
    await prefs.setString(_localBookmarksKey, jsonData);
  }

  Future<void> _saveCloudBookmarks(BookmarkCollection collection) async {
    // Apply cloud storage limits
    BookmarkCollection limitedCollection = collection;
    if (collection.length > _maxBookmarksLoggedIn) {
      final List<SoundBookmark> limitedBookmarks = collection.sortedByUpdated
          .take(_maxBookmarksLoggedIn)
          .toList();
      limitedCollection = BookmarkCollection(bookmarks: limitedBookmarks);
    }

    final String jsonData = jsonEncode(limitedCollection.toJson());
    await _secureStorage.saveSecure(_cloudBookmarksKey, jsonData);
  }

  Future<void> _clearLocalBookmarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localBookmarksKey);
  }

  Future<int> _getEffectiveMaxLimit() async {
    final bool isLoggedIn = await _authService.isSignedIn();
    return isLoggedIn ? _maxBookmarksLoggedIn : _maxBookmarksLocal;
  }
}
