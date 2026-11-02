'use client';

import React, { useState } from 'react';
import { Sparkles, Check, X, ShieldCheck, QrCode, ArrowRight, Loader2 } from 'lucide-react';
import { useAudioApp } from '@/context/AudioAppContext';
import { createPayOSPaymentLink, PAYOS_CONFIG } from '@/lib/payosClient';

export const UpgradeProModal: React.FC = () => {
  const { openProModal, setOpenProModal, isPro, user } = useAudioApp();
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);

  if (!openProModal) return null;

  const handlePayOSPayment = async () => {
    setLoading(true);
    setErrorMsg(null);

    try {
      // 1. Kiểm tra cấu hình key
      if (!PAYOS_CONFIG.clientId || !PAYOS_CONFIG.apiKey || !PAYOS_CONFIG.checksumKey) {
        throw new Error(
          'Chưa điền thông tin PayOS trong file v2/.env.local (hoặc Vercel Environment Variables).'
        );
      }

      // 2. Tạo mã đơn hàng duy nhất
      const orderCode = Number(String(Date.now()).slice(-7) + Math.floor(Math.random() * 90 + 10));
      const amount = 49000; // 49.000 VNĐ
      const description = `PRO ${orderCode}`.slice(0, 25);

      const baseUrl = window.location.origin;
      const returnUrl = `${baseUrl}?payment=success&orderCode=${orderCode}`;
      const cancelUrl = `${baseUrl}?payment=cancel`;

      // 3. Gọi hàm tạo link thanh toán PayOS
      const paymentData = await createPayOSPaymentLink({
        orderCode,
        amount,
        description,
        returnUrl,
        cancelUrl,
      });

      if (paymentData?.checkoutUrl) {
        window.location.href = paymentData.checkoutUrl;
      } else {
        throw new Error('Không nhận được checkoutUrl từ PayOS');
      }
    } catch (err: any) {
      console.error(err);
      setErrorMsg(
        err?.message || 'Có lỗi xảy ra khi tạo giao dịch thanh toán.'
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-md animate-in fade-in duration-200">
      <div
        className="relative w-full max-w-lg rounded-3xl bg-slate-900/95 border border-amber-500/30 p-6 sm:p-8 shadow-2xl overflow-hidden backdrop-blur-2xl text-left"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Glow ambient background */}
        <div className="absolute -top-24 -right-24 w-60 h-60 bg-amber-500/20 rounded-full blur-[90px] pointer-events-none" />
        <div className="absolute -bottom-24 -left-24 w-60 h-60 bg-indigo-500/20 rounded-full blur-[90px] pointer-events-none" />

        {/* Close Button */}
        <button
          onClick={() => setOpenProModal(false)}
          className="absolute top-5 right-5 p-2 text-white/50 hover:text-white rounded-full hover:bg-white/10 transition-colors"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-2.5 mb-2">
          <div className="p-2 rounded-xl bg-gradient-to-tr from-amber-500 to-orange-500 text-slate-950 font-bold shadow-lg shadow-amber-500/30">
            <Sparkles className="w-5 h-5" />
          </div>
          <div>
            <span className="text-[11px] font-bold tracking-widest text-amber-400 uppercase">
              Gói Trọn Đời (Lifetime)
            </span>
            <h2 className="text-2xl font-bold text-white tracking-tight">
              Floum Pro
            </h2>
          </div>
        </div>

        <p className="text-sm text-white/70 mb-6">
          Trải nghiệm không gian tập trung tuyệt đối, hỗ trợ duy trì máy chủ và tận hưởng trọn vẹn mọi tính năng cao cấp.
        </p>

        {/* Pricing Card */}
        <div className="p-5 rounded-2xl bg-gradient-to-b from-white/10 to-white/5 border border-white/15 mb-6 shadow-inner">
          <div className="flex items-baseline justify-between">
            <div>
              <span className="text-3xl font-extrabold text-white">49.000đ</span>
              <span className="text-xs text-white/60 ml-2">/ Thanh toán 1 lần duy nhất</span>
            </div>
            <span className="px-2.5 py-1 rounded-full text-[10px] font-bold bg-amber-500/20 text-amber-300 border border-amber-500/30">
              TIẾT KIỆM 80%
            </span>
          </div>

          <hr className="my-4 border-white/10" />

          {/* Features list */}
          <ul className="space-y-3 text-xs text-white/90">
            <li className="flex items-center gap-2.5">
              <div className="w-4 h-4 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
                <Check className="w-3 h-3 stroke-[3]" />
              </div>
              <span>Mở khóa toàn bộ <strong>Video background &amp; Hình ảnh chất lượng cao</strong></span>
            </li>
            <li className="flex items-center gap-2.5">
              <div className="w-4 h-4 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
                <Check className="w-3 h-3 stroke-[3]" />
              </div>
              <span><strong>Tự do tải ảnh nền cá nhân (Upload ảnh của riêng bạn)</strong></span>
            </li>
            <li className="flex items-center gap-2.5">
              <div className="w-4 h-4 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
                <Check className="w-3 h-3 stroke-[3]" />
              </div>
              <span><strong>Tắt hoàn toàn quảng cáo</strong> (Không banner, không phân tâm)</span>
            </li>
            <li className="flex items-center gap-2.5">
              <div className="w-4 h-4 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
                <Check className="w-3 h-3 stroke-[3]" />
              </div>
              <span><strong>Không giới hạn lưu Presets</strong> và cấu hình âm thanh</span>
            </li>
            <li className="flex items-center gap-2.5">
              <div className="w-4 h-4 rounded-full bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
                <Check className="w-3 h-3 stroke-[3]" />
              </div>
              <span>Huy hiệu <strong>Pro Supporter</strong> đồng hành cùng tác giả</span>
            </li>
          </ul>
        </div>

        {/* Error notification if any */}
        {errorMsg && (
          <div className="mb-4 p-3 rounded-xl bg-red-500/20 border border-red-500/30 text-red-200 text-xs">
            {errorMsg}
          </div>
        )}

        {/* Action Button */}
        <div className="space-y-3">
          <button
            onClick={handlePayOSPayment}
            disabled={loading || isPro}
            className="w-full flex items-center justify-center gap-2 py-3.5 px-6 rounded-2xl bg-gradient-to-r from-amber-500 via-orange-500 to-amber-600 hover:from-amber-400 hover:to-orange-500 text-slate-950 font-bold text-sm shadow-xl shadow-amber-500/30 transition-all hover:scale-[1.02] active:scale-95 disabled:opacity-50 disabled:pointer-events-none"
          >
            {loading ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                <span>Đang kết nối PayOS...</span>
              </>
            ) : isPro ? (
              <>
                <ShieldCheck className="w-4 h-4 text-emerald-800" />
                <span>Bạn đã sở hữu gói Pro</span>
              </>
            ) : (
              <>
                <QrCode className="w-4 h-4" />
                <span>Thanh toán 49.000đ qua VietQR / Ngân hàng</span>
                <ArrowRight className="w-4 h-4 ml-1" />
              </>
            )}
          </button>

          <p className="text-center text-[11px] text-white/50 flex items-center justify-center gap-1.5">
            <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
            Cổng thanh toán tự động VietQR xử lý bảo mật bởi PayOS
          </p>
        </div>
      </div>
    </div>
  );
};
