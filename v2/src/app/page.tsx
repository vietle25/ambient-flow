'use client';

import React, { useState, useEffect } from 'react';
import { AudioAppProvider, useAudioApp } from '@/context/AudioAppContext';
import { LanguageProvider, useLanguage } from '@/context/LanguageContext';
import { CustomAppBar } from '@/components/CustomAppBar';
import { AudioButton } from '@/components/AudioButton';
import { VerticalBookmarkList } from '@/components/VerticalBookmarkList';
import { SaveBookmarkModal } from '@/components/SaveBookmarkModal';
import { BackgroundSelectorModal } from '@/components/BackgroundSelectorModal';
import { DonateModal } from '@/components/DonateModal';
import { BottomAdBanner } from '@/components/BottomAdBanner';
import { AnimatedBackground } from '@/components/AnimatedBackground';
import { CookieConsentBanner } from '@/components/CookieConsentBanner';
import { SOUNDS } from '@/types/sound';

type CategoryFilter = 'all' | 'weather' | 'nature' | 'ambience';

function AppContent() {
  const [selectedCategory, setSelectedCategory] = useState<CategoryFilter>('all');
  const { setProStatus } = useAudioApp();
  const { t } = useLanguage();

  // Kiểm tra callback nếu có query param cũ ?payment=success&orderCode=...
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const urlParams = new URLSearchParams(window.location.search);
      const paymentStatus = urlParams.get('payment');

      if (paymentStatus === 'success') {
        setProStatus(true);
        window.history.replaceState({}, document.title, window.location.pathname);
        alert(t.alertThanks);
      }
    }
  }, [setProStatus, t.alertThanks]);

  const filteredSounds = selectedCategory === 'all'
    ? SOUNDS
    : SOUNDS.filter((s) => s.category === selectedCategory);

  const categoryLabels: Record<CategoryFilter, string> = {
    all: t.all,
    weather: t.weather,
    nature: t.nature,
    ambience: t.ambience,
  };

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
              {categoryLabels[cat]}
            </button>
          ))}
        </div>

        {/* Sound Buttons Grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-4 gap-4 w-full">
          {filteredSounds.map((sound) => (
            <AudioButton key={sound.id} sound={sound} />
          ))}
        </div>
      </div>

      {/* Vertical Bookmarks Floating Bar */}
      <VerticalBookmarkList />

      {/* Modals & Banners */}
      <SaveBookmarkModal />
      <BackgroundSelectorModal />
      <DonateModal />
      <BottomAdBanner />
      <CookieConsentBanner />
    </main>
  );
}

export default function Home() {
  return (
    <LanguageProvider>
      <AudioAppProvider>
        <AppContent />
      </AudioAppProvider>
    </LanguageProvider>
  );
}
