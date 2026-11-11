'use client';

import React, { useState, useRef } from 'react';
import {
  X,
  Check,
  Film,
  Image as ImageIcon,
  Sparkles,
  Upload,
  Trash2,
} from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';
import { useLanguage } from '@/context/LanguageContext';
import {
  BACKGROUND_PRESETS,
  BackgroundItem,
  BackgroundType,
} from '@/types/background';

export const BackgroundSelectorModal: React.FC = () => {
  const {
    openBackgroundModal,
    setOpenBackgroundModal,
    currentBackground,
    setBackground,
    customBackgrounds,
    addCustomBackground,
    removeCustomBackground,
  } = useAudioApp();

  const { t } = useLanguage();

  const [activeTab, setActiveTab] = useState<'all' | BackgroundType | 'custom'>('all');
  const [uploadLoading, setUploadLoading] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  if (!openBackgroundModal) return null;

  // Tổng hợp tất cả backgrounds gồm presets và custom
  const allBackgrounds: BackgroundItem[] = [
    ...customBackgrounds,
    ...BACKGROUND_PRESETS,
  ];

  const filteredPresets =
    activeTab === 'all'
      ? allBackgrounds
      : activeTab === 'custom'
      ? customBackgrounds
      : allBackgrounds.filter((bg) => bg.type === activeTab);

  const handleSelectBackground = (preset: BackgroundItem) => {
    setBackground(preset);
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (!file.type.startsWith('image/')) {
      alert(t.alertInvalidImage);
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      alert(t.alertImageTooLarge);
      return;
    }

    try {
      setUploadLoading(true);
      const newBg = await addCustomBackground(file);
      setBackground(newBg);
    } catch (err) {
      console.error(err);
      alert(t.alertUploadError);
    } finally {
      setUploadLoading(false);
      if (fileInputRef.current) fileInputRef.current.value = '';
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-md animate-in fade-in duration-200">
      <div
        className="relative w-full max-w-4xl max-h-[88vh] flex flex-col rounded-3xl bg-slate-900/95 border border-white/10 shadow-2xl overflow-hidden backdrop-blur-2xl"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-5 border-b border-white/10">
          <div>
            <h2 className="text-xl font-semibold text-white tracking-tight flex items-center gap-2">
              <Sparkles className="w-5 h-5 text-indigo-400" />
              {t.bgModalTitle}
            </h2>
            <p className="text-xs text-white/60 mt-0.5">
              {t.bgModalSubtitle}
            </p>
          </div>
          <button
            onClick={() => setOpenBackgroundModal(false)}
            aria-label={t.close}
            className="p-2 text-white/50 hover:text-white rounded-full hover:bg-white/10 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Filter Tabs & Custom Upload Button */}
        <div className="flex flex-wrap items-center justify-between gap-2 px-6 py-3 border-b border-white/5 bg-white/[0.02]">
          <div className="flex items-center gap-2 overflow-x-auto py-1 scrollbar-none">
            <button
              onClick={() => setActiveTab('all')}
              className={`px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'all'
                  ? 'bg-white text-slate-900 shadow-md font-semibold'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              {t.tabAll} ({allBackgrounds.length})
            </button>
            <button
              onClick={() => setActiveTab('gradient')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'gradient'
                  ? 'bg-emerald-600 text-white shadow-md font-semibold'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <Sparkles className="w-3.5 h-3.5 text-emerald-300" />
              {t.tabGradient}
            </button>
            <button
              onClick={() => setActiveTab('image')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'image'
                  ? 'bg-indigo-600 text-white shadow-md font-semibold'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <ImageIcon className="w-3.5 h-3.5 text-indigo-300" />
              {t.tabImage}
            </button>
            <button
              onClick={() => setActiveTab('video')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'video'
                  ? 'bg-indigo-600 text-white shadow-md font-semibold'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <Film className="w-3.5 h-3.5 text-sky-300" />
              {t.tabVideo}
            </button>
            <button
              onClick={() => setActiveTab('custom')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'custom'
                  ? 'bg-indigo-600 text-white shadow-md font-semibold'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <Upload className="w-3.5 h-3.5 text-pink-300" />
              {t.tabCustom} ({customBackgrounds.length})
            </button>
          </div>

          {/* Upload Custom Image Button */}
          <div>
            <input
              type="file"
              ref={fileInputRef}
              onChange={handleFileUpload}
              accept="image/*"
              className="hidden"
            />
            <button
              onClick={() => fileInputRef.current?.click()}
              disabled={uploadLoading}
              className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-semibold bg-gradient-to-r from-indigo-500/20 to-purple-500/20 hover:from-indigo-500/30 hover:to-purple-500/30 text-indigo-300 border border-indigo-500/30 shadow-sm transition-all active:scale-95"
            >
              <Upload className="w-3.5 h-3.5" />
              <span>{uploadLoading ? t.uploading : t.uploadBtn}</span>
            </button>
          </div>
        </div>

        {/* Preset Cards Grid */}
        <div className="flex-1 overflow-y-auto p-6 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          {filteredPresets.map((preset) => {
            const isSelected = currentBackground.id === preset.id;
            const displayName = t.presetNames[preset.id] || preset.name;
            const displayDesc = t.presetDescriptions[preset.id] || preset.description;

            return (
              <div
                key={preset.id}
                onClick={() => handleSelectBackground(preset)}
                className={`group relative flex flex-col h-44 rounded-2xl overflow-hidden cursor-pointer border transition-all duration-300 text-left ${
                  isSelected
                    ? 'border-indigo-400 ring-2 ring-indigo-400/50 shadow-lg shadow-indigo-500/20 scale-[1.01]'
                    : 'border-white/10 hover:border-white/30 hover:scale-[1.02]'
                }`}
              >
                {/* Thumbnail Background */}
                <div
                  className="absolute inset-0 bg-cover bg-center transition-transform duration-500 group-hover:scale-110"
                  style={{
                    backgroundImage: `url('${preset.thumbnail}')`,
                  }}
                />

                {/* Shading overlay */}
                <div className="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/40 to-transparent" />

                {/* Badge Type */}
                <div className="relative p-3 flex justify-between items-start z-10">
                  <span className="px-2 py-0.5 rounded-md text-[10px] font-medium tracking-wider uppercase backdrop-blur-md bg-black/60 text-white/90 border border-white/10 flex items-center gap-1">
                    {preset.type === 'video' && (
                      <Film className="w-3 h-3 text-sky-400" />
                    )}
                    {preset.type === 'image' && (
                      <ImageIcon className="w-3 h-3 text-emerald-400" />
                    )}
                    {preset.type === 'gradient' && (
                      <Sparkles className="w-3 h-3 text-amber-400" />
                    )}
                    {preset.isCustom
                      ? t.badgeCustom
                      : preset.type === 'video'
                      ? t.badgeVideo
                      : preset.type === 'image'
                      ? t.badgeImage
                      : t.badgeGradient}
                  </span>

                  <div className="flex items-center gap-1.5">
                    {/* Nút xóa ảnh custom */}
                    {preset.isCustom && (
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          removeCustomBackground(preset.id);
                        }}
                        title={t.deleteCustomBgTitle}
                        className="p-1 rounded-md bg-red-500/20 text-red-300 hover:bg-red-500/40 transition-colors"
                      >
                        <Trash2 className="w-3.5 h-3.5" />
                      </button>
                    )}

                    {isSelected && (
                      <div className="w-6 h-6 rounded-full bg-indigo-500 text-white flex items-center justify-center shadow-lg animate-in zoom-in-75 duration-200">
                        <Check className="w-3.5 h-3.5 stroke-[3]" />
                      </div>
                    )}
                  </div>
                </div>

                {/* Card Info at Bottom */}
                <div className="relative mt-auto p-3 z-10">
                  <h3 className="text-sm font-semibold text-white group-hover:text-indigo-200 transition-colors">
                    {displayName}
                  </h3>
                  {displayDesc && (
                    <p className="text-[11px] text-white/70 line-clamp-1 mt-0.5">
                      {displayDesc}
                    </p>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Footer */}
        <div className="px-6 py-4 border-t border-white/10 flex items-center justify-between bg-white/[0.02]">
          <span className="text-xs text-white/60">
            {t.currentlyApplied} <span className="text-white font-medium">{t.presetNames[currentBackground.id] || currentBackground.name}</span>
          </span>
          <button
            onClick={() => setOpenBackgroundModal(false)}
            className="px-5 py-2 rounded-xl text-xs font-semibold bg-white text-slate-900 hover:bg-white/90 active:scale-95 transition-all"
          >
            {t.close}
          </button>
        </div>
      </div>
    </div>
  );
};
