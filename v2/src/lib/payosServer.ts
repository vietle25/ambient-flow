import { PayOS } from '@payos/node';

const clientId = process.env.PAYOS_CLIENT_ID || '';
const apiKey = process.env.PAYOS_API_KEY || '';
const checksumKey = process.env.PAYOS_CHECKSUM_KEY || '';

let payosInstance: PayOS | null = null;

export const getPayOS = (): PayOS | null => {
  if (!clientId || !apiKey || !checksumKey) {
    console.warn('PayOS server keys are missing in environment variables');
    return null;
  }

  if (!payosInstance) {
    payosInstance = new PayOS({
      clientId,
      apiKey,
      checksumKey,
    });
  }

  return payosInstance;
};
