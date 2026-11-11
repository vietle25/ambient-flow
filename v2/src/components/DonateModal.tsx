'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import { Coffee, X, Copy, Check, ExternalLink, Heart, Globe, QrCode } from 'lucide-react';
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
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/75 backdrop-blur-md animate-in fade-in duration-200"
      onClick={() => setOpenProModal(false)}
    >
      <div
        className="relative w-full max-w-lg rounded-3xl bg-slate-900/95 border border-amber-500/30 p-6 sm:p-8 shadow-2xl overflow-hidden backdrop-blur-2xl text-left"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Glow ambient background effects */}
        <div className="absolute -top-24 -right-24 w-60 h-60 bg-amber-500/20 rounded-full blur-[90px] pointer-events-none" />
        <div className="absolute -bottom-24 -left-24 w-60 h-60 bg-sky-500/15 rounded-full blur-[90px] pointer-events-none" />

        {/* Close Button */}
        <button
          onClick={() => setOpenProModal(false)}
          aria-label={t.closeModal}
          className="absolute top-5 right-5 p-2 text-white/50 hover:text-white rounded-full hover:bg-white/10 transition-colors"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-3 mb-2">
          <div className="p-2.5 rounded-2xl bg-gradient-to-tr from-amber-500 to-orange-500 text-slate-950 font-bold shadow-lg shadow-amber-500/30">
            <Coffee className="w-6 h-6" />
          </div>
          <div>
            <span className="text-[11px] font-bold tracking-widest text-amber-400 uppercase flex items-center gap-1">
              <Heart className="w-3 h-3 fill-amber-400 text-amber-400" />
              {t.donateBadge}
            </span>
            <h2 id="donate-modal-title" className="text-xl sm:text-2xl font-bold text-white tracking-tight">
              {t.donateTitle}
            </h2>
          </div>
        </div>

        {/* Subtitle */}
        <div className="mb-6 space-y-1 text-xs sm:text-sm text-white/70">
          <p>{t.donateSubtitle}</p>
        </div>

        {/* Option Tabs (Vietnam QR vs International PayPal QR) */}
        <div className="flex p-1 rounded-2xl bg-white/10 border border-white/10 mb-6 select-none">
          <button
            onClick={() => setActiveTab('vietnam')}
            className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition-all duration-200 ${
              activeTab === 'vietnam'
                ? 'bg-amber-500 text-slate-950 shadow-md font-bold'
                : 'text-white/70 hover:text-white'
            }`}
          >
            <QrCode className="w-4 h-4" />
            <span>{t.tabVietnam}</span>
          </button>
          <button
            onClick={() => setActiveTab('paypal')}
            className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition-all duration-200 ${
              activeTab === 'paypal'
                ? 'bg-sky-500 text-white shadow-md font-bold'
                : 'text-white/70 hover:text-white'
            }`}
          >
            <Globe className="w-4 h-4" />
            <span>{t.tabPaypal}</span>
          </button>
        </div>

        {/* Tab 1: Vietnam Bank QR */}
        {activeTab === 'vietnam' && (
          <div className="space-y-4 animate-in fade-in duration-150">
            <div className="flex flex-col sm:flex-row items-center gap-5 p-4 rounded-2xl bg-white/5 border border-white/10">
              {/* QR Image */}
              <div className="relative w-40 h-40 shrink-0 bg-white p-2 rounded-2xl shadow-lg flex items-center justify-center overflow-hidden">
                <Image
                  src="/images/donate_qr_acb.jpg"
                  alt="Mã QR Chuyển khoản ACB - LE HOANG VIET"
                  width={150}
                  height={150}
                  className="rounded-xl object-contain w-full h-full"
                  priority
                />
              </div>

              {/* Bank Info */}
              <div className="flex-1 w-full space-y-2 text-xs sm:text-sm">
                <div>
                  <span className="text-white/50 text-[11px] block">{t.bankLabel}</span>
                  <span className="font-semibold text-white">ACB (Ngân hàng TMCP Á Châu)</span>
                </div>

                <div>
                  <span className="text-white/50 text-[11px] block">{t.accountNumberLabel}</span>
                  <div className="flex items-center justify-between bg-white/10 px-3 py-1.5 rounded-xl mt-0.5">
                    <span className="font-mono font-bold text-amber-300 text-base">221754869</span>
                    <button
                      onClick={() => handleCopy('221754869', 'stk')}
                      className="flex items-center gap-1 text-[11px] px-2 py-1 rounded-lg bg-white/10 hover:bg-white/20 text-white transition-colors"
                      title={t.copy}
                    >
                      {copiedField === 'stk' ? (
                        <>
                          <Check className="w-3.5 h-3.5 text-emerald-400" />
                          <span className="text-emerald-400 font-medium">{t.copied}</span>
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

                <div>
                  <span className="text-white/50 text-[11px] block">{t.accountNameLabel}</span>
                  <span className="font-bold text-white tracking-wide">LE HOANG VIET</span>
                </div>

                <div>
                  <span className="text-white/50 text-[11px] block">{t.noteLabel}</span>
                  <div className="flex items-center justify-between bg-white/10 px-3 py-1 rounded-xl mt-0.5">
                    <span className="font-mono text-white/90 text-xs">Floum coffee</span>
                    <button
                      onClick={() => handleCopy('Floum coffee', 'note')}
                      className="text-[11px] text-white/70 hover:text-white transition-colors"
                    >
                      {copiedField === 'note' ? '✓' : t.copy}
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <p className="text-[11px] text-center text-white/50">
              {t.scanHint}
            </p>
          </div>
        )}

        {/* Tab 2: PayPal International with QR Code */}
        {activeTab === 'paypal' && (
          <div className="space-y-4 animate-in fade-in duration-150">
            <div className="flex flex-col sm:flex-row items-center gap-5 p-4 rounded-2xl bg-sky-500/10 border border-sky-500/20">
              {/* PayPal QR Image */}
              <div className="relative w-40 h-40 shrink-0 bg-white p-2 rounded-2xl shadow-lg flex items-center justify-center overflow-hidden">
                <Image
                  src="/images/donate_qr_paypal.png"
                  alt="Mã QR PayPal - Buy me a coffee"
                  width={150}
                  height={150}
                  className="rounded-xl object-contain w-full h-full"
                  priority
                />
              </div>

              {/* PayPal Info & Actions */}
              <div className="flex-1 w-full space-y-2.5 text-xs sm:text-sm text-left">
                <div>
                  <span className="text-sky-300 font-bold text-sm block">{t.paypalTitle}</span>
                  <p className="text-white/70 text-xs mt-0.5">
                    {t.paypalSubtitle}
                  </p>
                </div>

                <div className="pt-1">
                  <a
                    href={paypalUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center justify-center gap-2 w-full py-2.5 px-4 rounded-xl bg-gradient-to-r from-sky-500 to-blue-600 hover:from-sky-400 hover:to-blue-500 text-white font-bold text-xs shadow-lg shadow-sky-500/20 transition-all hover:scale-[1.02] active:scale-95"
                  >
                    <Coffee className="w-3.5 h-3.5" />
                    <span>{t.paypalBtn}</span>
                  </a>
                </div>

                <p className="text-[10px] text-white/50">
                  {t.paypalCards}
                </p>
              </div>
            </div>

            <p className="text-[11px] text-center text-white/50">
              {t.paypalSecurity}
            </p>
          </div>
        )}

        {/* Footer Thanks */}
        <div className="mt-6 pt-4 border-t border-white/10 flex items-center justify-between text-xs text-white/50">
          <span className="flex items-center gap-1">
            <Heart className="w-3.5 h-3.5 text-rose-400 fill-rose-400" />
            {t.thankYou}
          </span>
          <button
            onClick={() => setOpenProModal(false)}
            className="text-white/60 hover:text-white underline underline-offset-4"
          >
            {t.closeModal}
          </button>
        </div>
      </div>
    </div>
  );
};
