'use client';

import React from 'react';
import {
  CloudDrizzle,
  CloudRain,
  CloudLightning,
  Wind,
  Trees,
  Leaf,
  Waves,
  Droplets,
  Droplet,
  Flame,
  Moon,
  Coffee,
  Train,
} from 'lucide-react';
import { SoundModel } from '@/types/sound';
import { useAudioApp } from '@/context/AudioAppContext';
import { useLanguage } from '@/context/LanguageContext';

const ICON_MAP: Record<string, React.FC<{ className?: string }>> = {
  CloudDrizzle,
  CloudRain,
  CloudLightning,
  Wind,
  Trees,
  Leaf,
  Waves,
  Droplets,
  Droplet,
  Flame,
  Moon,
  Coffee,
  Train,
};

interface AudioButtonProps {
  sound: SoundModel;
}

export const AudioButton: React.FC<AudioButtonProps> = ({ sound }) => {
  const { activeSounds, toggleSound, setSoundVolume } = useAudioApp();
  const { t } = useLanguage();

  const isActive = activeSounds[sound.id] !== undefined;
  const currentVolume = activeSounds[sound.id] ?? 50;
  const IconComponent = ICON_MAP[sound.iconName] || CloudDrizzle;
  const displayName = t.sounds[sound.id] || sound.name;

  return (
    <div
      className={`relative group flex flex-col items-center justify-center p-5 rounded-3xl transition-all duration-300 border ${
        isActive
          ? 'bg-[#34475E]/60 border-white/40 shadow-lg shadow-black/20 scale-[1.02]'
          : 'bg-[#405265]/20 hover:bg-[#405265]/40 border-white/10 hover:border-white/20'
      }`}
    >
      {/* Clickable Icon Button */}
      <button
        onClick={() => toggleSound(sound.id)}
        className="flex flex-col items-center gap-3 focus:outline-none w-full"
      >
        <div
          className={`p-3.5 rounded-2xl transition-all duration-300 ${
            isActive
              ? 'bg-white/20 text-white scale-110 shadow-inner'
              : 'text-white/60 group-hover:text-white group-hover:scale-105'
          }`}
        >
          <IconComponent className="w-8 h-8" />
        </div>
        <span
          className={`text-sm font-medium tracking-wide transition-colors ${
            isActive ? 'text-white' : 'text-white/70 group-hover:text-white'
          }`}
        >
          {displayName}
        </span>
      </button>

      {/* Individual Sound Volume Slider (visible when active) */}
      <div
        className={`w-full px-2 mt-4 transition-all duration-300 ${
          isActive
            ? 'opacity-100 max-h-12 translate-y-0'
            : 'opacity-0 max-h-0 pointer-events-none translate-y-2 overflow-hidden'
        }`}
      >
        <div className="flex items-center gap-2">
          <input
            type="range"
            min={0}
            max={100}
            value={currentVolume}
            onChange={(e) => setSoundVolume(sound.id, Number(e.target.value))}
            className="w-full h-1 bg-white/20 rounded-lg appearance-none cursor-pointer accent-white hover:accent-sky-300 transition-colors"
          />
        </div>
      </div>
    </div>
  );
};
