'use client';

import React from 'react';
import { Sparkles, X, ShieldCheck } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';

export const BottomAdBanner: React.FC = () => {
  const { isPro, setOpenProModal } = useAudioApp();
  const [closedTemporarily, setClosedTemporarily] = React.useState(false);

  // Nếu đã nâng cấp Pro hoặc tắt tạm thời trong phiên làm việc thì ẩn
  if (isPro || closedTemporarily) {
    return null;
  }

  return (
    <aside
      aria-label="Sponsor"
      className="fixed bottom-0 left-0 right-0 z-30 flex items-center justify-center border-t border-white/10 bg-slate-950/85 px-4 py-2.5 backdrop-blur-xl shadow-2xl transition-all duration-300"
    >
      <div className="flex w-full max-w-5xl items-center justify-between gap-3">
        {/* Ad Content Container (728x90 chuẩn hoặc responsive banner) */}
        <div className="flex items-center gap-3 overflow-hidden text-left">
          <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-gradient-to-tr from-amber-500/20 to-indigo-500/20 border border-white/10 text-amber-300">
            <Sparkles className="h-4 w-4" />
          </div>
          <div className="flex flex-col">
            <div className="flex items-center gap-2">
              <span className="rounded bg-white/10 px-1.5 py-0.5 text-[9px] font-semibold uppercase tracking-wider text-white/50 border border-white/5">
                Tài trợ
              </span>
              <p className="text-xs font-medium text-white/90 line-clamp-1">
                Tập trung sâu hơn với không gian âm thanh không giới hạn
              </p>
            </div>
            <p className="text-[11px] text-white/50 line-clamp-1">
              Thưởng thức phiên làm việc không bị gián đoạn cùng Ambient Flow Pro
            </p>
          </div>
        </div>

        {/* Action: Upgrade Pro to Remove Ads */}
        <div className="flex shrink-0 items-center gap-2">
          <button
            onClick={() => setOpenProModal(true)}
            className="group relative flex items-center gap-1.5 overflow-hidden rounded-full bg-gradient-to-r from-amber-500 via-orange-500 to-amber-600 px-3.5 py-1.5 text-xs font-semibold text-slate-950 shadow-lg shadow-amber-500/25 transition-all hover:scale-105 active:scale-95 hover:shadow-amber-500/40"
          >
            <Sparkles className="h-3.5 w-3.5 transition-transform group-hover:rotate-12" />
            <span>Tắt quảng cáo (49k)</span>
          </button>

          <button
            onClick={() => setClosedTemporarily(true)}
            title="Đóng tạm thời"
            className="p-1.5 text-white/40 hover:text-white rounded-full hover:bg-white/10 transition-colors"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      </div>
    </aside>
  );
};
