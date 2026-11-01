'use client';

import React, { useState, useEffect } from 'react';
import { AudioAppProvider, useAudioApp } from '@/context/AudioAppContext';
import { CustomAppBar } from '@/components/CustomAppBar';
import { AudioButton } from '@/components/AudioButton';
import { VerticalBookmarkList } from '@/components/VerticalBookmarkList';
import { SaveBookmarkModal } from '@/components/SaveBookmarkModal';
import { BackgroundSelectorModal } from '@/components/BackgroundSelectorModal';
import { UpgradeProModal } from '@/components/UpgradeProModal';
import { BottomAdBanner } from '@/components/BottomAdBanner';
import { AnimatedBackground } from '@/components/AnimatedBackground';
import { CookieConsentBanner } from '@/components/CookieConsentBanner';
import { SOUNDS } from '@/types/sound';

type CategoryFilter = 'all' | 'weather' | 'nature' | 'ambience';

function AppContent() {
  const [selectedCategory, setSelectedCategory] = useState<CategoryFilter>('all');
  const { setProStatus } = useAudioApp();

  // Kiểm tra callback sau khi PayOS thanh toán thành công chuyển hướng về: ?payment=success&orderCode=...
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const urlParams = new URLSearchParams(window.location.search);
      const paymentStatus = urlParams.get('payment');
      const orderCode = urlParams.get('orderCode');

      if (paymentStatus === 'success') {
        setProStatus(true);
        // Xóa query param trên thanh URL cho sạch sẽ
        window.history.replaceState({}, document.title, window.location.pathname);
        alert('🎉 Chúc mừng bạn đã nâng cấp thành công gói Floum Pro! Toàn bộ quảng cáo đã được tắt vĩnh viễn.');
      }
    }
  }, [setProStatus]);

  const filteredSounds = selectedCategory === 'all'
    ? SOUNDS
    : SOUNDS.filter((s) => s.category === selectedCategory);

  return (
    <main className="relative min-h-screen flex flex-col justify-between overflow-x-hidden">
      {/* Animated Background */}
      <AnimatedBackground />

      {/* Top Navbar */}
      <CustomAppBar />

      {/* Content Container */}
      <div className="pt-24 pb-28 px-6 max-w-5xl mx-auto w-full flex flex-col items-center">
        {/* Category Filter Tabs */}
        <div className="flex items-center gap-2 p-1.5 rounded-2xl bg-white/10 backdrop-blur-md border border-white/15 mb-10 select-none">
          {(['all', 'weather', 'nature', 'ambience'] as CategoryFilter[]).map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-5 py-2 rounded-xl text-xs font-semibold capitalize transition-all duration-200 ${
                selectedCategory === cat
                  ? 'bg-white text-slate-900 shadow-md scale-105'
                  : 'text-white/70 hover:text-white hover:bg-white/10'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>

        {/* Sound Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4 sm:gap-6 w-full">
          {filteredSounds.map((sound) => (
            <AudioButton key={sound.id} sound={sound} />
          ))}
        </div>
      </div>

      {/* Vertical Bookmark Sidebar */}
      <VerticalBookmarkList />

      {/* Save Bookmark Dialog */}
      <SaveBookmarkModal />

      {/* Background Selector Modal */}
      <BackgroundSelectorModal />

      {/* Upgrade Pro Modal */}
      <UpgradeProModal />

      {/* Bottom Ad / Sponsor Banner */}
      <BottomAdBanner />

      {/* Cookie Consent */}
      <CookieConsentBanner />
    </main>
  );
}

export default function HomePage() {
  return (
    <AudioAppProvider>
      <AppContent />
    </AudioAppProvider>
  );
}

