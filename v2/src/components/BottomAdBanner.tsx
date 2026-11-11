'use client';

import React from 'react';
import { Coffee, X, Heart } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';

export const BottomAdBanner: React.FC = () => {
  const { setOpenProModal } = useAudioApp();
  const [closedTemporarily, setClosedTemporarily] = React.useState(false);

  // Nếu tắt tạm thời trong phiên làm việc thì ẩn
  if (closedTemporarily) {
    return null;
  }

  return (
    <aside
      aria-label="Support Floum"
      className="fixed bottom-0 left-0 right-0 z-30 flex items-center justify-center border-t border-white/10 bg-slate-950/85 px-4 py-2 backdrop-blur-xl shadow-2xl transition-all duration-300"
    >
      <div className="flex w-full max-w-5xl items-center justify-between gap-3">
        {/* Support Invitation */}
        <div className="flex items-center gap-3 overflow-hidden text-left">
          <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-xl bg-gradient-to-tr from-amber-500/20 to-orange-500/20 border border-amber-500/30 text-amber-300">
            <Coffee className="h-4 w-4" />
          </div>
          <div className="flex flex-col">
            <div className="flex items-center gap-2">
              <span className="rounded bg-amber-500/20 px-1.5 py-0.5 text-[9px] font-bold uppercase tracking-wider text-amber-300 border border-amber-500/30 flex items-center gap-1">
                <Heart className="w-2.5 h-2.5 fill-amber-300" />
                Community
              </span>
              <p className="text-xs font-medium text-white/90 line-clamp-1">
                Thích Floum? Mời tác giả một tách cà phê nhé!
              </p>
            </div>
            <p className="text-[11px] text-white/50 line-clamp-1">
              Ủng hộ máy chủ vận hành miễn phí cho cộng đồng qua VietQR hoặc PayPal
            </p>
          </div>
        </div>

        {/* Action: Open Donate Modal */}
        <div className="flex shrink-0 items-center gap-2">
          <button
            onClick={() => setOpenProModal(true)}
            className="group relative flex items-center gap-1.5 overflow-hidden rounded-full bg-gradient-to-r from-amber-500 via-orange-500 to-amber-600 px-3.5 py-1.5 text-xs font-bold text-slate-950 shadow-lg shadow-amber-500/25 transition-all hover:scale-105 active:scale-95 hover:shadow-amber-500/40"
          >
            <Coffee className="h-3.5 w-3.5 fill-slate-950 transition-transform group-hover:rotate-12" />
            <span>Mời cà phê</span>
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
