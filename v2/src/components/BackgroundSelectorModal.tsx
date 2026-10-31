'use client';

import React, { useState } from 'react';
import { X, Check, Film, Image as ImageIcon, Sparkles, CloudRain, Flame, Moon, Trees } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';
import { BACKGROUND_PRESETS, BackgroundItem, BackgroundType } from '@/types/background';

export const BackgroundSelectorModal: React.FC = () => {
  const { openBackgroundModal, setOpenBackgroundModal, currentBackground, setBackground } = useAudioApp();
  const [activeTab, setActiveTab] = useState<'all' | BackgroundType>('all');

  if (!openBackgroundModal) return null;

  const filteredPresets = activeTab === 'all'
    ? BACKGROUND_PRESETS
    : BACKGROUND_PRESETS.filter((bg) => bg.type === activeTab);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-md animate-in fade-in duration-200">
      <div 
        className="relative w-full max-w-4xl max-h-[85vh] flex flex-col rounded-3xl bg-slate-900/90 border border-white/10 shadow-2xl overflow-hidden backdrop-blur-xl"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-5 border-b border-white/10">
          <div>
            <h2 className="text-xl font-semibold text-white tracking-tight flex items-center gap-2">
              <Sparkles className="w-5 h-5 text-indigo-400" />
              Không gian & Hình nền
            </h2>
            <p className="text-xs text-white/60 mt-0.5">
              Chọn hiệu ứng chuyển màu sống động, ảnh phong cảnh tĩnh hoặc video chuyển động chill
            </p>
          </div>
          <button
            onClick={() => setOpenBackgroundModal(false)}
            className="p-2 text-white/50 hover:text-white rounded-full hover:bg-white/10 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Filter Tabs */}
        <div className="flex items-center gap-2 px-6 py-3 border-b border-white/5 bg-white/[0.02]">
          <button
            onClick={() => setActiveTab('all')}
            className={`px-4 py-1.5 rounded-full text-xs font-medium transition-all ${
              activeTab === 'all'
                ? 'bg-white text-slate-900 shadow-md font-semibold'
                : 'text-white/70 hover:text-white hover:bg-white/10'
            }`}
          >
            Tất cả ({BACKGROUND_PRESETS.length})
          </button>
          <button
            onClick={() => setActiveTab('video')}
            className={`flex items-center gap-1.5 px-4 py-1.5 rounded-full text-xs font-medium transition-all ${
              activeTab === 'video'
                ? 'bg-indigo-600 text-white shadow-md'
                : 'text-white/70 hover:text-white hover:bg-white/10'
            }`}
          >
            <Film className="w-3.5 h-3.5" />
            Video chuyển động
          </button>
          <button
            onClick={() => setActiveTab('image')}
            className={`flex items-center gap-1.5 px-4 py-1.5 rounded-full text-xs font-medium transition-all ${
              activeTab === 'image'
                ? 'bg-indigo-600 text-white shadow-md'
                : 'text-white/70 hover:text-white hover:bg-white/10'
            }`}
          >
            <ImageIcon className="w-3.5 h-3.5" />
            Hình ảnh Chill
          </button>
          <button
            onClick={() => setActiveTab('gradient')}
            className={`flex items-center gap-1.5 px-4 py-1.5 rounded-full text-xs font-medium transition-all ${
              activeTab === 'gradient'
                ? 'bg-indigo-600 text-white shadow-md'
                : 'text-white/70 hover:text-white hover:bg-white/10'
            }`}
          >
            <Sparkles className="w-3.5 h-3.5" />
            Chuyển màu động
          </button>
        </div>

        {/* Preset Cards Grid */}
        <div className="flex-1 overflow-y-auto p-6 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          {filteredPresets.map((preset) => {
            const isSelected = currentBackground.id === preset.id;

            return (
              <div
                key={preset.id}
                onClick={() => setBackground(preset)}
                className={`group relative flex flex-col h-44 rounded-2xl overflow-hidden cursor-pointer border transition-all duration-300 text-left ${
                  isSelected
                    ? 'border-indigo-400 ring-2 ring-indigo-400/50 shadow-lg shadow-indigo-500/20'
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
                <div className="relative p-3 flex justify-between items-start">
                  <span className="px-2 py-0.5 rounded-md text-[10px] font-medium tracking-wider uppercase backdrop-blur-md bg-black/50 text-white/90 border border-white/10 flex items-center gap-1">
                    {preset.type === 'video' && <Film className="w-3 h-3 text-sky-400" />}
                    {preset.type === 'image' && <ImageIcon className="w-3 h-3 text-emerald-400" />}
                    {preset.type === 'gradient' && <Sparkles className="w-3 h-3 text-amber-400" />}
                    {preset.type === 'video' ? 'Video' : preset.type === 'image' ? 'Ảnh' : 'Gradient'}
                  </span>

                  {isSelected && (
                    <div className="w-6 h-6 rounded-full bg-indigo-500 text-white flex items-center justify-center shadow-lg animate-in zoom-in-75 duration-200">
                      <Check className="w-3.5 h-3.5 stroke-[3]" />
                    </div>
                  )}
                </div>

                {/* Card Info at Bottom */}
                <div className="relative mt-auto p-3">
                  <h3 className="text-sm font-semibold text-white group-hover:text-indigo-200 transition-colors">
                    {preset.name}
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
          <span className="text-xs text-white/50">
            Đang áp dụng: <span className="text-white font-medium">{currentBackground.name}</span>
          </span>
          <button
            onClick={() => setOpenBackgroundModal(false)}
            className="px-5 py-2 rounded-xl text-xs font-semibold bg-white text-slate-900 hover:bg-white/90 active:scale-95 transition-all"
          >
            Xong
          </button>
        </div>
      </div>
    </div>
  );
};
