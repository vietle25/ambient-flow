// Import đúng module @payos/node ở root mà api/payos/create-payment-link.js sử dụng
const rootPayOSModule = require('../../../node_modules/@payos/node');
const { PayOS } = rootPayOSModule;

// Lấy prototype của PaymentRequests để mock method create
const dummy = new PayOS({ clientId: 'x', apiKey: 'y', checksumKey: 'z' });
const paymentRequestsProto = Object.getPrototypeOf(dummy.paymentRequests);

describe('Serverless API: /api/payos/create-payment-link', () => {
  const originalEnv = process.env;
  let createSpy;

  beforeEach(() => {
    process.env = { ...originalEnv };
  });

  afterEach(() => {
    if (createSpy) {
      createSpy.mockRestore();
    }
  });

  afterAll(() => {
    process.env = originalEnv;
  });

  it('từ chối các request không phải method POST với status 405', async () => {
    const handler = require('../../../api/payos/create-payment-link');
    const req = { method: 'GET' };
    const res = {
      status: vi.fn().mockReturnThis(),
      json: vi.fn(),
    };

    await handler(req, res);
    expect(res.status).toHaveBeenCalledWith(405);
    expect(res.json).toHaveBeenCalledWith({ error: 'Method Not Allowed' });
  });

  it('báo lỗi 500 nếu chưa cấu hình biến môi trường PayOS', async () => {
    delete process.env.PAYOS_CLIENT_ID;
    delete process.env.PAYOS_API_KEY;
    delete process.env.PAYOS_CHECKSUM_KEY;

    const handler = require('../../../api/payos/create-payment-link');
    const req = {
      method: 'POST',
      body: { email: 'user@example.com' },
      headers: {},
    };
    const res = {
      status: vi.fn().mockReturnThis(),
      json: vi.fn(),
    };

    await handler(req, res);
    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ error: expect.stringContaining('Chưa cấu hình') })
    );
  });

  it('tạo link thanh toán thành công (200 OK) với payload PayOS chuẩn xác', async () => {
    process.env.PAYOS_CLIENT_ID = 'test-client-id';
    process.env.PAYOS_API_KEY = 'test-api-key';
    process.env.PAYOS_CHECKSUM_KEY = 'test-checksum-key';

    createSpy = vi.spyOn(paymentRequestsProto, 'create').mockResolvedValue({
      checkoutUrl: 'https://pay.payos.vn/web/123456',
      qrCode: 'vietqr-data-string',
      orderCode: 999999,
      amount: 49000,
    });

    const handler = require('../../../api/payos/create-payment-link');
    const req = {
      method: 'POST',
      body: { email: 'buyer@gmail.com' },
      headers: { origin: 'https://ambient-flow.vercel.app' },
    };
    const res = {
      status: vi.fn().mockReturnThis(),
      json: vi.fn(),
    };

    await handler(req, res);

    expect(res.status).toHaveBeenCalledWith(200);
    expect(createSpy).toHaveBeenCalledWith(
      expect.objectContaining({
        amount: 49000,
        buyerEmail: 'buyer@gmail.com',
        returnUrl: expect.stringContaining('payment=success'),
        cancelUrl: expect.stringContaining('payment=cancel'),
      })
    );
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        success: true,
        checkoutUrl: 'https://pay.payos.vn/web/123456',
        amount: 49000,
      })
    );
  });

  it('xử lý và trả về 500 khi PayOS SDK quăng lỗi', async () => {
    process.env.PAYOS_CLIENT_ID = 'test-client-id';
    process.env.PAYOS_API_KEY = 'test-api-key';
    process.env.PAYOS_CHECKSUM_KEY = 'test-checksum-key';

    createSpy = vi.spyOn(paymentRequestsProto, 'create').mockRejectedValue(
      new Error('PayOS gateway timeout')
    );

    const handler = require('../../../api/payos/create-payment-link');
    const req = {
      method: 'POST',
      body: {},
      headers: {},
    };
    const res = {
      status: vi.fn().mockReturnThis(),
      json: vi.fn(),
    };

    await handler(req, res);
    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalledWith({ error: 'PayOS gateway timeout' });
  });
});
