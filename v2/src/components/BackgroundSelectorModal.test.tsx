import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import React from 'react';
import { BackgroundSelectorModal } from './BackgroundSelectorModal';
import { useAudioApp } from '@/context/AudioAppContext';
import { BACKGROUND_PRESETS } from '@/types/background';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

describe('BackgroundSelectorModal - Logic Khóa quyền Pro và Đổi màu Free', () => {
  const mockSetOpenBackgroundModal = vi.fn();
  const mockSetBackground = vi.fn();
  const mockSetOpenProModal = vi.fn();
  const mockAddCustomBackground = vi.fn();
  const mockRemoveCustomBackground = vi.fn();

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('cho phép user Free chọn gradient miễn phí mà không bị chặn', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: false, // User Free
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);

    // Tìm thẻ gradient miễn phí
    const freeGradient = screen.getByText(/Midnight Deep Blue/i);
    expect(freeGradient).toBeInTheDocument();

    fireEvent.click(freeGradient);

    // Phải gọi setBackground, không được mở popup Pro
    expect(mockSetBackground).toHaveBeenCalled();
    expect(mockSetOpenProModal).not.toHaveBeenCalled();
  });

  it('chặn user Free khi bấm vào video hoặc ảnh Pro và kích hoạt popup mua Pro', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: false, // User Free
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);

    // Thẻ video mưa đêm (Pro only)
    const proVideo = screen.getByText(/Mưa đêm bên cửa sổ/i);
    expect(proVideo).toBeInTheDocument();

    fireEvent.click(proVideo);

    // Không được đổi background, phải mở popup Pro
    expect(mockSetBackground).not.toHaveBeenCalled();
    expect(mockSetOpenProModal).toHaveBeenCalledTimes(1);
  });

  it('cho phép user Pro chọn bất kỳ video hoặc ảnh nền nào', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: true, // User Pro
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);

    const proVideo = screen.getByText(/Mưa đêm bên cửa sổ/i);
    fireEvent.click(proVideo);

    // User Pro được phép áp dụng ngay
    expect(mockSetBackground).toHaveBeenCalledWith(
      expect.objectContaining({ id: 'video-rain-window' })
    );
    expect(mockSetOpenProModal).not.toHaveBeenCalled();
  });

  it('chặn nút tự upload ảnh nếu user chưa có Pro', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: false, // User Free
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);

    const uploadBtn = screen.getByRole('button', { name: /Tự upload ảnh/i });
    fireEvent.click(uploadBtn);

    // Phải mở modal mua Pro
    expect(mockSetOpenProModal).toHaveBeenCalledTimes(1);
  });
});
