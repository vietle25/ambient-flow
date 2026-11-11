'use client';

import React, { useState } from 'react';
import { X, Sparkles } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';
import { useLanguage } from '@/context/LanguageContext';

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
  const { t } = useLanguage();

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
      setError(t.nameRequiredError);
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
            <Sparkles className="w-5 h-5 text-sky-400" />
            <h2 className="text-lg font-semibold tracking-wide">{t.saveModalTitle}</h2>
          </div>
          <button
            onClick={() => setOpenSaveModal(false)}
            className="p-1.5 text-white/50 hover:text-white rounded-full hover:bg-white/10 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Form */}
        <form onSubmit={handleSave} className="mt-5 space-y-4">
          <div>
            <label className="block text-xs font-medium text-white/70 mb-1.5 uppercase tracking-wider">
              {t.presetNameLabel}
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => {
                setName(e.target.value);
                if (error) setError(null);
              }}
              placeholder={t.presetNamePlaceholder}
              maxLength={30}
              className="w-full px-4 py-2.5 rounded-xl bg-white/10 border border-white/20 text-white placeholder-white/30 focus:outline-none focus:border-sky-400 focus:ring-1 focus:ring-sky-400 text-sm transition-all"
            />
            {error && <p className="text-red-400 text-xs mt-1">{error}</p>}
          </div>

          <div>
            <label className="block text-xs font-medium text-white/70 mb-2 uppercase tracking-wider">
              {t.chooseIconLabel}
            </label>
            <div className="grid grid-cols-6 gap-2 max-h-36 overflow-y-auto p-1 scrollbar-thin scrollbar-thumb-white/20">
              {BOOKMARK_ICONS.map((icon) => (
                <button
                  key={icon}
                  type="button"
                  onClick={() => setSelectedIcon(icon)}
                  className={`w-10 h-10 flex items-center justify-center rounded-xl text-lg transition-all ${
                    selectedIcon === icon
                      ? 'bg-sky-500 text-white scale-110 shadow-lg shadow-sky-500/30'
                      : 'bg-white/5 hover:bg-white/15 text-white/80'
                  }`}
                >
                  {icon}
                </button>
              ))}
            </div>
          </div>

          {/* Action buttons */}
          <div className="flex items-center justify-end gap-3 pt-3 border-t border-white/10 mt-6">
            <button
              type="button"
              onClick={() => setOpenSaveModal(false)}
              className="px-4 py-2 rounded-xl text-xs font-medium text-white/70 hover:text-white hover:bg-white/10 transition-colors"
            >
              {t.cancel}
            </button>
            <button
              type="submit"
              disabled={isSavingBookmark}
              className="px-5 py-2 rounded-xl text-xs font-semibold bg-gradient-to-r from-sky-400 to-indigo-500 text-white hover:from-sky-300 hover:to-indigo-400 active:scale-95 transition-all shadow-md shadow-sky-500/20 disabled:opacity-50"
            >
              {isSavingBookmark ? t.saving : t.saveBtn}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
