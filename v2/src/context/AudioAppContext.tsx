'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import { User, onAuthStateChanged, signInWithPopup, signOut as fbSignOut } from 'firebase/auth';
import { auth, googleProvider } from '@/lib/firebase';
import { BookmarkCollection, SoundBookmark, SOUNDS } from '@/types/sound';
import { audioManager } from '@/lib/audioManager';
import { bookmarkStorage } from '@/lib/bookmarkStorage';

interface AudioAppContextType {
  // Auth
  user: User | null;
  authLoading: boolean;
  signInGoogle: () => Promise<void>;
  signOut: () => Promise<void>;

  // Global Volume & Mute
  globalVolume: number;
  isMuted: boolean;
  setGlobalVolume: (val: number) => void;
  toggleMute: () => void;

  // Active Sounds & Volumes
  activeSounds: Record<string, number>; // soundId -> volume (0..100)
  toggleSound: (soundId: string) => void;
  setSoundVolume: (soundId: string, volume: number) => void;
  clearAllSounds: () => void;

  // Bookmarks
  bookmarks: SoundBookmark[];
  isSavingBookmark: boolean;
  openSaveModal: boolean;
  setOpenSaveModal: (val: boolean) => void;
  saveCurrentBookmark: (name: string, icon: string) => Promise<boolean>;
  applyBookmark: (bookmark: SoundBookmark) => void;
  deleteBookmark: (bookmarkId: string) => Promise<void>;
}

const AudioAppContext = createContext<AudioAppContextType | null>(null);

export const AudioAppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [authLoading, setAuthLoading] = useState(true);

  const [globalVolume, setGlobalVolumeState] = useState(50);
  const [prevVolume, setPrevVolume] = useState(50);
  const [isMuted, setIsMuted] = useState(false);

  // soundId -> volume (0..100)
  const [activeSounds, setActiveSounds] = useState<Record<string, number>>({});

  // Bookmarks
  const [bookmarks, setBookmarks] = useState<SoundBookmark[]>([]);
  const [isSavingBookmark, setIsSavingBookmark] = useState(false);
  const [openSaveModal, setOpenSaveModal] = useState(false);

  // Listen to Auth State
  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (currentUser) => {
      setUser(currentUser);
      setAuthLoading(false);

      if (currentUser) {
        // Migrate and load cloud bookmarks
        const cloudBookmarks = await bookmarkStorage.migrateLocalToCloud(currentUser.uid);
        setBookmarks(cloudBookmarks.bookmarks);
      } else {
        // Load local bookmarks
        const local = bookmarkStorage.getLocalBookmarks();
        setBookmarks(local.bookmarks);
      }
    });

    return () => unsubscribe();
  }, []);

  const signInGoogle = async () => {
    try {
      await signInWithPopup(auth, googleProvider);
    } catch (e) {
      console.error('Sign in error:', e);
    }
  };

  const signOut = async () => {
    try {
      await fbSignOut(auth);
      // Reload local
      const local = bookmarkStorage.getLocalBookmarks();
      setBookmarks(local.bookmarks);
    } catch (e) {
      console.error('Sign out error:', e);
    }
  };

  const setGlobalVolume = (val: number) => {
    setGlobalVolumeState(val);
    if (audioManager) {
      audioManager.setGlobalVolume(val);
    }
    if (isMuted && val > 0) {
      setIsMuted(false);
      audioManager?.setMuted(false);
    }
  };

  const toggleMute = () => {
    if (isMuted) {
      const restored = prevVolume > 0 ? prevVolume : 50;
      setIsMuted(false);
      setGlobalVolumeState(restored);
      audioManager?.setMuted(false);
      audioManager?.setGlobalVolume(restored);
    } else {
      setPrevVolume(globalVolume > 0 ? globalVolume : 50);
      setIsMuted(true);
      audioManager?.setMuted(true);
    }
  };

  const toggleSound = (soundId: string) => {
    const sound = SOUNDS.find((s) => s.id === soundId);
    if (!sound) return;

    setActiveSounds((prev) => {
      const isAlreadyActive = prev[soundId] !== undefined;
      const updated = { ...prev };

      if (isAlreadyActive) {
        delete updated[soundId];
        audioManager?.stopSound(soundId);
      } else {
        const defaultVol = 50;
        updated[soundId] = defaultVol;
        audioManager?.playSound(soundId, sound.audioPath, defaultVol);
      }
      return updated;
    });
  };

  const setSoundVolume = (soundId: string, volume: number) => {
    setActiveSounds((prev) => {
      if (prev[soundId] === undefined) return prev;
      return { ...prev, [soundId]: volume };
    });
    audioManager?.setSoundVolume(soundId, volume);
  };

  const clearAllSounds = () => {
    setActiveSounds({});
    audioManager?.stopAll();
  };

  const applyBookmark = (bookmark: SoundBookmark) => {
    audioManager?.stopAll();

    const newActive: Record<string, number> = {};
    for (const item of bookmark.sounds) {
      const sound = SOUNDS.find((s) => s.id === item.soundId);
      if (sound) {
        newActive[item.soundId] = item.volume;
        audioManager?.playSound(item.soundId, sound.audioPath, item.volume);
      }
    }

    setActiveSounds(newActive);
    setGlobalVolume(bookmark.globalVolume);

    bookmarkStorage.markAsLastUsed(bookmark.id, user?.uid).then((col) => {
      setBookmarks(col.bookmarks);
    });
  };

  const saveCurrentBookmark = async (name: string, icon: string): Promise<boolean> => {
    const activeEntries = Object.entries(activeSounds);
    if (activeEntries.length === 0) return false;

    setIsSavingBookmark(true);
    try {
      const newBookmark: SoundBookmark = {
        id: `bookmark_${Date.now()}`,
        name: name.trim(),
        icon,
        sounds: activeEntries.map(([soundId, volume]) => ({
          soundId,
          volume,
        })),
        globalVolume,
        isMuted: false,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        isLastUsed: true,
      };

      const updated = await bookmarkStorage.saveBookmark(newBookmark, user?.uid);
      setBookmarks(updated.bookmarks);
      setIsSavingBookmark(false);
      setOpenSaveModal(false);
      return true;
    } catch (e) {
      console.error('Error saving bookmark', e);
      setIsSavingBookmark(false);
      return false;
    }
  };

  const deleteBookmark = async (bookmarkId: string) => {
    const updated = await bookmarkStorage.deleteBookmark(bookmarkId, user?.uid);
    setBookmarks(updated.bookmarks);
  };

  return (
    <AudioAppContext.Provider
      value={{
        user,
        authLoading,
        signInGoogle,
        signOut,
        globalVolume,
        isMuted,
        setGlobalVolume,
        toggleMute,
        activeSounds,
        toggleSound,
        setSoundVolume,
        clearAllSounds,
        bookmarks,
        isSavingBookmark,
        openSaveModal,
        setOpenSaveModal,
        saveCurrentBookmark,
        applyBookmark,
        deleteBookmark,
      }}
    >
      {children}
    </AudioAppContext.Provider>
  );
};

export const useAudioApp = () => {
  const context = useContext(AudioAppContext);
  if (!context) {
    throw new Error('useAudioApp must be used within an AudioAppProvider');
  }
  return context;
};
