'use client';

import React, { useState } from 'react';
import { X, Sparkles } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';

const BOOKMARK_ICONS = [
  '🎵', '🎶', '🎼', '🎹', '🎸', '🥁', '🎺', '🎷', '🎻', '🎧',
  '☕', '🍵', '🌧️', '⛈️', '🌊', '🌲', '🍃', '🔥', '🌙', '⭐',
  '✨', '💫', '☀️', '🌈', '💎', '🌸', '🌿', '🍀', '🏖️', '⛺',
];

const ADJECTIVES = [
  'Serene', 'Tranquil', 'Peaceful', 'Mystic', 'Ethereal', 'Dreamy',
  'Gentle', 'Soothing', 'Calming', 'Blissful', 'Harmonious', 'Zen',
  'Celestial', 'Whispering', 'Floating', 'Golden', 'Moonlit', 'Twilight',
];

const NOUNS = [
  'Sanctuary', 'Haven', 'Oasis', 'Garden', 'Meadow', 'Valley',
  'Stream', 'Breeze', 'Waves', 'Mist', 'Harmony', 'Symphony',
  'Melody', 'Rhythm', 'Echo', 'Dreams', 'Journey', 'Escape', 'Solace',
];

export const SaveBookmarkModal: React.FC = () => {
  const { openSaveModal, setOpenSaveModal, saveCurrentBookmark, isSavingBookmark } = useAudioApp();

  const [name, setName] = useState('');
  const [selectedIcon, setSelectedIcon] = useState('🎵');
  const [error, setError] = useState<string | null>(null);

  // Initialize fancy name when modal opens
  React.useEffect(() => {
    if (openSaveModal) {
      const randAdj = ADJECTIVES[Math.floor(Math.random() * ADJECTIVES.length)];
      const randNoun = NOUNS[Math.floor(Math.random() * NOUNS.length)];
      setName(`${randAdj} ${randNoun}`);
      setError(null);
    }
  }, [openSaveModal]);

  if (!openSaveModal) return null;

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      setError('Please enter a preset name');
      return;
    }
    const success = await saveCurrentBookmark(name, selectedIcon);
    if (!success) {
      setError('Failed to save preset');
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-md animate-in fade-in duration-200">
      <div className="relative w-full max-w-md bg-[#232F3E]/95 border border-white/20 rounded-3xl p-6 shadow-2xl backdrop-blur-xl text-white">
        {/* Header */}
        <div className="flex items-center justify-between pb-4 border-b border-white/10">
          <div className="flex items-center gap-2">
            <Sparkles className="w-5 h-5 text-amber-300" />
            <h2 className="text-xl font-bold">Save Soundscape</h2>
          </div>
          <button
            onClick={() => setOpenSaveModal(false)}
            className="p-1 rounded-full text-white/60 hover:text-white hover:bg-white/10 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSave} className="mt-5 space-y-5">
          {/* Icon Selector */}
          <div>
            <label className="block text-xs font-semibold uppercase tracking-wider text-white/70 mb-2">
              Choose Icon
            </label>
            <div className="grid grid-cols-6 gap-2 max-h-36 overflow-y-auto p-2 bg-black/20 rounded-2xl border border-white/10">
              {BOOKMARK_ICONS.map((icon) => (
                <button
                  type="button"
                  key={icon}
                  onClick={() => setSelectedIcon(icon)}
                  className={`h-11 flex items-center justify-center rounded-xl text-xl transition-all ${
                    selectedIcon === icon
                      ? 'bg-white/25 border-2 border-white scale-105 shadow-md'
                      : 'hover:bg-white/10 border border-transparent'
                  }`}
                >
                  {icon}
                </button>
              ))}
            </div>
          </div>

          {/* Name Input */}
          <div>
            <label className="block text-xs font-semibold uppercase tracking-wider text-white/70 mb-2">
              Preset Name
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => {
                setName(e.target.value);
                if (error) setError(null);
              }}
              placeholder="e.g. Rainy Coffee Shop"
              className="w-full px-4 py-3 rounded-2xl bg-white/10 border border-white/20 focus:border-white focus:outline-none text-white placeholder-white/40 text-sm transition-colors"
              autoFocus
            />
          </div>

          {error && <p className="text-red-400 text-xs">{error}</p>}

          {/* Actions */}
          <div className="flex items-center justify-end gap-3 pt-2">
            <button
              type="button"
              onClick={() => setOpenSaveModal(false)}
              className="px-5 py-2.5 rounded-2xl text-sm font-medium text-white/70 hover:text-white hover:bg-white/10 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSavingBookmark}
              className="px-6 py-2.5 rounded-2xl text-sm font-semibold bg-white text-slate-900 hover:bg-white/90 active:scale-95 transition-all shadow-lg shadow-white/10 disabled:opacity-50"
            >
              {isSavingBookmark ? 'Saving...' : 'Save'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
