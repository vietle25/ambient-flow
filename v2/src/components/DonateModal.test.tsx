import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import React from 'react';
import { DonateModal } from './DonateModal';
import { useAudioApp } from '@/context/AudioAppContext';
import { LanguageProvider } from '@/context/LanguageContext';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

const renderWithLang = (ui: React.ReactElement) => {
  return render(<LanguageProvider>{ui}</LanguageProvider>);
};

describe('DonateModal - Buy Me a Coffee Dual Language Suite with Both QRs', () => {
  const mockSetOpenProModal = vi.fn();

  beforeEach(() => {
    localStorage.clear();
    localStorage.setItem('floum_language', 'vi');
    vi.clearAllMocks();
  });

  it('không render gì nếu openProModal = false', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: false,
      setOpenProModal: mockSetOpenProModal,
    });

    const { container } = renderWithLang(<DonateModal />);
    expect(container.firstChild).toBeNull();
  });

  it('đóng modal khi người dùng bấm nút X', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    renderWithLang(<DonateModal />);
    const closeBtn = screen.getByLabelText('Đóng');
    fireEvent.click(closeBtn);
    expect(mockSetOpenProModal).toHaveBeenCalledWith(false);
  });

  it('hiển thị đầy đủ thông tin chuyển khoản và mã QR ACB ở tab Việt Nam', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    renderWithLang(<DonateModal />);
    // Tiêu đề
    expect(screen.getByText(/Ủng hộ tác giả/i)).toBeDefined();

    // Thông tin ngân hàng ACB
    expect(screen.getByText(/ACB \(Ngân hàng TMCP Á Châu\)/i)).toBeDefined();
    expect(screen.getByText('221754869')).toBeDefined();
    expect(screen.getByText('LE HOANG VIET')).toBeDefined();

    // Ảnh QR ACB
    const qrImage = screen.getByAltText(/Mã QR Chuyển khoản ACB - LE HOANG VIET/i);
    expect(qrImage).toBeDefined();
  });

  it('sao chép số tài khoản vào clipboard và hiển thị phản hồi đã chép', async () => {
    const writeTextMock = vi.fn().mockResolvedValue(undefined);
    Object.assign(navigator, {
      clipboard: {
        writeText: writeTextMock,
      },
    });

    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    renderWithLang(<DonateModal />);
    const copyStkBtn = screen.getByTitle('Sao chép');
    fireEvent.click(copyStkBtn);

    expect(writeTextMock).toHaveBeenCalledWith('221754869');
    await waitFor(() => {
      expect(screen.getByText('Đã chép')).toBeDefined();
    });
  });

  it('chuyển sang tab PayPal Quốc tế và hiển thị mã QR PayPal cùng nút mở trang thanh toán', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    renderWithLang(<DonateModal />);
    const paypalTabBtn = screen.getByRole('button', { name: /Quốc tế \(QR PayPal\)/i });
    fireEvent.click(paypalTabBtn);

    // Kiểm tra có mã QR PayPal
    const paypalQrImage = screen.getByAltText(/Mã QR PayPal - Buy me a coffee/i);
    expect(paypalQrImage).toBeDefined();

    // Kiểm tra link mở trực tiếp
    const paypalLink = screen.getByRole('link', { name: /Mở trang thanh toán PayPal ↗/i });
    expect(paypalLink).toBeDefined();
    expect(paypalLink.getAttribute('href')).toBe('https://www.paypal.com/ncp/payment/QTU28KHNPABFE');
    expect(paypalLink.getAttribute('target')).toBe('_blank');
  });

  it('đóng modal khi click vào vùng nền mờ backdrop bên ngoài', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    renderWithLang(<DonateModal />);
    const dialogBackdrop = screen.getByRole('dialog');
    fireEvent.click(dialogBackdrop);
    expect(mockSetOpenProModal).toHaveBeenCalledWith(false);
  });
});
