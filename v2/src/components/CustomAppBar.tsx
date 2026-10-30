'use client';

import React from 'react';
import Image from 'next/image';
import { Volume2, VolumeX, BookmarkPlus, User as UserIcon, LogOut } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';

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
  } = useAudioApp();

  const [showProfileMenu, setShowProfileMenu] = React.useState(false);
  const hasActiveSounds = Object.keys(activeSounds).length > 0;

  return (
    <header className="fixed top-0 left-0 right-0 z-40 h-16 px-6 flex items-center justify-between backdrop-blur-md bg-white/5 border-b border-white/10">
      {/* Logo */}
      <div className="flex items-center gap-3 cursor-pointer select-none">
        <Image
          src="/images/logo.png"
          alt="Ambient Flow"
          width={160}
          height={40}
          className="h-9 w-auto object-contain"
          priority
        />
      </div>

      {/* Actions */}
      <div className="flex items-center gap-4">
        {/* Bookmark Save Button */}
        <button
          onClick={() => setOpenSaveModal(true)}
          disabled={!hasActiveSounds}
          title={hasActiveSounds ? "Save current soundscape" : "Play at least one sound to bookmark"}
          className={`p-2.5 rounded-full transition-all duration-200 flex items-center justify-center ${
            hasActiveSounds
              ? 'text-white hover:bg-white/15 active:scale-95 text-white/90'
              : 'text-white/30 cursor-not-allowed'
          }`}
        >
          <BookmarkPlus className="w-5 h-5" />
        </button>

        {/* Global Volume Slider */}
        <div className="flex items-center gap-2 bg-white/10 px-3 py-1.5 rounded-full border border-white/10">
          <input
            type="range"
            min={0}
            max={100}
            value={isMuted ? 0 : globalVolume}
            onChange={(e) => setGlobalVolume(Number(e.target.value))}
            className="w-24 h-1.5 bg-white/30 rounded-lg appearance-none cursor-pointer accent-white"
          />
          <button
            onClick={toggleMute}
            className="text-white/80 hover:text-white transition-colors"
            title={isMuted ? "Unmute" : "Mute"}
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
                    Sign out
                  </button>
                </div>
              )}
            </div>
          ) : (
            <button
              onClick={signInGoogle}
              className="flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-white/10 hover:bg-white/20 border border-white/15 text-white text-xs font-medium transition-all duration-200 active:scale-95"
            >
              <UserIcon className="w-4 h-4" />
              <span>Sign in</span>
            </button>
          )}
        </div>
      </div>
    </header>
  );
};
