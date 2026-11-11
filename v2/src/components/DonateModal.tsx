'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import { Coffee, X, Copy, Check, ExternalLink, Heart, QrCode, Globe, Sparkles } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';
import { useLanguage } from '@/context/LanguageContext';

export const DonateModal: React.FC = () => {
  const { openProModal, setOpenProModal } = useAudioApp();
  const { t } = useLanguage();
  const [activeTab, setActiveTab] = useState<'vietnam' | 'paypal'>('vietnam');
  const [copiedField, setCopiedField] = useState<string | null>(null);

  if (!openProModal) return null;

  const handleCopy = (text: string, fieldName: string) => {
    navigator.clipboard.writeText(text);
    setCopiedField(fieldName);
    setTimeout(() => {
      setCopiedField(null);
    }, 2000);
  };

  const paypalUrl = 'https://www.paypal.com/ncp/payment/QTU28KHNPABFE';

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="donate-modal-title"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 bg-black/80 backdrop-blur-xl animate-in fade-in duration-300"
      onClick={() => setOpenProModal(false)}
    >
      <div
        className="relative w-full max-w-2xl rounded-[32px] bg-[#0D131F]/90 border border-white/10 p-6 sm:p-10 shadow-[0_25px_70px_-15px_rgba(0,0,0,0.85)] overflow-hidden backdrop-blur-3xl text-left"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Ambient Warm Golden & Indigo Glow */}
        <div className="absolute -top-32 -right-32 w-80 h-80 bg-amber-500/15 rounded-full blur-[120px] pointer-events-none" />
        <div className="absolute -bottom-32 -left-32 w-80 h-80 bg-indigo-500/15 rounded-full blur-[120px] pointer-events-none" />

        {/* Close Button */}
        <button
          onClick={() => setOpenProModal(false)}
          aria-label={t.closeModal}
          className="absolute top-6 right-6 p-2.5 text-white/40 hover:text-white rounded-full hover:bg-white/10 transition-all duration-200"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Header - Minimalist & Elegant */}
        <div className="flex flex-col items-center text-center mb-7">
          <div className="inline-flex items-center gap-1.5 px-3.5 py-1 rounded-full bg-amber-500/10 border border-amber-500/25 text-amber-300 text-[11px] font-semibold tracking-wider uppercase mb-3">
            <Heart className="w-3 h-3 fill-amber-300 text-amber-300" />
            <span>{t.donateBadge}</span>
          </div>

          <h2 id="donate-modal-title" className="text-2xl sm:text-3xl font-bold text-white tracking-tight">
            {t.donateTitle}
          </h2>

          <p className="text-xs sm:text-sm text-white/60 font-normal max-w-md mt-2 leading-relaxed">
            {t.donateSubtitle}
          </p>
        </div>

        {/* Segmented Control Switcher */}
        <div className="flex justify-center mb-8">
          <div className="inline-flex p-1 rounded-2xl bg-white/[0.06] border border-white/10 select-none">
            <button
              onClick={() => setActiveTab('vietnam')}
              className={`flex items-center gap-2 px-5 py-2 rounded-xl text-xs sm:text-sm font-semibold transition-all duration-200 ${
                activeTab === 'vietnam'
                  ? 'bg-white/15 text-white shadow-sm border border-white/15'
                  : 'text-white/60 hover:text-white'
              }`}
            >
              <QrCode className="w-4 h-4 text-amber-300" />
              <span>{t.tabVietnam}</span>
            </button>
            <button
              onClick={() => setActiveTab('paypal')}
              className={`flex items-center gap-2 px-5 py-2 rounded-xl text-xs sm:text-sm font-semibold transition-all duration-200 ${
                activeTab === 'paypal'
                  ? 'bg-white/15 text-white shadow-sm border border-white/15'
                  : 'text-white/60 hover:text-white'
              }`}
            >
              <Globe className="w-4 h-4 text-sky-300" />
              <span>{t.tabPaypal}</span>
            </button>
          </div>
        </div>

        {/* Content Area - Spacious 2-Column Luxury Layout */}
        {activeTab === 'vietnam' && (
          <div className="flex flex-col sm:flex-row items-center gap-7 sm:gap-9 animate-in fade-in duration-200">
            {/* Left: QR Card */}
            <div className="flex flex-col items-center shrink-0">
              <div className="relative w-44 h-44 sm:w-48 sm:h-48 bg-white p-3 rounded-3xl shadow-2xl ring-1 ring-white/20 flex items-center justify-center overflow-hidden">
                <Image
                  src="/images/donate_qr_acb.jpg"
                  alt="Mã QR Chuyển khoản ACB - LE HOANG VIET"
                  width={180}
                  height={180}
                  className="rounded-2xl object-contain w-full h-full"
                  priority
                />
              </div>
              <span className="text-[11px] text-white/40 mt-3 tracking-wide">
                VietQR &bull; Napas 24/7
              </span>
            </div>

            {/* Right: Bank Details Card */}
            <div className="flex-1 w-full space-y-4">
              {/* Bank & Account */}
              <div>
                <span className="text-[11px] uppercase tracking-wider text-white/40 font-medium block mb-1">
                  {t.bankLabel}
                </span>
                <p className="text-sm sm:text-base font-semibold text-white tracking-wide">
                  ACB <span className="text-white/50 font-normal">&bull; Ngân hàng Á Châu</span>
                </p>
              </div>

              {/* Account Number with Copy */}
              <div>
                <span className="text-[11px] uppercase tracking-wider text-white/40 font-medium block mb-1">
                  {t.accountNumberLabel}
                </span>
                <div className="flex items-center justify-between gap-3 bg-white/[0.04] hover:bg-white/[0.07] border border-white/10 px-4 py-2.5 rounded-2xl transition-all">
                  <span className="font-mono font-bold text-amber-300 text-lg sm:text-xl tracking-wider">
                    221754869
                  </span>
                  <button
                    onClick={() => handleCopy('221754869', 'stk')}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-white/10 hover:bg-white/20 text-white text-xs font-semibold transition-all active:scale-95"
                    title={t.copy}
                  >
                    {copiedField === 'stk' ? (
                      <>
                        <Check className="w-3.5 h-3.5 text-emerald-400 stroke-[3]" />
                        <span className="text-emerald-400">{t.copied}</span>
                      </>
                    ) : (
                      <>
                        <Copy className="w-3.5 h-3.5" />
                        <span>{t.copy}</span>
                      </>
                    )}
                  </button>
                </div>
              </div>

              {/* Account Name */}
              <div>
                <span className="text-[11px] uppercase tracking-wider text-white/40 font-medium block mb-0.5">
                  {t.accountNameLabel}
                </span>
                <p className="text-sm font-bold text-white tracking-widest uppercase">
                  LE HOANG VIET
                </p>
              </div>

              {/* Transfer Note with Quick Copy */}
              <div className="flex items-center justify-between pt-1 text-xs">
                <span className="text-white/40">{t.noteLabel}:</span>
                <button
                  onClick={() => handleCopy('Floum coffee', 'note')}
                  className="font-mono text-white/80 hover:text-white px-2.5 py-1 rounded-lg bg-white/[0.05] hover:bg-white/10 transition-colors flex items-center gap-1"
                >
                  <span>Floum coffee</span>
                  <span className="text-[10px] text-amber-300/80 ml-1">
                    {copiedField === 'note' ? '✓' : `(${t.copy})`}
                  </span>
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Tab 2: International PayPal Layout */}
        {activeTab === 'paypal' && (
          <div className="flex flex-col sm:flex-row items-center gap-7 sm:gap-9 animate-in fade-in duration-200">
            {/* Left: PayPal QR */}
            <div className="flex flex-col items-center shrink-0">
              <div className="relative w-44 h-44 sm:w-48 sm:h-48 bg-white p-3 rounded-3xl shadow-2xl ring-1 ring-white/20 flex items-center justify-center overflow-hidden">
                <Image
                  src="/images/donate_qr_paypal.png"
                  alt="Mã QR PayPal - Buy me a coffee"
                  width={180}
                  height={180}
                  className="rounded-2xl object-contain w-full h-full"
                  priority
                />
              </div>
              <span className="text-[11px] text-white/40 mt-3 tracking-wide">
                PayPal QR &bull; Camera Scanner
              </span>
            </div>

            {/* Right: PayPal Info & Call-to-action */}
            <div className="flex-1 w-full space-y-4 text-left">
              <div>
                <span className="text-[11px] uppercase tracking-wider text-sky-400 font-semibold block mb-1">
                  {t.paypalTitle}
                </span>
                <p className="text-xs sm:text-sm text-white/70 leading-relaxed">
                  {t.paypalSubtitle}
                </p>
              </div>

              {/* Action Button */}
              <div className="pt-2">
                <a
                  href={paypalUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center justify-center gap-2.5 w-full py-3.5 px-6 rounded-2xl bg-gradient-to-r from-sky-500 to-blue-600 hover:from-sky-400 hover:to-blue-500 text-white font-bold text-sm shadow-xl shadow-sky-500/25 transition-all duration-200 hover:scale-[1.02] active:scale-95"
                >
                  <Coffee className="w-4 h-4" />
                  <span>{t.paypalBtn}</span>
                </a>
              </div>

              <div className="space-y-1 pt-1">
                <p className="text-[11px] text-white/50 flex items-center gap-1.5">
                  <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 inline-block" />
                  {t.paypalCards}
                </p>
                <p className="text-[10px] text-white/35 italic">
                  {t.paypalSecurity}
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Footer Minimalist */}
        <div className="mt-8 pt-5 border-t border-white/[0.08] flex items-center justify-between text-xs text-white/40">
          <p className="flex items-center gap-1.5">
            <Sparkles className="w-3.5 h-3.5 text-amber-400/80" />
            <span>{t.thankYou}</span>
          </p>
          <button
            onClick={() => setOpenProModal(false)}
            className="text-white/50 hover:text-white transition-colors"
          >
            {t.closeModal}
          </button>
        </div>
      </div>
    </div>
  );
};
