import { doc, getDoc, setDoc } from 'firebase/firestore';
import { db } from './firebase';
import { BookmarkCollection, SoundBookmark } from '@/types/sound';

const LOCAL_STORAGE_KEY = 'ambient_flow_local_bookmarks';
const FIRESTORE_COLLECTION = 'user_bookmarks';
const MAX_BOOKMARKS = 5;

export const bookmarkStorage = {
  getLocalBookmarks(): BookmarkCollection {
    if (typeof window === 'undefined') return { bookmarks: [] };
    try {
      const data = localStorage.getItem(LOCAL_STORAGE_KEY);
      if (!data) return { bookmarks: [] };
      return JSON.parse(data);
    } catch {
      return { bookmarks: [] };
    }
  },

  saveLocalBookmarks(collection: BookmarkCollection): void {
    if (typeof window === 'undefined') return;
    try {
      localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(collection));
    } catch (e) {
      console.error('Error saving local bookmarks', e);
    }
  },

  async getFirestoreBookmarks(userId: string): Promise<BookmarkCollection> {
    try {
      const ref = doc(db, FIRESTORE_COLLECTION, userId);
      const snap = await getDoc(ref);
      if (snap.exists()) {
        return snap.data() as BookmarkCollection;
      }
      return { bookmarks: [] };
    } catch (e) {
      console.error('Error loading Firestore bookmarks', e);
      return { bookmarks: [] };
    }
  },

  async saveFirestoreBookmarks(userId: string, collection: BookmarkCollection): Promise<void> {
    try {
      const ref = doc(db, FIRESTORE_COLLECTION, userId);
      await setDoc(ref, collection, { merge: true });
    } catch (e) {
      console.error('Error saving Firestore bookmarks', e);
    }
  },

  async loadBookmarks(userId?: string | null): Promise<BookmarkCollection> {
    if (userId) {
      return await this.getFirestoreBookmarks(userId);
    }
    return this.getLocalBookmarks();
  },

  async saveBookmark(bookmark: SoundBookmark, userId?: string | null): Promise<BookmarkCollection> {
    const current = await this.loadBookmarks(userId);
    let updated = current.bookmarks.filter((b) => b.id !== bookmark.id);
    updated.unshift(bookmark);

    if (updated.length > MAX_BOOKMARKS) {
      updated = updated.slice(0, MAX_BOOKMARKS);
    }

    const collection: BookmarkCollection = { bookmarks: updated };

    if (userId) {
      await this.saveFirestoreBookmarks(userId, collection);
    }
    this.saveLocalBookmarks(collection);

    return collection;
  },

  async deleteBookmark(bookmarkId: string, userId?: string | null): Promise<BookmarkCollection> {
    const current = await this.loadBookmarks(userId);
    const updated = current.bookmarks.filter((b) => b.id !== bookmarkId);
    const collection: BookmarkCollection = { bookmarks: updated };

    if (userId) {
      await this.saveFirestoreBookmarks(userId, collection);
    }
    this.saveLocalBookmarks(collection);

    return collection;
  },

  async markAsLastUsed(bookmarkId: string, userId?: string | null): Promise<BookmarkCollection> {
    const current = await this.loadBookmarks(userId);
    const updated = current.bookmarks.map((b) => ({
      ...b,
      isLastUsed: b.id === bookmarkId,
      updatedAt: b.id === bookmarkId ? new Date().toISOString() : b.updatedAt,
    }));
    const collection: BookmarkCollection = { bookmarks: updated };

    if (userId) {
      await this.saveFirestoreBookmarks(userId, collection);
    }
    this.saveLocalBookmarks(collection);

    return collection;
  },

  async migrateLocalToCloud(userId: string): Promise<BookmarkCollection> {
    const local = this.getLocalBookmarks();
    if (local.bookmarks.length === 0) {
      return await this.getFirestoreBookmarks(userId);
    }

    const cloud = await this.getFirestoreBookmarks(userId);
    const existingNames = new Set(cloud.bookmarks.map((b) => b.name.toLowerCase()));
    const merged = [...cloud.bookmarks];

    for (const b of local.bookmarks) {
      if (!existingNames.has(b.name.toLowerCase())) {
        merged.push(b);
        existingNames.add(b.name.toLowerCase());
      }
    }

    const finalCollection: BookmarkCollection = {
      bookmarks: merged.slice(0, MAX_BOOKMARKS),
    };

    await this.saveFirestoreBookmarks(userId, finalCollection);
    return finalCollection;
  },
};
