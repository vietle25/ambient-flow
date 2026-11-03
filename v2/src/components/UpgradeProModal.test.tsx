import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import React from 'react';
import { UpgradeProModal } from './UpgradeProModal';
import { useAudioApp } from '@/context/AudioAppContext';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

describe('UpgradeProModal - Comprehensive Test Suite', () => {
  const mockSetOpenProModal = vi.fn();
  const mockSignInGoogle = vi.fn();

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('không render gì nếu openProModal = false', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: false,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: null,
      signInGoogle: mockSignInGoogle,
    });

    const { container } = render(<UpgradeProModal />);
    expect(container.firstChild).toBeNull();
  });

  it('đóng modal khi người dùng bấm nút X', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: null,
      signInGoogle: mockSignInGoogle,
    });

    render(<UpgradeProModal />);
    const closeBtn = screen.getByRole('button', { name: '' }); // nút X
    fireEvent.click(closeBtn);
    expect(mockSetOpenProModal).toHaveBeenCalledWith(false);
  });

  it('yêu cầu đăng nhập Google nếu user chưa đăng nhập khi bấm nút nâng cấp', async () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: null,
      signInGoogle: mockSignInGoogle,
    });

    render(<UpgradeProModal />);
    const actionBtn = screen.getByRole('button', { name: /Đăng nhập Google để nâng cấp Pro/i });
    expect(actionBtn).toBeDefined();

    fireEvent.click(actionBtn);
    expect(mockSignInGoogle).toHaveBeenCalledTimes(1);
  });

  it('hiển thị lỗi khi signInGoogle bị reject (người dùng tắt popup Google)', async () => {
    mockSignInGoogle.mockRejectedValue(new Error('Popup closed'));

    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: null,
      signInGoogle: mockSignInGoogle,
    });

    render(<UpgradeProModal />);
    const actionBtn = screen.getByRole('button', { name: /Đăng nhập Google để nâng cấp Pro/i });
    fireEvent.click(actionBtn);

    await waitFor(() => {
      expect(screen.getByText(/Vui lòng đăng nhập Google để lưu gói Pro/i)).toBeDefined();
    });
  });

  it('gọi API tạo link thanh toán PayOS và chuyển hướng thành công khi user đã đăng nhập', async () => {
    const mockUser = {
      uid: 'user-123456',
      email: 'testuser@gmail.com',
    };

    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: mockUser,
      signInGoogle: mockSignInGoogle,
    });

    const mockCheckoutUrl = 'https://pay.payos.vn/web/test-checkout-123';
    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        success: true,
        checkoutUrl: mockCheckoutUrl,
      }),
    });

    const originalLocation = window.location;
    delete (window as any).location;
    window.location = { ...originalLocation, href: '' } as any;

    render(<UpgradeProModal />);
    const actionBtn = screen.getByRole('button', { name: /Thanh toán 49.000đ/i });
    fireEvent.click(actionBtn);

    await waitFor(() => {
      expect(global.fetch).toHaveBeenCalledWith('/api/payos/create-payment-link', expect.objectContaining({
        method: 'POST',
        body: JSON.stringify({
          userId: mockUser.uid,
          email: mockUser.email,
        }),
      }));
      expect(window.location.href).toBe(mockCheckoutUrl);
    });

    window.location = originalLocation;
  });

  it('hiển thị thông báo lỗi khi API thanh toán trả về status 500 hoặc success = false', async () => {
    const mockUser = { uid: 'user-123', email: 'test@gmail.com' };

    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: mockUser,
      signInGoogle: mockSignInGoogle,
    });

    global.fetch = vi.fn().mockResolvedValue({
      ok: false,
      json: async () => ({
        success: false,
        error: 'Cổng thanh toán PayOS đang bảo trì',
      }),
    });

    render(<UpgradeProModal />);
    const actionBtn = screen.getByRole('button', { name: /Thanh toán 49.000đ/i });
    fireEvent.click(actionBtn);

    await waitFor(() => {
      expect(screen.getByText(/Cổng thanh toán PayOS đang bảo trì/i)).toBeDefined();
    });
  });

  it('hiển thị thông báo lỗi khi API không trả về checkoutUrl', async () => {
    const mockUser = { uid: 'user-123', email: 'test@gmail.com' };

    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: mockUser,
      signInGoogle: mockSignInGoogle,
    });

    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        success: true,
        checkoutUrl: null, // rỗng
      }),
    });

    render(<UpgradeProModal />);
    const actionBtn = screen.getByRole('button', { name: /Thanh toán 49.000đ/i });
    fireEvent.click(actionBtn);

    await waitFor(() => {
      expect(screen.getByText(/Không nhận được checkoutUrl từ PayOS/i)).toBeDefined();
    });
  });

  it('hiển thị thông báo lỗi khi fetch bị lỗi mạng (Network failure)', async () => {
    const mockUser = { uid: 'user-123', email: 'test@gmail.com' };

    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: mockUser,
      signInGoogle: mockSignInGoogle,
    });

    global.fetch = vi.fn().mockRejectedValue(new Error('Network error, please check connection'));

    render(<UpgradeProModal />);
    const actionBtn = screen.getByRole('button', { name: /Thanh toán 49.000đ/i });
    fireEvent.click(actionBtn);

    await waitFor(() => {
      expect(screen.getByText(/Network error, please check connection/i)).toBeDefined();
    });
  });

  it('hiển thị trạng thái đã sở hữu gói Pro nếu isPro = true và vô hiệu hóa nút', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: true,
      user: { uid: 'user-123', email: 'pro@gmail.com' },
      signInGoogle: mockSignInGoogle,
    });

    render(<UpgradeProModal />);
    expect(screen.getByText(/Bạn đã sở hữu gói Pro/i)).toBeDefined();
    const btn = screen.getByRole('button', { name: /Bạn đã sở hữu gói Pro/i });
    expect((btn as HTMLButtonElement).disabled).toBe(true);
  });
});
