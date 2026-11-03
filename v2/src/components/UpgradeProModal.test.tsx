import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import React from 'react';
import { UpgradeProModal } from './UpgradeProModal';
import { useAudioApp } from '@/context/AudioAppContext';

// Mock hook useAudioApp
vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

describe('UpgradeProModal - Luồng nâng cấp Pro & Đăng nhập Google', () => {
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

  it('yêu cầu đăng nhập Google nếu user chưa đăng nhập khi bấm nút nâng cấp', async () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: null,
      signInGoogle: mockSignInGoogle,
    });

    render(<UpgradeProModal />);

    // Kiểm tra text nút yêu cầu đăng nhập
    const actionBtn = screen.getByRole('button', { name: /Đăng nhập Google để nâng cấp Pro/i });
    expect(actionBtn).toBeInTheDocument();

    // Bấm nút -> Phải gọi signInGoogle()
    fireEvent.click(actionBtn);
    expect(mockSignInGoogle).toHaveBeenCalledTimes(1);
  });

  it('hiển thị nút thanh toán kèm email người dùng khi đã đăng nhập', async () => {
    const mockUser = {
      uid: 'user-123456',
      email: 'testuser@gmail.com',
      displayName: 'Test User',
    };

    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: false,
      user: mockUser,
      signInGoogle: mockSignInGoogle,
    });

    render(<UpgradeProModal />);

    // Kiểm tra nút thanh toán có kèm email của user
    const actionBtn = screen.getByRole('button', { name: /Thanh toán 49.000đ/i });
    expect(actionBtn).toBeInTheDocument();
    expect(screen.getByText(/testuser@gmail.com/i)).toBeInTheDocument();
  });

  it('gọi API tạo link thanh toán PayOS khi người dùng đã đăng nhập bấm thanh toán', async () => {
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

    // Mock fetch API
    const mockCheckoutUrl = 'https://pay.payos.vn/web/test-checkout-123';
    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        success: true,
        checkoutUrl: mockCheckoutUrl,
      }),
    });

    // Mock window.location
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

  it('hiển thị trạng thái đã sở hữu gói Pro nếu isPro = true', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: true,
      setOpenProModal: mockSetOpenProModal,
      isPro: true,
      user: { uid: 'user-123', email: 'pro@gmail.com' },
      signInGoogle: mockSignInGoogle,
    });

    render(<UpgradeProModal />);

    expect(screen.getByText(/Bạn đã sở hữu gói Pro/i)).toBeInTheDocument();
    const btn = screen.getByRole('button', { name: /Bạn đã sở hữu gói Pro/i });
    expect(btn).toBeDisabled();
  });
});
