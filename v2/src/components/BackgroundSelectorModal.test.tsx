import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import React from 'react';
import { BackgroundSelectorModal } from './BackgroundSelectorModal';
import { useAudioApp } from '@/context/AudioAppContext';
import { BACKGROUND_PRESETS } from '@/types/background';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

describe('BackgroundSelectorModal - Comprehensive Test Suite', () => {
  const mockSetOpenBackgroundModal = vi.fn();
  const mockSetBackground = vi.fn();
  const mockSetOpenProModal = vi.fn();
  const mockAddCustomBackground = vi.fn();
  const mockRemoveCustomBackground = vi.fn();

  beforeEach(() => {
    vi.clearAllMocks();
    vi.spyOn(window, 'alert').mockImplementation(() => {});
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
      isPro: false,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);
    const freeGradient = screen.getByText(/Midnight Deep Blue/i);
    expect(freeGradient).toBeDefined();

    fireEvent.click(freeGradient);
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
      isPro: false,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);
    const proVideo = screen.getByText(/Mưa đêm bên cửa sổ/i);
    expect(proVideo).toBeDefined();

    fireEvent.click(proVideo);
    expect(mockSetBackground).not.toHaveBeenCalled();
    expect(mockSetOpenProModal).toHaveBeenCalledTimes(1);
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
      isPro: false,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);
    const uploadBtn = screen.getByRole('button', { name: /Tự upload ảnh/i });
    fireEvent.click(uploadBtn);
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
      isPro: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);
    const proVideo = screen.getByText(/Mưa đêm bên cửa sổ/i);
    fireEvent.click(proVideo);

    expect(mockSetBackground).toHaveBeenCalledWith(
      expect.objectContaining({ id: 'video-rain-window' })
    );
    expect(mockSetOpenProModal).not.toHaveBeenCalled();
  });

  it('chặn upload nếu file không phải là ảnh (e.g. file text/pdf)', async () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: true,
      setOpenProModal: mockSetOpenProModal,
    });

    const { container } = render(<BackgroundSelectorModal />);
    const fileInput = container.querySelector('input[type="file"]') as HTMLInputElement;

    const fakePdfFile = new File(['dummy content'], 'document.pdf', { type: 'application/pdf' });
    fireEvent.change(fileInput, { target: { files: [fakePdfFile] } });

    expect(window.alert).toHaveBeenCalledWith(expect.stringContaining('Vui lòng chọn file hình ảnh'));
    expect(mockAddCustomBackground).not.toHaveBeenCalled();
  });

  it('chặn upload nếu dung lượng file vượt quá 5MB', async () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: true,
      setOpenProModal: mockSetOpenProModal,
    });

    const { container } = render(<BackgroundSelectorModal />);
    const fileInput = container.querySelector('input[type="file"]') as HTMLInputElement;

    // Tạo file 6MB
    const bigFile = new File([new ArrayBuffer(6 * 1024 * 1024)], 'huge.png', { type: 'image/png' });
    fireEvent.change(fileInput, { target: { files: [bigFile] } });

    expect(window.alert).toHaveBeenCalledWith(expect.stringContaining('Kích thước ảnh tối đa 5MB'));
    expect(mockAddCustomBackground).not.toHaveBeenCalled();
  });

  it('upload ảnh thành công khi file hợp lệ và là user Pro', async () => {
    const mockCreatedBg = {
      id: 'custom-bg-123',
      name: 'My Room',
      type: 'image',
      value: 'data:image/png;base64,xxxx',
      thumbnail: 'data:image/png;base64,xxxx',
      isCustom: true,
    };
    mockAddCustomBackground.mockResolvedValue(mockCreatedBg);

    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: true,
      setOpenProModal: mockSetOpenProModal,
    });

    const { container } = render(<BackgroundSelectorModal />);
    const fileInput = container.querySelector('input[type="file"]') as HTMLInputElement;

    const validImg = new File(['valid img content'], 'myroom.png', { type: 'image/png' });
    fireEvent.change(fileInput, { target: { files: [validImg] } });

    await waitFor(() => {
      expect(mockAddCustomBackground).toHaveBeenCalledWith(validImg);
      expect(mockSetBackground).toHaveBeenCalledWith(mockCreatedBg);
    });
  });

  it('cho phép xóa ảnh custom và gọi removeCustomBackground với stopPropagation', () => {
    const customBg = {
      id: 'custom-bg-1',
      name: 'Custom Photo 1',
      type: 'image' as const,
      category: 'custom' as const,
      value: 'data:image/png;base64,sample',
      thumbnail: 'data:image/png;base64,sample',
      isCustom: true,
      isProOnly: true,
    };

    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [customBg],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);
    const deleteBtn = screen.getByTitle('Xóa ảnh này');
    expect(deleteBtn).toBeDefined();

    fireEvent.click(deleteBtn);
    expect(mockRemoveCustomBackground).toHaveBeenCalledWith('custom-bg-1');
    // Vì stopPropagation được gọi nên thẻ cha không kích hoạt setBackground
    expect(mockSetBackground).not.toHaveBeenCalled();
  });

  it('lọc danh sách hình nền chính xác khi chuyển tab', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: true,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);

    // Chuyển sang tab Video lặp
    const videoTab = screen.getByRole('button', { name: /Video lặp/i });
    fireEvent.click(videoTab);

    expect(screen.getByText(/Mưa đêm bên cửa sổ/i)).toBeDefined();
    // Các preset ảnh tĩnh như 'Rừng thông mờ sương' không được xuất hiện
    expect(screen.queryByText(/Rừng thông mờ sương/i)).toBeNull();
  });

  it('đóng modal khi bấm nút Đóng ở footer', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
      isPro: false,
      setOpenProModal: mockSetOpenProModal,
    });

    render(<BackgroundSelectorModal />);
    const closeBtn = screen.getByRole('button', { name: /^Đóng$/i });
    fireEvent.click(closeBtn);
    expect(mockSetOpenBackgroundModal).toHaveBeenCalledWith(false);
  });
});
