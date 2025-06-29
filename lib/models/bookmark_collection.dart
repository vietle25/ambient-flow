import 'package:equatable/equatable.dart';

import 'sound_bookmark.dart';

/// Model class representing a collection of bookmarks for a user.
///
/// This manages all bookmarks for a user, including operations like
/// adding, removing, and finding bookmarks.
class BookmarkCollection extends Equatable {
  /// The list of bookmarks in this collection.
  final List<SoundBookmark> bookmarks;

  /// The maximum number of bookmarks allowed per user.
  static const int maxBookmarks = 5;

  /// Creates a new [BookmarkCollection] instance.
  const BookmarkCollection({
    this.bookmarks = const [],
  });

  /// Creates a copy of this [BookmarkCollection] with the given fields replaced with new values.
  BookmarkCollection copyWith({
    List<SoundBookmark>? bookmarks,
  }) {
    return BookmarkCollection(
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }

  /// Adds a new bookmark to the collection.
  ///
  /// If the collection is at maximum capacity, removes the oldest bookmark.
  /// If a bookmark with the same ID exists, replaces it.
  BookmarkCollection addBookmark(SoundBookmark bookmark) {
    final List<SoundBookmark> updatedBookmarks = List.from(bookmarks);

    // Remove existing bookmark with same ID if it exists
    updatedBookmarks.removeWhere((b) => b.id == bookmark.id);

    // Add the new bookmark at the beginning (most recent first)
    updatedBookmarks.insert(0, bookmark);

    // Ensure we don't exceed the maximum number of bookmarks
    if (updatedBookmarks.length > maxBookmarks) {
      updatedBookmarks.removeRange(maxBookmarks, updatedBookmarks.length);
    }

    return copyWith(bookmarks: updatedBookmarks);
  }

  /// Removes a bookmark from the collection by ID.
  BookmarkCollection removeBookmark(String bookmarkId) {
    final List<SoundBookmark> updatedBookmarks =
        bookmarks.where((bookmark) => bookmark.id != bookmarkId).toList();

    return copyWith(bookmarks: updatedBookmarks);
  }

  /// Updates an existing bookmark in the collection.
  BookmarkCollection updateBookmark(SoundBookmark updatedBookmark) {
    final List<SoundBookmark> updatedBookmarks = bookmarks
        .map((bookmark) =>
            bookmark.id == updatedBookmark.id ? updatedBookmark : bookmark)
        .toList();

    return copyWith(bookmarks: updatedBookmarks);
  }

  /// Finds a bookmark by ID.
  SoundBookmark? findBookmarkById(String bookmarkId) {
    try {
      return bookmarks.firstWhere((bookmark) => bookmark.id == bookmarkId);
    } catch (e) {
      return null;
    }
  }

  /// Gets the last used bookmark.
  SoundBookmark? getLastUsedBookmark() {
    try {
      return bookmarks.firstWhere((bookmark) => bookmark.isLastUsed);
    } catch (e) {
      return null;
    }
  }

  /// Marks a bookmark as last used and unmarks all others.
  BookmarkCollection markBookmarkAsLastUsed(String bookmarkId) {
    final List<SoundBookmark> updatedBookmarks = bookmarks
        .map((bookmark) => bookmark.id == bookmarkId
            ? bookmark.markAsLastUsed()
            : bookmark.unmarkAsLastUsed())
        .toList();

    return copyWith(bookmarks: updatedBookmarks);
  }

  /// Gets bookmarks sorted by creation date (newest first).
  List<SoundBookmark> get sortedByDate {
    final List<SoundBookmark> sorted = List.from(bookmarks);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Gets bookmarks sorted by last updated date (newest first).
  List<SoundBookmark> get sortedByUpdated {
    final List<SoundBookmark> sorted = List.from(bookmarks);
    sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sorted;
  }

  /// Gets bookmarks sorted by name (alphabetical).
  List<SoundBookmark> get sortedByName {
    final List<SoundBookmark> sorted = List.from(bookmarks);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }

  /// Converts this [BookmarkCollection] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'bookmarks': bookmarks.map((bookmark) => bookmark.toJson()).toList(),
    };
  }

  /// Creates a [BookmarkCollection] from a JSON map.
  factory BookmarkCollection.fromJson(Map<String, dynamic> json) {
    return BookmarkCollection(
      bookmarks: (json['bookmarks'] as List<dynamic>?)
              ?.map((bookmarkJson) =>
                  SoundBookmark.fromJson(bookmarkJson as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Gets the number of bookmarks in this collection.
  int get length => bookmarks.length;

  /// Checks if this collection is empty.
  bool get isEmpty => bookmarks.isEmpty;

  /// Checks if this collection is not empty.
  bool get isNotEmpty => bookmarks.isNotEmpty;

  /// Checks if the collection is at maximum capacity.
  bool get isAtMaxCapacity => bookmarks.length >= maxBookmarks;

  @override
  List<Object?> get props => [bookmarks];

  @override
  String toString() => 'BookmarkCollection(count: $length)';
}
