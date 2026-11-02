import { NextResponse } from 'next/server';
import { getPayOS } from '@/lib/payosServer';

export async function POST(req: Request) {
  try {
    const payos = getPayOS();
    if (!payos) {
      return NextResponse.json(
        {
          error:
            'Chưa cấu hình PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY trên Server / Vercel Environment Variables',
        },
        { status: 500 }
      );
    }

    const body = await req.json();
    const { email } = body || {};

    // Order code là số nguyên dương duy nhất
    const orderCode = Number(String(Date.now()).slice(-7) + Math.floor(Math.random() * 90 + 10));
    const amount = 49000; // 49.000 VNĐ
    const description = `PRO ${orderCode}`.slice(0, 25);

    // Xác định origin từ request header
    const origin = req.headers.get('origin') || 'https://ambient-flow.vercel.app';
    const returnUrl = `${origin}?payment=success&orderCode=${orderCode}`;
    const cancelUrl = `${origin}?payment=cancel`;

    const paymentLinkRes = await payos.paymentRequests.create({
      orderCode,
      amount,
      description,
      returnUrl,
      cancelUrl,
      buyerEmail: email || undefined,
    });

    return NextResponse.json({
      success: true,
      checkoutUrl: paymentLinkRes.checkoutUrl,
      qrCode: paymentLinkRes.qrCode,
      orderCode,
      amount,
    });
  } catch (error: any) {
    console.error('Lỗi tạo link thanh toán PayOS Server:', error);
    return NextResponse.json(
      { error: error?.message || 'Không thể tạo link thanh toán' },
      { status: 500 }
    );
  }
}
