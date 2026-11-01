'use client';

import React, { createContext, useContext, useEffect, useState, useRef } from 'react';
import { User, onAuthStateChanged, signInWithPopup, signOut as fbSignOut } from 'firebase/auth';
import { auth, googleProvider } from '@/lib/firebase';
import { BookmarkCollection, SoundBookmark, SOUNDS } from '@/types/sound';
import { BackgroundItem, BACKGROUND_PRESETS } from '@/types/background';
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

  // Background Customization
  currentBackground: BackgroundItem;
  setBackground: (bg: BackgroundItem) => void;
  openBackgroundModal: boolean;
  setOpenBackgroundModal: (val: boolean) => void;

  // Pro Membership & Remove Ads
  isPro: boolean;
  openProModal: boolean;
  setOpenProModal: (val: boolean) => void;
  setProStatus: (status: boolean) => void;

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

  // Background State
  const [currentBackground, setCurrentBackground] = useState<BackgroundItem>(() => {
    if (typeof window !== 'undefined') {
      try {
        const savedId = localStorage.getItem('ambient_flow_bg_id');
        if (savedId) {
          const found = BACKGROUND_PRESETS.find((bg) => bg.id === savedId);
          if (found) return found;
        }
      } catch (e) {
        console.error('Error loading background from local storage', e);
      }
    }
    return BACKGROUND_PRESETS[0]; // Mặc định là dynamic gradient
  });
  const [openBackgroundModal, setOpenBackgroundModal] = useState(false);

  const setBackground = (bg: BackgroundItem) => {
    setCurrentBackground(bg);
    if (typeof window !== 'undefined') {
      try {
        localStorage.setItem('ambient_flow_bg_id', bg.id);
      } catch (e) {
        console.error('Error saving background to local storage', e);
      }
    }
  };

  // Pro Membership State
  const [isPro, setIsProState] = useState<boolean>(() => {
    if (typeof window !== 'undefined') {
      try {
        return localStorage.getItem('ambient_flow_is_pro') === 'true';
      } catch (e) {
        return false;
      }
    }
    return false;
  });
  const [openProModal, setOpenProModal] = useState(false);

  const setProStatus = (status: boolean) => {
    setIsProState(status);
    if (typeof window !== 'undefined') {
      try {
        localStorage.setItem('ambient_flow_is_pro', status ? 'true' : 'false');
      } catch (e) {
        console.error('Error saving pro status', e);
      }
    }
  };

  // Bookmarks - Load ngay lập tức từ LocalStorage để không bị trễ khi mount
  const [bookmarks, setBookmarks] = useState<SoundBookmark[]>(() => {
    return bookmarkStorage.getLocalBookmarks().bookmarks;
  });
  const [isSavingBookmark, setIsSavingBookmark] = useState(false);
  const [openSaveModal, setOpenSaveModal] = useState(false);

  const userRef = useRef<User | null>(null);
  userRef.current = user;

  // Khởi tạo ban đầu: Load bookmark từ local trước, sau đó lắng nghe Auth
  useEffect(() => {
    // 1. Luôn load ngay bookmarks từ LocalStorage
    const initialLocal = bookmarkStorage.getLocalBookmarks();
    if (initialLocal.bookmarks.length > 0) {
      setBookmarks(initialLocal.bookmarks);
    }

    // 2. Lắng nghe trạng thái đăng nhập Firebase
    const unsubscribe = onAuthStateChanged(auth, async (currentUser) => {
      setUser(currentUser);
      setAuthLoading(false);

      if (currentUser) {
        try {
          const cloudBookmarks = await bookmarkStorage.migrateLocalToCloud(currentUser.uid);
          setBookmarks(cloudBookmarks.bookmarks);
        } catch (e) {
          console.warn('Could not sync cloud bookmarks on auth change, keeping local:', e);
        }
      } else {
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
    // 1. Dừng tất cả âm thanh hiện tại
    audioManager?.stopAll();

    // 2. Kích hoạt toàn bộ âm thanh và âm lượng từ preset đã lưu
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

    // 3. Đánh dấu preset vừa dùng và cập nhật state (KHÔNG ĐƯỢC làm mất danh sách bookmarks)
    setBookmarks((prev) =>
      prev.map((b) => ({
        ...b,
        isLastUsed: b.id === bookmark.id,
      }))
    );

    // Ghi nhận trạng thái lastUsed vào storage
    bookmarkStorage.markAsLastUsed(bookmark.id, userRef.current?.uid).then((col) => {
      if (col && Array.isArray(col.bookmarks) && col.bookmarks.length > 0) {
        setBookmarks(col.bookmarks);
      }
    }).catch((err) => {
      console.warn('Could not update markAsLastUsed in background:', err);
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

      // Cập nhật state UI ngay lập tức
      setBookmarks((prev) => {
        const filtered = prev.filter((b) => b.id !== newBookmark.id);
        return [newBookmark, ...filtered].slice(0, 10);
      });

      // Lưu xuống Storage
      const updated = await bookmarkStorage.saveBookmark(newBookmark, userRef.current?.uid);
      if (updated && Array.isArray(updated.bookmarks)) {
        setBookmarks(updated.bookmarks);
      }

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
    setBookmarks((prev) => prev.filter((b) => b.id !== bookmarkId));
    const updated = await bookmarkStorage.deleteBookmark(bookmarkId, userRef.current?.uid);
    if (updated && Array.isArray(updated.bookmarks)) {
      setBookmarks(updated.bookmarks);
    }
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
        currentBackground,
        setBackground,
        openBackgroundModal,
        setOpenBackgroundModal,
        isPro,
        openProModal,
        setOpenProModal,
        setProStatus,
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
