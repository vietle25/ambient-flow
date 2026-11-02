'use client';

import React, { useState, useRef } from 'react';
import {
  X,
  Check,
  Film,
  Image as ImageIcon,
  Sparkles,
  Lock,
  Upload,
  Trash2,
  Crown,
} from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';
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
    isPro,
    setOpenProModal,
  } = useAudioApp();

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
    // Nếu là item ProOnly hoặc Custom mà chưa mua Pro -> Kích hoạt Modal Mua Pro
    if ((preset.isProOnly || preset.isCustom) && !isPro) {
      setOpenProModal(true);
      return;
    }

    setBackground(preset);
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (!isPro) {
      setOpenProModal(true);
      if (fileInputRef.current) fileInputRef.current.value = '';
      return;
    }

    if (!file.type.startsWith('image/')) {
      alert('Vui lòng chọn file hình ảnh (JPG, PNG, WebP).');
      return;
    }

    if (file.size > 5 * 1024 * 1024) {
      alert('Kích thước ảnh tối đa 5MB.');
      return;
    }

    try {
      setUploadLoading(true);
      const newBg = await addCustomBackground(file);
      setBackground(newBg);
    } catch (err) {
      console.error(err);
      alert('Lỗi tải ảnh. Vui lòng thử lại.');
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
              Không gian &amp; Hình nền
            </h2>
            <p className="text-xs text-white/60 mt-0.5">
              Giao diện đổi màu miễn phí &bull; Ảnh, Video và Tự tải ảnh dành cho thành viên <strong className="text-amber-400">Pro</strong>
            </p>
          </div>
          <button
            onClick={() => setOpenBackgroundModal(false)}
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
              Tất cả ({allBackgrounds.length})
            </button>
            <button
              onClick={() => setActiveTab('gradient')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'gradient'
                  ? 'bg-emerald-600 text-white shadow-md'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <Sparkles className="w-3.5 h-3.5 text-emerald-300" />
              Chuyển màu động (Free)
            </button>
            <button
              onClick={() => setActiveTab('image')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'image'
                  ? 'bg-indigo-600 text-white shadow-md'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <ImageIcon className="w-3.5 h-3.5 text-indigo-300" />
              Ảnh Chill
              <Crown className="w-3 h-3 text-amber-400 ml-0.5" />
            </button>
            <button
              onClick={() => setActiveTab('video')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'video'
                  ? 'bg-indigo-600 text-white shadow-md'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <Film className="w-3.5 h-3.5 text-sky-300" />
              Video lặp
              <Crown className="w-3 h-3 text-amber-400 ml-0.5" />
            </button>
            <button
              onClick={() => setActiveTab('custom')}
              className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-medium transition-all ${
                activeTab === 'custom'
                  ? 'bg-indigo-600 text-white shadow-md'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              <Upload className="w-3.5 h-3.5 text-pink-300" />
              Ảnh của bạn ({customBackgrounds.length})
              <Crown className="w-3 h-3 text-amber-400 ml-0.5" />
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
              onClick={() => {
                if (!isPro) {
                  setOpenProModal(true);
                } else {
                  fileInputRef.current?.click();
                }
              }}
              disabled={uploadLoading}
              className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-full text-xs font-semibold bg-gradient-to-r from-amber-500/20 to-orange-500/20 hover:from-amber-500/30 hover:to-orange-500/30 text-amber-300 border border-amber-500/30 shadow-sm transition-all active:scale-95"
            >
              <Upload className="w-3.5 h-3.5" />
              <span>{uploadLoading ? 'Đang tải...' : 'Tự upload ảnh'}</span>
              {!isPro && <Lock className="w-3 h-3 text-amber-400 ml-0.5" />}
            </button>
          </div>
        </div>

        {/* Preset Cards Grid */}
        <div className="flex-1 overflow-y-auto p-6 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          {filteredPresets.map((preset) => {
            const isSelected = currentBackground.id === preset.id;
            const isLocked = (preset.isProOnly || preset.isCustom) && !isPro;

            return (
              <div
                key={preset.id}
                onClick={() => handleSelectBackground(preset)}
                className={`group relative flex flex-col h-44 rounded-2xl overflow-hidden cursor-pointer border transition-all duration-300 text-left ${
                  isSelected
                    ? 'border-indigo-400 ring-2 ring-indigo-400/50 shadow-lg shadow-indigo-500/20'
                    : isLocked
                    ? 'border-white/10 hover:border-amber-500/40 opacity-90'
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

                {/* Locked Mask if Not Pro */}
                {isLocked && (
                  <div className="absolute inset-0 bg-slate-950/60 backdrop-blur-[1px] flex flex-col items-center justify-center p-3 text-center transition-all group-hover:bg-slate-950/45">
                    <div className="w-9 h-9 rounded-full bg-amber-500/20 text-amber-400 border border-amber-500/40 flex items-center justify-center mb-1.5 shadow-lg group-hover:scale-110 transition-transform">
                      <Lock className="w-4 h-4" />
                    </div>
                    <span className="text-xs font-bold text-amber-300">
                      Khóa gói Pro
                    </span>
                    <span className="text-[10px] text-white/60 mt-0.5">
                      Bấm để mở khóa (49k)
                    </span>
                  </div>
                )}

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
                      ? 'Ảnh tự tải'
                      : preset.type === 'video'
                      ? 'Video'
                      : preset.type === 'image'
                      ? 'Ảnh'
                      : 'Đổi màu Free'}
                  </span>

                  <div className="flex items-center gap-1.5">
                    {/* Nút xóa ảnh custom */}
                    {preset.isCustom && (
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          removeCustomBackground(preset.id);
                        }}
                        title="Xóa ảnh này"
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
                  <h3 className="text-sm font-semibold text-white group-hover:text-indigo-200 transition-colors flex items-center gap-1.5">
                    {preset.name}
                    {preset.isProOnly && (
                      <Crown className="w-3.5 h-3.5 text-amber-400 shrink-0" />
                    )}
                  </h3>
                  {preset.description && (
                    <p className="text-[11px] text-white/70 line-clamp-1 mt-0.5">
                      {preset.description}
                    </p>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Footer */}
        <div className="px-6 py-4 border-t border-white/10 flex items-center justify-between bg-white/[0.02]">
          <div className="flex items-center gap-2">
            <span className="text-xs text-white/50">
              Đang áp dụng: <span className="text-white font-medium">{currentBackground.name}</span>
            </span>
            {!isPro && (
              <button
                onClick={() => setOpenProModal(true)}
                className="hidden sm:inline-flex items-center gap-1 text-[11px] text-amber-400 hover:underline font-semibold"
              >
                &bull; Nâng cấp Pro 49k mở khóa tất cả
              </button>
            )}
          </div>
          <button
            onClick={() => setOpenBackgroundModal(false)}
            className="px-5 py-2 rounded-xl text-xs font-semibold bg-white text-slate-900 hover:bg-white/90 active:scale-95 transition-all"
          >
            Đóng
          </button>
        </div>
      </div>
    </div>
  );
};
