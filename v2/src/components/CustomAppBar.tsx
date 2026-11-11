'use client';

import React from 'react';
import Image from 'next/image';
import { Volume2, VolumeX, BookmarkPlus, User as UserIcon, LogOut, Wallpaper, Coffee, Languages } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';
import { useLanguage } from '@/context/LanguageContext';
import { AppLogo } from '@/components/AppLogo';

export const CustomAppBar: React.FC = () => {
  const {
    user,
    authLoading,
    signInGoogle,
    signOut,
    globalVolume,
    isMuted,
    setGlobalVolume,
    toggleMute,
    activeSounds,
    setOpenSaveModal,
    setOpenBackgroundModal,
    setOpenProModal,
  } = useAudioApp();

  const { language, toggleLanguage, t } = useLanguage();

  const [showProfileMenu, setShowProfileMenu] = React.useState(false);
  const hasActiveSounds = Object.keys(activeSounds).length > 0;

  return (
    <header className="fixed top-0 left-0 right-0 z-40 h-16 px-4 sm:px-6 flex items-center justify-between bg-gradient-to-b from-black/60 via-black/20 to-transparent backdrop-blur-sm border-b border-white/5 transition-all duration-300">
      {/* Brand Logo */}
      <AppLogo size="md" />

      {/* Actions */}
      <div className="flex items-center gap-2 sm:gap-3.5">
        {/* Language Switcher Button */}
        <button
          onClick={toggleLanguage}
          title={t.languageToggleTitle}
          aria-label={t.languageToggleTitle}
          className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-full bg-white/10 hover:bg-white/20 border border-white/15 text-xs font-semibold text-white transition-all duration-200 active:scale-95"
        >
          <Languages className="w-3.5 h-3.5 text-indigo-300" />
          <span className="text-[11px] font-bold tracking-wider">{language === 'vi' ? '🇻🇳 VI' : '🇬🇧 EN'}</span>
        </button>

        {/* Buy Me a Coffee / Donate Button */}
        <button
          onClick={() => setOpenProModal(true)}
          title={t.buyMeCoffeeTitle}
          className="flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-semibold bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-400 hover:to-orange-400 text-slate-950 shadow-md shadow-amber-500/20 transition-all hover:scale-105 active:scale-95"
        >
          <Coffee className="w-3.5 h-3.5 fill-slate-950" />
          <span className="hidden sm:inline">{t.buyMeCoffee}</span>
          <span className="sm:hidden">{t.buyMeCoffeeShort}</span>
        </button>

        {/* Change Background Button */}
        <button
          onClick={() => setOpenBackgroundModal(true)}
          title={t.changeBgTitle}
          aria-label={t.changeBgTitle}
          className="p-2 sm:p-2.5 rounded-full transition-all duration-200 flex items-center justify-center text-white/90 hover:bg-white/15 active:scale-95"
        >
          <Wallpaper className="w-5 h-5 text-indigo-300 hover:text-white transition-colors" />
        </button>

        {/* Bookmark Save Button */}
        <button
          onClick={() => setOpenSaveModal(true)}
          disabled={!hasActiveSounds}
          title={hasActiveSounds ? t.saveSoundscapeActive : t.saveSoundscapeInactive}
          aria-label={hasActiveSounds ? t.saveSoundscapeActive : t.saveSoundscapeInactive}
          className={`p-2 sm:p-2.5 rounded-full transition-all duration-200 flex items-center justify-center ${
            hasActiveSounds
              ? 'text-white hover:bg-white/15 active:scale-95 text-white/90'
              : 'text-white/30 cursor-not-allowed'
          }`}
        >
          <BookmarkPlus className="w-5 h-5" />
        </button>

        {/* Global Volume Slider */}
        <div className="flex items-center gap-1.5 sm:gap-2 bg-white/10 px-2.5 sm:px-3 py-1.5 rounded-full border border-white/10">
          <input
            type="range"
            min={0}
            max={100}
            value={isMuted ? 0 : globalVolume}
            onChange={(e) => setGlobalVolume(Number(e.target.value))}
            className="w-16 sm:w-24 h-1.5 bg-white/30 rounded-lg appearance-none cursor-pointer accent-white"
          />
          <button
            onClick={toggleMute}
            className="text-white/80 hover:text-white transition-colors"
            title={isMuted ? t.unmute : t.mute}
            aria-label={isMuted ? t.unmute : t.mute}
          >
            {isMuted || globalVolume === 0 ? (
              <VolumeX className="w-4 h-4 text-red-400" />
            ) : (
              <Volume2 className="w-4 h-4" />
            )}
          </button>
        </div>

        {/* Auth / Profile Button */}
        <div className="relative">
          {authLoading ? (
            <div className="w-8 h-8 rounded-full border-2 border-white/20 border-t-white animate-spin" />
          ) : user ? (
            <div>
              <button
                onClick={() => setShowProfileMenu((prev) => !prev)}
                className="flex items-center focus:outline-none"
              >
                {user.photoURL ? (
                  <Image
                    src={user.photoURL}
                    alt={user.displayName || 'User'}
                    width={32}
                    height={32}
                    className="w-8 h-8 rounded-full border border-white/30 object-cover"
                  />
                ) : (
                  <div className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center text-white border border-white/30">
                    <UserIcon className="w-4 h-4" />
                  </div>
                )}
              </button>

              {/* Profile Dropdown */}
              {showProfileMenu && (
                <div
                  className="absolute right-0 mt-2 w-56 rounded-xl bg-slate-900/90 backdrop-blur-xl border border-white/15 shadow-2xl py-2 z-50 text-white animate-in fade-in zoom-in-95 duration-100"
                  onClick={() => setShowProfileMenu(false)}
                >
                  <div className="px-4 py-2 border-b border-white/10">
                    <p className="text-sm font-semibold truncate text-white">{user.displayName || 'User'}</p>
                    <p className="text-xs text-white/60 truncate">{user.email}</p>
                  </div>
                  <button
                    onClick={signOut}
                    className="w-full px-4 py-2 text-left text-sm text-red-300 hover:bg-white/10 flex items-center gap-2 transition-colors"
                  >
                    <LogOut className="w-4 h-4" />
                    {t.signOut}
                  </button>
                </div>
              )}
            </div>
          ) : (
            <button
              onClick={signInGoogle}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-medium transition-all duration-200 active:scale-95"
            >
              <UserIcon className="w-3.5 h-3.5" />
              <span className="hidden sm:inline">{t.signIn}</span>
            </button>
          )}
        </div>
      </div>
    </header>
  );
};
