import 'package:flutter_test/flutter_test.dart';
import 'package:ambientflow/models/sound_bookmark.dart';
import 'package:ambientflow/models/sound_bookmark_item.dart';

void main() {
  group('SoundBookmarkItem', () {
    test('should create a SoundBookmarkItem with correct properties', () {
      const item = SoundBookmarkItem(
        soundId: 'test_sound',
        volume: 75.0,
      );

      expect(item.soundId, equals('test_sound'));
      expect(item.volume, equals(75.0));
    });

    test('should create a copy with updated properties', () {
      const original = SoundBookmarkItem(
        soundId: 'test_sound',
        volume: 50.0,
      );

      final copy = original.copyWith(volume: 80.0);

      expect(copy.soundId, equals('test_sound'));
      expect(copy.volume, equals(80.0));
      expect(original.volume, equals(50.0)); // Original unchanged
    });

    test('should convert to and from JSON correctly', () {
      const item = SoundBookmarkItem(
        soundId: 'test_sound',
        volume: 65.5,
      );

      final json = item.toJson();
      final fromJson = SoundBookmarkItem.fromJson(json);

      expect(fromJson.soundId, equals(item.soundId));
      expect(fromJson.volume, equals(item.volume));
    });

    test('should have correct equality', () {
      const item1 = SoundBookmarkItem(soundId: 'test', volume: 50.0);
      const item2 = SoundBookmarkItem(soundId: 'test', volume: 50.0);
      const item3 = SoundBookmarkItem(soundId: 'test', volume: 60.0);

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });
  });

  group('SoundBookmark', () {
    late DateTime testDate;
    late List<SoundBookmarkItem> testSounds;

    setUp(() {
      testDate = DateTime(2023, 12, 25, 10, 30);
      testSounds = [
        const SoundBookmarkItem(soundId: 'rain', volume: 70.0),
        const SoundBookmarkItem(soundId: 'wind', volume: 50.0),
      ];
    });

    test('should create a SoundBookmark with correct properties', () {
      final bookmark = SoundBookmark(
        id: 'test_id',
        name: 'Test Bookmark',
        icon: '🎵',
        sounds: testSounds,
        globalVolume: 80.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
        isLastUsed: true,
      );

      expect(bookmark.id, equals('test_id'));
      expect(bookmark.name, equals('Test Bookmark'));
      expect(bookmark.icon, equals('🎵'));
      expect(bookmark.sounds, equals(testSounds));
      expect(bookmark.globalVolume, equals(80.0));
      expect(bookmark.isMuted, equals(false));
      expect(bookmark.createdAt, equals(testDate));
      expect(bookmark.updatedAt, equals(testDate));
      expect(bookmark.isLastUsed, equals(true));
    });

    test('should create a copy with updated properties', () {
      final original = SoundBookmark(
        id: 'test_id',
        name: 'Original',
        icon: '🎵',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      final copy = original.copyWith(
        name: 'Updated',
        globalVolume: 75.0,
      );

      expect(copy.name, equals('Updated'));
      expect(copy.globalVolume, equals(75.0));
      expect(copy.id, equals(original.id)); // Unchanged
      expect(original.name, equals('Original')); // Original unchanged
    });

    test('should convert to and from JSON correctly', () {
      final bookmark = SoundBookmark(
        id: 'test_id',
        name: 'Test Bookmark',
        icon: '🌧️',
        sounds: testSounds,
        globalVolume: 80.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
        isLastUsed: true,
      );

      final json = bookmark.toJson();
      final fromJson = SoundBookmark.fromJson(json);

      expect(fromJson.id, equals(bookmark.id));
      expect(fromJson.name, equals(bookmark.name));
      expect(fromJson.sounds.length, equals(bookmark.sounds.length));
      expect(fromJson.globalVolume, equals(bookmark.globalVolume));
      expect(fromJson.isMuted, equals(bookmark.isMuted));
      expect(fromJson.createdAt, equals(bookmark.createdAt));
      expect(fromJson.updatedAt, equals(bookmark.updatedAt));
      expect(fromJson.icon, equals(bookmark.icon));
      expect(fromJson.isLastUsed, equals(bookmark.isLastUsed));
    });

    test('should mark as last used correctly', () {
      final bookmark = SoundBookmark(
        id: 'test_id',
        name: 'Test',
        icon: '⭐',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
        isLastUsed: false,
      );

      final marked = bookmark.markAsLastUsed();

      expect(marked.isLastUsed, equals(true));
      expect(marked.updatedAt.isAfter(bookmark.updatedAt), equals(true));
      expect(bookmark.isLastUsed, equals(false)); // Original unchanged
    });

    test('should unmark as last used correctly', () {
      final bookmark = SoundBookmark(
        id: 'test_id',
        name: 'Test',
        icon: '🔥',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
        isLastUsed: true,
      );

      final unmarked = bookmark.unmarkAsLastUsed();

      expect(unmarked.isLastUsed, equals(false));
      expect(bookmark.isLastUsed, equals(true)); // Original unchanged
    });

    test('should return correct sound count', () {
      final bookmark = SoundBookmark(
        id: 'test_id',
        name: 'Test',
        icon: '🌊',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(bookmark.soundCount, equals(2));
    });

    test('should correctly identify empty and non-empty bookmarks', () {
      final emptyBookmark = SoundBookmark(
        id: 'empty',
        name: 'Empty',
        icon: '❄️',
        sounds: [],
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      final nonEmptyBookmark = SoundBookmark(
        id: 'non_empty',
        name: 'Non Empty',
        icon: '🌲',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(emptyBookmark.isEmpty, equals(true));
      expect(emptyBookmark.isNotEmpty, equals(false));
      expect(nonEmptyBookmark.isEmpty, equals(false));
      expect(nonEmptyBookmark.isNotEmpty, equals(true));
    });

    test('should have correct equality', () {
      final bookmark1 = SoundBookmark(
        id: 'test_id',
        name: 'Test',
        icon: '🌙',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      final bookmark2 = SoundBookmark(
        id: 'test_id',
        name: 'Test',
        icon: '🌙',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      final bookmark3 = SoundBookmark(
        id: 'different_id',
        name: 'Test',
        icon: '☀️',
        sounds: testSounds,
        globalVolume: 50.0,
        isMuted: false,
        createdAt: testDate,
        updatedAt: testDate,
      );

      expect(bookmark1, equals(bookmark2));
      expect(bookmark1, isNot(equals(bookmark3)));
    });
  });
}
