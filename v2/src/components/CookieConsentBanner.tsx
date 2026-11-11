'use client';

import React, { useState, useEffect } from 'react';
import { useLanguage } from '@/context/LanguageContext';

const CONSENT_KEY = 'ambient_flow_cookie_consent';

export const CookieConsentBanner: React.FC = () => {
  const [show, setShow] = useState(false);
  const { t } = useLanguage();

  useEffect(() => {
    const consent = localStorage.getItem(CONSENT_KEY);
    if (!consent) {
      setShow(true);
    }
  }, []);

  const handleConsent = (accepted: boolean) => {
    localStorage.setItem(CONSENT_KEY, accepted ? 'accepted' : 'declined');
    setShow(false);
  };

  if (!show) return null;

  return (
    <div className="fixed bottom-0 inset-x-0 z-50 p-4 bg-slate-900/90 backdrop-blur-md border-t border-white/10 text-white">
      <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-4">
        <p className="text-sm text-white/80 text-center sm:text-left">
          {t.cookieText}
        </p>
        <div className="flex items-center gap-3">
          <button
            onClick={() => handleConsent(false)}
            className="px-4 py-2 rounded-xl text-xs font-medium text-white/70 hover:text-white hover:bg-white/10 transition-colors"
          >
            {t.cookieDecline}
          </button>
          <button
            onClick={() => handleConsent(true)}
            className="px-5 py-2 rounded-xl text-xs font-semibold bg-white text-slate-950 hover:bg-white/90 active:scale-95 transition-all shadow-md"
          >
            {t.cookieAccept}
          </button>
        </div>
      </div>
    </div>
  );
};
