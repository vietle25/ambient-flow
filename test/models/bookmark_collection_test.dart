import 'package:flutter_test/flutter_test.dart';
import 'package:ambientflow/models/bookmark_collection.dart';
import 'package:ambientflow/models/sound_bookmark.dart';
import 'package:ambientflow/models/sound_bookmark_item.dart';

void main() {
  group('BookmarkCollection', () {
    late SoundBookmark testBookmark1;
    late SoundBookmark testBookmark2;
    late SoundBookmark testBookmark3;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2023, 12, 25, 10, 30);

      testBookmark1 = SoundBookmark(
        id: 'bookmark_1',
        name: 'Bookmark 1',
        icon: '🌧️',
        sounds: [
          const SoundBookmarkItem(soundId: 'rain', volume: 70.0),
        ],
        globalVolume: 80.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      testBookmark2 = SoundBookmark(
        id: 'bookmark_2',
        name: 'Bookmark 2',
        icon: '🌪️',
        sounds: [
          const SoundBookmarkItem(soundId: 'wind', volume: 50.0),
        ],
        globalVolume: 60.0,
        isMuted: false,
        createdAt: testDate.add(const Duration(hours: 1)),
        updatedAt: testDate.add(const Duration(hours: 1)),
        isLastUsed: true,
      );

      testBookmark3 = SoundBookmark(
        id: 'bookmark_3',
        name: 'Bookmark 3',
        icon: '🌊',
        sounds: [
          const SoundBookmarkItem(soundId: 'ocean', volume: 90.0),
        ],
        globalVolume: 70.0,
        isMuted: false,
        createdAt: testDate.add(const Duration(hours: 2)),
        updatedAt: testDate.add(const Duration(hours: 2)),
      );
    });

    test('should create an empty collection', () {
      const collection = BookmarkCollection();

      expect(collection.bookmarks, isEmpty);
      expect(collection.length, equals(0));
      expect(collection.isEmpty, equals(true));
      expect(collection.isNotEmpty, equals(false));
    });

    test('should create a collection with bookmarks', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark2],
      );

      expect(collection.bookmarks.length, equals(2));
      expect(collection.length, equals(2));
      expect(collection.isEmpty, equals(false));
      expect(collection.isNotEmpty, equals(true));
    });

    test('should add a bookmark to the collection', () {
      const collection = BookmarkCollection();
      final updatedCollection = collection.addBookmark(testBookmark1);

      expect(updatedCollection.length, equals(1));
      expect(updatedCollection.bookmarks.first, equals(testBookmark1));
      expect(collection.length, equals(0)); // Original unchanged
    });

    test('should replace existing bookmark with same ID', () {
      final collection = BookmarkCollection(bookmarks: [testBookmark1]);

      final updatedBookmark = testBookmark1.copyWith(name: 'Updated Name');
      final updatedCollection = collection.addBookmark(updatedBookmark);

      expect(updatedCollection.length, equals(1));
      expect(updatedCollection.bookmarks.first.name, equals('Updated Name'));
    });

    test('should add new bookmark at the beginning', () {
      final collection = BookmarkCollection(bookmarks: [testBookmark1]);
      final updatedCollection = collection.addBookmark(testBookmark2);

      expect(updatedCollection.length, equals(2));
      expect(updatedCollection.bookmarks.first, equals(testBookmark2));
      expect(updatedCollection.bookmarks.last, equals(testBookmark1));
    });

    test('should enforce maximum bookmark limit', () {
      // Create a collection with max bookmarks
      final bookmarks = List.generate(
        BookmarkCollection.maxBookmarks,
        (index) => SoundBookmark(
          id: 'bookmark_$index',
          name: 'Bookmark $index',
          icon: '🎵',
          sounds: [],
          globalVolume: 50.0,
          isMuted: false,
          createdAt: testDate,
          updatedAt: testDate,
        ),
      );

      final collection = BookmarkCollection(bookmarks: bookmarks);
      final updatedCollection = collection.addBookmark(testBookmark1);

      expect(updatedCollection.length, equals(BookmarkCollection.maxBookmarks));
      expect(updatedCollection.bookmarks.first, equals(testBookmark1));
    });

    test('should remove a bookmark by ID', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark2],
      );
      final updatedCollection = collection.removeBookmark('bookmark_1');

      expect(updatedCollection.length, equals(1));
      expect(updatedCollection.bookmarks.first, equals(testBookmark2));
    });

    test('should update an existing bookmark', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark2],
      );

      final updatedBookmark = testBookmark1.copyWith(name: 'Updated Name');
      final updatedCollection = collection.updateBookmark(updatedBookmark);

      expect(updatedCollection.length, equals(2));
      expect(
        updatedCollection.bookmarks
            .firstWhere((b) => b.id == 'bookmark_1')
            .name,
        equals('Updated Name'),
      );
    });

    test('should find bookmark by ID', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark2],
      );

      final found = collection.findBookmarkById('bookmark_1');
      final notFound = collection.findBookmarkById('nonexistent');

      expect(found, equals(testBookmark1));
      expect(notFound, isNull);
    });

    test('should get last used bookmark', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark2, testBookmark3],
      );

      final lastUsed = collection.getLastUsedBookmark();

      expect(lastUsed, equals(testBookmark2));
    });

    test('should return null when no bookmark is marked as last used', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark3], // Neither is last used
      );

      final lastUsed = collection.getLastUsedBookmark();

      expect(lastUsed, isNull);
    });

    test('should mark bookmark as last used and unmark others', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark2, testBookmark3],
      );

      final updatedCollection = collection.markBookmarkAsLastUsed('bookmark_1');

      final bookmark1 = updatedCollection.findBookmarkById('bookmark_1')!;
      final bookmark2 = updatedCollection.findBookmarkById('bookmark_2')!;
      final bookmark3 = updatedCollection.findBookmarkById('bookmark_3')!;

      expect(bookmark1.isLastUsed, equals(true));
      expect(bookmark2.isLastUsed, equals(false));
      expect(bookmark3.isLastUsed, equals(false));
    });

    test('should sort bookmarks by date created', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark3, testBookmark1, testBookmark2],
      );

      final sorted = collection.sortedByDate;

      expect(sorted.first, equals(testBookmark3)); // Most recent
      expect(sorted.last, equals(testBookmark1)); // Oldest
    });

    test('should sort bookmarks by last updated', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark3, testBookmark2],
      );

      final sorted = collection.sortedByUpdated;

      expect(sorted.first, equals(testBookmark3)); // Most recently updated
      expect(sorted.last, equals(testBookmark1)); // Least recently updated
    });

    test('should sort bookmarks by name', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark3, testBookmark1, testBookmark2],
      );

      final sorted = collection.sortedByName;

      expect(sorted[0].name, equals('Bookmark 1'));
      expect(sorted[1].name, equals('Bookmark 2'));
      expect(sorted[2].name, equals('Bookmark 3'));
    });

    test('should check if at maximum capacity', () {
      final emptyCollection = const BookmarkCollection();
      final fullCollection = BookmarkCollection(
        bookmarks: List.generate(
          BookmarkCollection.maxBookmarks,
          (index) => SoundBookmark(
            id: 'bookmark_$index',
            name: 'Bookmark $index',
            icon: '🎶',
            sounds: [],
            globalVolume: 50.0,
            isMuted: false,
            createdAt: testDate,
            updatedAt: testDate,
          ),
        ),
      );

      expect(emptyCollection.isAtMaxCapacity, equals(false));
      expect(fullCollection.isAtMaxCapacity, equals(true));
    });

    test('should convert to and from JSON correctly', () {
      final collection = BookmarkCollection(
        bookmarks: [testBookmark1, testBookmark2],
      );

      final json = collection.toJson();
      final fromJson = BookmarkCollection.fromJson(json);

      expect(fromJson.length, equals(collection.length));
      expect(fromJson.bookmarks.first.id, equals(testBookmark1.id));
      expect(fromJson.bookmarks.last.id, equals(testBookmark2.id));
    });

    test('should handle empty JSON correctly', () {
      final json = <String, dynamic>{'bookmarks': null};
      final collection = BookmarkCollection.fromJson(json);

      expect(collection.isEmpty, equals(true));
    });

    test('should have correct equality', () {
      final collection1 = BookmarkCollection(bookmarks: [testBookmark1]);
      final collection2 = BookmarkCollection(bookmarks: [testBookmark1]);
      final collection3 = BookmarkCollection(bookmarks: [testBookmark2]);

      expect(collection1, equals(collection2));
      expect(collection1, isNot(equals(collection3)));
    });
  });
}
