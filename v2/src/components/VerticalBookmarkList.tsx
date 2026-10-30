'use client';

import React from 'react';
import { X } from 'lucide-react';
import { SoundBookmark } from '@/types/sound';
import { useAudioApp } from '@/context/AudioAppContext';

export const VerticalBookmarkList: React.FC = () => {
  const { bookmarks, activeSounds, applyBookmark, deleteBookmark } = useAudioApp();

  if (bookmarks.length === 0) return null;

  // Check if a bookmark's exact sounds are playing
  const isBookmarkActive = (b: SoundBookmark) => {
    const activeKeys = Object.keys(activeSounds);
    if (activeKeys.length !== b.sounds.length || activeKeys.length === 0) return false;
    return b.sounds.every((s) => activeSounds[s.soundId] !== undefined);
  };

  return (
    <aside className="fixed top-24 right-5 z-30 flex flex-col items-center gap-3 p-3 rounded-2xl backdrop-blur-xl bg-white/10 border border-white/20 shadow-2xl">
      <div className="text-[10px] font-bold tracking-wider text-white/50 uppercase select-none mb-1">
        Presets
      </div>
      {bookmarks.map((bookmark) => {
        const active = isBookmarkActive(bookmark);
        return (
          <div key={bookmark.id} className="relative group">
            <button
              onClick={() => applyBookmark(bookmark)}
              title={`${bookmark.name} (${bookmark.sounds.length} sounds)`}
              className={`w-12 h-12 flex items-center justify-center rounded-xl text-2xl transition-all duration-200 select-none ${
                active
                  ? 'bg-sky-500/40 border-2 border-sky-400 shadow-lg shadow-sky-500/20 scale-105'
                  : 'bg-white/10 hover:bg-white/20 border border-white/20 hover:scale-105'
              }`}
            >
              <span>{bookmark.icon || '🎵'}</span>
            </button>

            {/* Delete button on hover */}
            <button
              onClick={(e) => {
                e.stopPropagation();
                deleteBookmark(bookmark.id);
              }}
              className="absolute -top-1.5 -right-1.5 w-5 h-5 bg-black/80 hover:bg-red-600 rounded-full flex items-center justify-center text-white/80 hover:text-white opacity-0 group-hover:opacity-100 transition-all duration-150 shadow-md"
              title="Delete preset"
            >
              <X className="w-3 h-3" />
            </button>
          </div>
        );
      })}
    </aside>
  );
};
