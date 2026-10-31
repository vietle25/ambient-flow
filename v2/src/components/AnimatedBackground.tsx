'use client';

import React, { useState, useEffect } from 'react';
import { useAudioApp } from '@/context/AudioAppContext';

// Danh sách gradient cycling mượt mà khi người dùng chọn chế độ Dynamic Gradient
export const GRADIENT_PALETTES = [
  'linear-gradient(to bottom, #0F172A, #1E293B)', // midnightBlue
  'linear-gradient(to bottom, #1E3A8A, #1E40AF)', // navyBlue
  'linear-gradient(to bottom, #0C4A6E, #1E3A8A)', // deepCosmicBlue
  'linear-gradient(to bottom, #0F172A, #134E4A)', // midnightOcean
  'linear-gradient(to bottom, #134E4A, #0C4A6E)', // abyssalBlueGreen
  'linear-gradient(to bottom, #0C4A6E, #0369A1)', // deepOceanBlue
  'linear-gradient(to bottom, #134E4A, #155E63)', // darkTeal
  'linear-gradient(to bottom, #064E3B, #14532D)', // auroraGreen
  'linear-gradient(to bottom, #14532D, #166534)', // forestGreen
  'linear-gradient(to bottom, #064E3B, #065F46)', // deepEmerald
  'linear-gradient(to bottom, #4C1D95, #5B21B6)', // deepViolet
  'linear-gradient(to bottom, #581C87, #6B21A8)', // eggplantPurple
  'linear-gradient(to bottom, #6D28D9, #581C87)', // duskPurple
  'linear-gradient(to bottom, #312E81, #3730A3)', // deepIndigo
  'linear-gradient(to bottom, #451A03, #92400E)', // darkChocolate
  'linear-gradient(to bottom, #7C2D12, #B91C1C)', // deepMahogany
  'linear-gradient(to bottom, #78350F, #B45309)', // espressoBrown
  'linear-gradient(to bottom, #EA580C, #DC2626)', // burntSienna
  'linear-gradient(to bottom, #1F2937, #374151)', // gunmetalGray
  'linear-gradient(to bottom, #334155, #475569)', // slateGray
  'linear-gradient(to bottom, #0F172A, #1E293B)', // stormGray
];

export const AnimatedBackground: React.FC = () => {
  const { currentBackground } = useAudioApp();

  // Gradient cycling state
  const [currentIdx, setCurrentIdx] = useState(0);
  const [nextIdx, setNextIdx] = useState(1);
  const [transitioning, setTransitioning] = useState(false);

  useEffect(() => {
    if (currentBackground.type !== 'gradient') return;

    // Chuyển màu êm ả mỗi 18 giây với hiệu ứng 6 giây mượt mà
    const interval = setInterval(() => {
      setNextIdx((prevNext) => {
        setTransitioning(true);
        setTimeout(() => {
          setCurrentIdx(prevNext);
          setTransitioning(false);
        }, 6000);
        return (prevNext + 1) % GRADIENT_PALETTES.length;
      });
    }, 18000);

    return () => clearInterval(interval);
  }, [currentBackground.type]);

  return (
    <div className="fixed inset-0 -z-10 overflow-hidden pointer-events-none select-none bg-slate-950">
      {/* 1. Gradient Mode */}
      {currentBackground.type === 'gradient' && (
        <>
          <div
            className="absolute inset-0"
            style={{
              background: GRADIENT_PALETTES[currentIdx],
            }}
          />
          <div
            className="absolute inset-0 transition-opacity duration-[6000ms] ease-in-out"
            style={{
              background: GRADIENT_PALETTES[nextIdx],
              opacity: transitioning ? 1 : 0,
            }}
          />
        </>
      )}

      {/* 2. Image Mode */}
      {currentBackground.type === 'image' && (
        <div
          key={currentBackground.value}
          className="absolute inset-0 bg-cover bg-center bg-no-repeat transition-all duration-1000 ease-out transform scale-105"
          style={{
            backgroundImage: `url('${currentBackground.value}')`,
          }}
        />
      )}

      {/* 3. Video Mode */}
      {currentBackground.type === 'video' && (
        <video
          key={currentBackground.value}
          autoPlay
          loop
          muted
          playsInline
          className="absolute inset-0 w-full h-full object-cover transition-opacity duration-1000 ease-in-out"
        >
          <source src={currentBackground.value} type="video/mp4" />
        </video>
      )}

      {/* Dark overlay để giữ độ tương phản cao, làm nổi bật sound cards và thanh điều khiển */}
      <div className="absolute inset-0 bg-slate-950/45 backdrop-blur-[2px] transition-colors duration-700" />
      <div className="absolute inset-0 bg-gradient-to-t from-slate-950/80 via-transparent to-slate-950/60 pointer-events-none" />

      {/* Ambient Lighting Orbs */}
      <div className="absolute -top-32 -left-32 w-[550px] h-[550px] bg-sky-500/10 rounded-full blur-[140px] pointer-events-none" />
      <div className="absolute -bottom-32 -right-32 w-[600px] h-[600px] bg-indigo-500/10 rounded-full blur-[160px] pointer-events-none" />
    </div>
  );
};
