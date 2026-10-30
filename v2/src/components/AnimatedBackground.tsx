'use client';

import React, { useState, useEffect } from 'react';

// Danh sách các gradient cao cấp lấy trực tiếp từ thiết kế Flutter gốc của bạn
export const GRADIENT_PALETTES = [
  // Deep Blues & Space
  'linear-gradient(to bottom, #0F172A, #1E293B)', // midnightBlue
  'linear-gradient(to bottom, #1E3A8A, #1E40AF)', // navyBlue
  'linear-gradient(to bottom, #0C4A6E, #1E3A8A)', // deepCosmicBlue
  'linear-gradient(to bottom, #0F172A, #134E4A)', // midnightOcean

  // Dark Ocean & Teals
  'linear-gradient(to bottom, #134E4A, #0C4A6E)', // abyssalBlueGreen
  'linear-gradient(to bottom, #0C4A6E, #0369A1)', // deepOceanBlue
  'linear-gradient(to bottom, #134E4A, #155E63)', // darkTeal

  // Forest & Emerald Greens
  'linear-gradient(to bottom, #064E3B, #14532D)', // auroraGreen
  'linear-gradient(to bottom, #14532D, #166534)', // forestGreen
  'linear-gradient(to bottom, #064E3B, #065F46)', // deepEmerald

  // Purples & Violets
  'linear-gradient(to bottom, #4C1D95, #5B21B6)', // deepViolet
  'linear-gradient(to bottom, #581C87, #6B21A8)', // eggplantPurple
  'linear-gradient(to bottom, #6D28D9, #581C87)', // duskPurple
  'linear-gradient(to bottom, #312E81, #3730A3)', // deepIndigo

  // Warm Browns & Amber Nights
  'linear-gradient(to bottom, #451A03, #92400E)', // darkChocolate
  'linear-gradient(to bottom, #7C2D12, #B91C1C)', // deepMahogany
  'linear-gradient(to bottom, #78350F, #B45309)', // espressoBrown
  'linear-gradient(to bottom, #EA580C, #DC2626)', // burntSienna

  // Charcoal & Storm Grays
  'linear-gradient(to bottom, #1F2937, #374151)', // gunmetalGray
  'linear-gradient(to bottom, #334155, #475569)', // slateGray
  'linear-gradient(to bottom, #0F172A, #1E293B)', // stormGray
];

export const AnimatedBackground: React.FC = () => {
  const [currentIdx, setCurrentIdx] = useState(0);
  const [nextIdx, setNextIdx] = useState(1);
  const [transitioning, setTransitioning] = useState(false);

  useEffect(() => {
    // Cứ mỗi 16 giây sẽ bắt đầu chuyển màu
    const interval = setInterval(() => {
      setNextIdx((prevNext) => {
        setTransitioning(true);
        // Sau khi hoàn thành thời gian chuyển đổi (6 giây mượt mà), gán màu mới làm nền chính
        setTimeout(() => {
          setCurrentIdx(prevNext);
          setTransitioning(false);
        }, 6000);

        return (prevNext + 1) % GRADIENT_PALETTES.length;
      });
    }, 18000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="fixed inset-0 -z-10 overflow-hidden pointer-events-none select-none">
      {/* Lớp nền hiện tại (Base Layer) */}
      <div
        className="absolute inset-0"
        style={{
          background: GRADIENT_PALETTES[currentIdx],
        }}
      />

      {/* Lớp nền kế tiếp với hiệu ứng Cross-fade mờ dần từ từ (6s) */}
      <div
        className="absolute inset-0 transition-opacity duration-[6000ms] ease-in-out"
        style={{
          background: GRADIENT_PALETTES[nextIdx],
          opacity: transitioning ? 1 : 0,
        }}
      />

      {/* Các quầng sáng mềm mại tăng thêm độ sâu không gian */}
      <div className="absolute -top-32 -left-32 w-[550px] h-[550px] bg-sky-500/10 rounded-full blur-[120px] pointer-events-none" />
      <div className="absolute -bottom-32 -right-32 w-[600px] h-[600px] bg-indigo-500/10 rounded-full blur-[140px] pointer-events-none" />
    </div>
  );
};
