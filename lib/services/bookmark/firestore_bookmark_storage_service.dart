import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/bookmark_collection.dart';
import '../../models/sound_bookmark.dart';
import '../auth/auth_service_interface.dart';
import 'bookmark_storage_service_interface.dart';

/// Implementation of [BookmarkStorageServiceInterface] using Firestore for cloud storage.
///
/// This service handles bookmark persistence using different storage mechanisms
/// based on user authentication status:
/// - Logged-in users: Firestore (cloud-synced across devices)
/// - Non-logged-in users: SharedPreferences (local only)
class FirestoreBookmarkStorageService
    implements BookmarkStorageServiceInterface {
  final FirebaseFirestore _firestore;
  final AuthServiceInterface _authService;

  // Storage keys
  static const String _localBookmarksKey = 'ambient_flow_local_bookmarks';
  static const String _bookmarksCollection = 'user_bookmarks';

  // Limits
  static const int _maxBookmarksLoggedIn = 50;
  static const int _maxBookmarksLocal = 10;

  /// Creates a new [FirestoreBookmarkStorageService] instance.
  FirestoreBookmarkStorageService({
    required FirebaseFirestore firestore,
    required AuthServiceInterface authService,
  })  : _firestore = firestore,
        _authService = authService;

  @override
  Future<BookmarkCollection> loadBookmarks() async {
    try {
      final bool isLoggedIn = await _authService.isSignedIn();

      if (isLoggedIn) {
        return await _loadFirestoreBookmarks();
      } else {
        return await _loadLocalBookmarks();
      }
    } catch (e) {
      // If loading fails, return empty collection
      print('Error loading bookmarks: $e');
      return const BookmarkCollection();
    }
  }

  @override
  Future<void> saveBookmarks(BookmarkCollection collection) async {
    try {
      final bool isLoggedIn = await _authService.isSignedIn();

      if (isLoggedIn) {
        // Save to both local storage and Firestore for logged-in users
        await Future.wait([
          _saveLocalBookmarks(collection),
          _saveFirestoreBookmarks(collection),
        ]);
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
    final BookmarkCollection updatedCollection =
        collection.addBookmark(bookmark);
    await saveBookmarks(updatedCollection);
  }

  Future<void> removeBookmark(String bookmarkId) async {
    final BookmarkCollection collection = await loadBookmarks();
    final BookmarkCollection updatedCollection =
        collection.removeBookmark(bookmarkId);
    await saveBookmarks(updatedCollection);
  }

  @override
  Future<void> deleteBookmark(String bookmarkId) async {
    await removeBookmark(bookmarkId);
  }

  Future<void> updateBookmark(SoundBookmark bookmark) async {
    final BookmarkCollection collection = await loadBookmarks();
    final BookmarkCollection updatedCollection =
        collection.updateBookmark(bookmark);
    await saveBookmarks(updatedCollection);
  }

  @override
  Future<void> clearAllBookmarks() async {
    const BookmarkCollection emptyCollection = BookmarkCollection();
    await saveBookmarks(emptyCollection);
  }

  @override
  Future<SoundBookmark?> getLastUsedBookmark() async {
    try {
      final BookmarkCollection collection = await loadBookmarks();
      final List<SoundBookmark> lastUsedBookmarks = collection.bookmarks
          .where((SoundBookmark bookmark) => bookmark.isLastUsed)
          .toList();

      if (lastUsedBookmarks.isNotEmpty) {
        return lastUsedBookmarks.first;
      }
      return null;
    } catch (e) {
      print('Error getting last used bookmark: $e');
      return null;
    }
  }

  @override
  Future<void> markBookmarkAsLastUsed(String bookmarkId) async {
    try {
      final BookmarkCollection collection = await loadBookmarks();

      // Update all bookmarks to unmark them as last used, except the specified one
      final List<SoundBookmark> updatedBookmarks =
          collection.bookmarks.map((bookmark) {
        if (bookmark.id == bookmarkId) {
          return bookmark.copyWith(isLastUsed: true);
        } else {
          return bookmark.copyWith(isLastUsed: false);
        }
      }).toList();

      final BookmarkCollection updatedCollection =
          BookmarkCollection(bookmarks: updatedBookmarks);
      await saveBookmarks(updatedCollection);
    } catch (e) {
      print('Error marking bookmark as last used: $e');
    }
  }

  @override
  Future<bool> isStorageAvailable() async {
    try {
      final bool isLoggedIn = await _authService.isSignedIn();

      if (isLoggedIn) {
        // Test Firestore connectivity
        final String? userId = await _getUserId();
        if (userId == null) return false;

        // Try to read from Firestore
        await _firestore.collection(_bookmarksCollection).doc(userId).get();
        return true;
      } else {
        // Test SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('test_key', 'test_value');
        await prefs.remove('test_key');
        return true;
      }
    } catch (e) {
      print('Storage availability check failed: $e');
      return false;
    }
  }

  @override
  int getMaxBookmarkLimit() {
    // Return the higher limit for logged-in users
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
      final BookmarkCollection cloudCollection =
          await _loadFirestoreBookmarks();

      // Merge collections (local bookmarks take precedence for duplicates)
      List<SoundBookmark> mergedBookmarks =
          List.from(cloudCollection.bookmarks);

      for (final SoundBookmark localBookmark in localCollection.bookmarks) {
        // Check if bookmark with same name already exists in cloud
        final int existingIndex = mergedBookmarks.indexWhere(
          (SoundBookmark bookmark) => bookmark.name == localBookmark.name,
        );

        if (existingIndex >= 0) {
          // Replace existing bookmark with local version (local takes precedence)
          mergedBookmarks[existingIndex] = localBookmark;
        } else {
          // Add new bookmark
          mergedBookmarks.add(localBookmark);
        }
      }

      // Save merged collection to cloud
      final BookmarkCollection mergedCollection =
          BookmarkCollection(bookmarks: mergedBookmarks);
      await _saveFirestoreBookmarks(mergedCollection);

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
      final Map<String, dynamic> data =
          jsonDecode(jsonData) as Map<String, dynamic>;
      final BookmarkCollection importedCollection =
          BookmarkCollection.fromJson(data);

      if (importedCollection.isEmpty) return 0;

      // Load existing bookmarks
      final BookmarkCollection existingCollection = await loadBookmarks();

      // Merge collections
      List<SoundBookmark> mergedBookmarks =
          List.from(existingCollection.bookmarks);
      int importedCount = 0;

      for (final SoundBookmark importedBookmark
          in importedCollection.bookmarks) {
        // Check if bookmark with same name already exists
        final bool exists = mergedBookmarks.any(
          (SoundBookmark bookmark) => bookmark.name == importedBookmark.name,
        );

        if (!exists) {
          mergedBookmarks.add(importedBookmark);
          importedCount++;
        }
      }

      // Save merged collection
      final BookmarkCollection mergedCollection =
          BookmarkCollection(bookmarks: mergedBookmarks);
      await saveBookmarks(mergedCollection);

      return importedCount;
    } catch (e) {
      print('Error importing bookmarks: $e');
      return 0;
    }
  }

  // Private helper methods

  Future<String?> _getUserId() async {
    try {
      final user = await _authService.getCurrentUser();
      return user?.uid;
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  Future<BookmarkCollection> _loadLocalBookmarks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonData = prefs.getString(_localBookmarksKey);

      if (jsonData == null) return const BookmarkCollection();

      final Map<String, dynamic> data =
          jsonDecode(jsonData) as Map<String, dynamic>;
      return BookmarkCollection.fromJson(data);
    } catch (e) {
      print('Error loading local bookmarks: $e');
      return const BookmarkCollection();
    }
  }

  Future<BookmarkCollection> _loadFirestoreBookmarks() async {
    try {
      final String? userId = await _getUserId();
      if (userId == null) return const BookmarkCollection();

      final DocumentSnapshot doc =
          await _firestore.collection(_bookmarksCollection).doc(userId).get();

      if (!doc.exists) return const BookmarkCollection();

      final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data == null) return const BookmarkCollection();

      return BookmarkCollection.fromJson(data);
    } catch (e) {
      print('Error loading Firestore bookmarks: $e');
      return const BookmarkCollection();
    }
  }

  Future<void> _saveLocalBookmarks(BookmarkCollection collection) async {
    try {
      // Apply local storage limits
      BookmarkCollection limitedCollection = collection;
      if (collection.length > _maxBookmarksLocal) {
        final List<SoundBookmark> limitedBookmarks =
            collection.sortedByUpdated.take(_maxBookmarksLocal).toList();
        limitedCollection = BookmarkCollection(bookmarks: limitedBookmarks);
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String jsonData = jsonEncode(limitedCollection.toJson());
      await prefs.setString(_localBookmarksKey, jsonData);
    } catch (e) {
      print('Error saving local bookmarks: $e');
    }
  }

  Future<void> _saveFirestoreBookmarks(BookmarkCollection collection) async {
    try {
      final String? userId = await _getUserId();
      if (userId == null) return;

      // Apply cloud storage limits
      BookmarkCollection limitedCollection = collection;
      if (collection.length > _maxBookmarksLoggedIn) {
        final List<SoundBookmark> limitedBookmarks =
            collection.sortedByUpdated.take(_maxBookmarksLoggedIn).toList();
        limitedCollection = BookmarkCollection(bookmarks: limitedBookmarks);
      }

      await _firestore
          .collection(_bookmarksCollection)
          .doc(userId)
          .set(limitedCollection.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving Firestore bookmarks: $e');
    }
  }

  Future<void> _clearLocalBookmarks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localBookmarksKey);
    } catch (e) {
      print('Error clearing local bookmarks: $e');
    }
  }
}
