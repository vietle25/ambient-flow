import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import React from 'react';
import { DonateModal } from './DonateModal';
import { useAudioApp } from '@/context/AudioAppContext';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

describe('DonateModal - Buy Me a Coffee Dual Language Suite', () => {
  const mockSetOpenProModal = vi.fn();

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('không render gì nếu openProModal = false', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: false,
      setOpenProModal: mockSetOpenProModal,
    });

    const { container } = render(<DonateModal />);
    expect(container.firstChild).toBeNull();
  });

  it('đóng modal khi người dùng bấm nút X', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<DonateModal />);
    const closeBtn = screen.getByLabelText('Đóng modal');
    fireEvent.click(closeBtn);
    expect(mockSetOpenProModal).toHaveBeenCalledWith(false);
  });

  it('đóng modal khi người dùng bấm nút Đóng / Close ở footer', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<DonateModal />);
    const closeFooterBtn = screen.getByRole('button', { name: /Đóng \/ Close/i });
    fireEvent.click(closeFooterBtn);
    expect(mockSetOpenProModal).toHaveBeenCalledWith(false);
  });

  it('hiển thị đầy đủ thông tin chuyển khoản ngân hàng ACB ở tab Việt Nam', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<DonateModal />);
    // Tiêu đề song ngữ
    expect(screen.getByText(/Ủng hộ tác giả/i)).toBeDefined();
    expect(screen.getByText(/\/ Support Floum/i)).toBeDefined();

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

    render(<DonateModal />);
    const copyStkBtn = screen.getByTitle('Sao chép số tài khoản');
    fireEvent.click(copyStkBtn);

    expect(writeTextMock).toHaveBeenCalledWith('221754869');
    await waitFor(() => {
      expect(screen.getByText('Đã chép')).toBeDefined();
    });
  });

  it('chuyển sang tab PayPal Quốc tế và hiển thị nút thanh toán PayPal chuẩn xác', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<DonateModal />);
    const paypalTabBtn = screen.getByRole('button', { name: /Quốc tế \(PayPal\)/i });
    fireEvent.click(paypalTabBtn);

    expect(screen.getByText(/PayPal International Donation/i)).toBeDefined();
    const paypalLink = screen.getByRole('link', { name: /Mời cà phê qua PayPal \/ Donate with PayPal/i });
    expect(paypalLink).toBeDefined();
    expect(paypalLink.getAttribute('href')).toBe('https://www.paypal.com/ncp/payment/QTU28KHNPABFE');
    expect(paypalLink.getAttribute('target')).toBe('_blank');
  });

  it('đóng modal khi click vào vùng nền mờ backdrop bên ngoài', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<DonateModal />);
    const dialogBackdrop = screen.getByRole('dialog');
    fireEvent.click(dialogBackdrop);
    expect(mockSetOpenProModal).toHaveBeenCalledWith(false);
  });
});
