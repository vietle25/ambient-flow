const { PayOS } = require('@payos/node');

const clientId = process.env.PAYOS_CLIENT_ID || '';
const apiKey = process.env.PAYOS_API_KEY || '';
const checksumKey = process.env.PAYOS_CHECKSUM_KEY || '';

let payosInstance = null;
function getPayOS() {
  if (!clientId || !apiKey || !checksumKey) return null;
  if (!payosInstance) {
    payosInstance = new PayOS({ clientId, apiKey, checksumKey });
  }
  return payosInstance;
}

module.exports = async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  try {
    const payos = getPayOS();
    if (!payos) {
      return res.status(500).json({ error: 'Chưa cấu hình PAYOS_CLIENT_ID, PAYOS_API_KEY, PAYOS_CHECKSUM_KEY trên Vercel' });
    }

    const { email } = req.body || {};
    const orderCode = Number(String(Date.now()).slice(-7) + Math.floor(Math.random() * 90 + 10));
    const amount = 49000;
    const description = `PRO ${orderCode}`.slice(0, 25);

    const origin = req.headers.origin || 'https://ambient-flow.vercel.app';
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

    return res.status(200).json({
      success: true,
      checkoutUrl: paymentLinkRes.checkoutUrl,
      qrCode: paymentLinkRes.qrCode,
      orderCode,
      amount,
    });
  } catch (error) {
    console.error('Error creating PayOS payment link:', error);
    return res.status(500).json({ error: error.message || 'Lỗi tạo liên kết thanh toán' });
  }
};
