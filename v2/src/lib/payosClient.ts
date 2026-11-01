import { createCryptoProvider } from '@payos/node/lib/crypto';

// Đọc cấu hình từ biến môi trường NEXT_PUBLIC
export const PAYOS_CONFIG = {
  clientId: process.env.NEXT_PUBLIC_PAYOS_CLIENT_ID || '',
  apiKey: process.env.NEXT_PUBLIC_PAYOS_API_KEY || '',
  checksumKey: process.env.NEXT_PUBLIC_PAYOS_CHECKSUM_KEY || '',
};

export interface CreatePaymentLinkParams {
  orderCode: number;
  amount: number;
  description: string;
  cancelUrl: string;
  returnUrl: string;
}

export interface PaymentLinkResponse {
  bin: string;
  accountNumber: string;
  accountName: string;
  amount: number;
  description: string;
  orderCode: number;
  currency: string;
  paymentLinkId: string;
  status: string;
  checkoutUrl: string;
  qrCode: string;
}

/**
 * Tạo link thanh toán trực tiếp qua PayOS Open API
 */
export async function createPayOSPaymentLink(
  params: CreatePaymentLinkParams
): Promise<PaymentLinkResponse> {
  const { clientId, apiKey, checksumKey } = PAYOS_CONFIG;

  if (!clientId || !apiKey || !checksumKey) {
    throw new Error(
      'Chưa cấu hình NEXT_PUBLIC_PAYOS_CLIENT_ID, NEXT_PUBLIC_PAYOS_API_KEY, hoặc NEXT_PUBLIC_PAYOS_CHECKSUM_KEY trong file .env.local'
    );
  }

  // 1. Tạo chữ ký bảo mật signature theo chuẩn PayOS
  const cryptoProvider = createCryptoProvider('browser');
  const signature = await cryptoProvider.createSignatureOfPaymentRequest(params, checksumKey);

  if (!signature) {
    throw new Error('Không thể tạo chữ ký số cho giao dịch PayOS');
  }

  // 2. Gửi request trực tiếp tới API Merchant của PayOS
  const response = await fetch('https://api-merchant.payos.vn/v2/payment-requests', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-client-id': clientId,
      'x-api-key': apiKey,
    },
    body: JSON.stringify({
      ...params,
      signature,
    }),
  });

  const resData = await response.json();

  if (!response.ok || resData.code !== '00') {
    throw new Error(resData.desc || 'Lỗi khi tạo liên kết thanh toán PayOS');
  }

  return resData.data;
}
