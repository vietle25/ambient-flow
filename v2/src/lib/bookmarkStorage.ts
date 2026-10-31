import { doc, getDoc, setDoc } from 'firebase/firestore';
import { db } from './firebase';
import { BookmarkCollection, SoundBookmark } from '@/types/sound';

const LOCAL_STORAGE_KEY = 'ambient_flow_local_bookmarks';
const FIRESTORE_COLLECTION = 'user_bookmarks';
const MAX_BOOKMARKS = 10;

export const bookmarkStorage = {
  getLocalBookmarks(): BookmarkCollection {
    if (typeof window === 'undefined') return { bookmarks: [] };
    try {
      const data = localStorage.getItem(LOCAL_STORAGE_KEY);
      if (!data) return { bookmarks: [] };
      const parsed = JSON.parse(data);
      if (Array.isArray(parsed?.bookmarks)) {
        return parsed as BookmarkCollection;
      }
      return { bookmarks: [] };
    } catch (e) {
      console.warn('Error reading local bookmarks:', e);
      return { bookmarks: [] };
    }
  },

  saveLocalBookmarks(collection: BookmarkCollection): void {
    if (typeof window === 'undefined') return;
    try {
      localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(collection));
    } catch (e) {
      console.error('Error saving local bookmarks:', e);
    }
  },

  async getFirestoreBookmarks(userId: string): Promise<BookmarkCollection | null> {
    try {
      const ref = doc(db, FIRESTORE_COLLECTION, userId);
      const snap = await getDoc(ref);
      if (snap.exists()) {
        const data = snap.data();
        if (Array.isArray(data?.bookmarks)) {
          return data as BookmarkCollection;
        }
      }
      return null;
    } catch (e) {
      console.error('Error loading Firestore bookmarks:', e);
      return null;
    }
  },

  async saveFirestoreBookmarks(userId: string, collection: BookmarkCollection): Promise<void> {
    try {
      const ref = doc(db, FIRESTORE_COLLECTION, userId);
      await setDoc(ref, collection, { merge: true });
    } catch (e) {
      console.error('Error saving Firestore bookmarks:', e);
    }
  },

  async loadBookmarks(userId?: string | null): Promise<BookmarkCollection> {
    if (userId) {
      const cloud = await this.getFirestoreBookmarks(userId);
      if (cloud && cloud.bookmarks.length > 0) {
        // Luôn đồng bộ vào local cache để backup
        this.saveLocalBookmarks(cloud);
        return cloud;
      }
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

    // LUÔN lưu vào LocalStorage trước tiên để đảm bảo dữ liệu không bao giờ bị mất
    this.saveLocalBookmarks(collection);

    if (userId) {
      this.saveFirestoreBookmarks(userId, collection).catch((err) => {
        console.warn('Could not sync to cloud in background:', err);
      });
    }

    return collection;
  },

  async deleteBookmark(bookmarkId: string, userId?: string | null): Promise<BookmarkCollection> {
    const current = await this.loadBookmarks(userId);
    const updated = current.bookmarks.filter((b) => b.id !== bookmarkId);
    const collection: BookmarkCollection = { bookmarks: updated };

    this.saveLocalBookmarks(collection);

    if (userId) {
      this.saveFirestoreBookmarks(userId, collection).catch((err) => {
        console.warn('Could not sync delete to cloud:', err);
      });
    }

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

    this.saveLocalBookmarks(collection);

    if (userId) {
      this.saveFirestoreBookmarks(userId, collection).catch((err) => {
        console.warn('Could not sync last used to cloud:', err);
      });
    }

    return collection;
  },

  async migrateLocalToCloud(userId: string): Promise<BookmarkCollection> {
    const local = this.getLocalBookmarks();
    const cloud = await this.getFirestoreBookmarks(userId);

    if (!cloud || cloud.bookmarks.length === 0) {
      if (local.bookmarks.length > 0) {
        await this.saveFirestoreBookmarks(userId, local);
      }
      return local;
    }

    const existingIds = new Set(cloud.bookmarks.map((b) => b.id));
    const merged = [...cloud.bookmarks];

    for (const b of local.bookmarks) {
      if (!existingIds.has(b.id)) {
        merged.push(b);
        existingIds.add(b.id);
      }
    }

    const finalCollection: BookmarkCollection = {
      bookmarks: merged.slice(0, MAX_BOOKMARKS),
    };

    this.saveLocalBookmarks(finalCollection);
    await this.saveFirestoreBookmarks(userId, finalCollection);
    return finalCollection;
  },
};
