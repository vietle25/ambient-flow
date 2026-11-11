import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import React from 'react';
import { BackgroundSelectorModal } from './BackgroundSelectorModal';
import { useAudioApp } from '@/context/AudioAppContext';
import { LanguageProvider } from '@/context/LanguageContext';
import { BACKGROUND_PRESETS } from '@/types/background';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

const renderWithLang = (ui: React.ReactElement) => {
  return render(<LanguageProvider>{ui}</LanguageProvider>);
};

describe('BackgroundSelectorModal - 100% Free All Presets Test Suite', () => {
  const mockSetOpenBackgroundModal = vi.fn();
  const mockSetBackground = vi.fn();
  const mockAddCustomBackground = vi.fn();
  const mockRemoveCustomBackground = vi.fn();

  beforeEach(() => {
    localStorage.clear();
    localStorage.setItem('floum_language', 'vi');
    vi.clearAllMocks();
    vi.spyOn(window, 'alert').mockImplementation(() => {});
  });

  it('cho phép mọi người dùng chọn gradient miễn phí', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    renderWithLang(<BackgroundSelectorModal />);
    const freeGradient = screen.getByText(/Midnight Deep Blue/i);
    expect(freeGradient).toBeDefined();

    fireEvent.click(freeGradient);
    expect(mockSetBackground).toHaveBeenCalled();
  });

  it('cho phép mọi người dùng chọn video lặp mà không bị chặn', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    renderWithLang(<BackgroundSelectorModal />);
    const videoItem = screen.getByText(/Mưa đêm bên cửa sổ/i);
    expect(videoItem).toBeDefined();

    fireEvent.click(videoItem);
    expect(mockSetBackground).toHaveBeenCalledWith(
      expect.objectContaining({ id: 'video-rain-window' })
    );
  });

  it('cho phép mọi người dùng chọn ảnh chill mà không bị chặn', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    renderWithLang(<BackgroundSelectorModal />);
    const photoItem = screen.getByText(/Bầu trời đầy sao/i);
    expect(photoItem).toBeDefined();

    fireEvent.click(photoItem);
    expect(mockSetBackground).toHaveBeenCalledWith(
      expect.objectContaining({ id: 'photo-starry-night' })
    );
  });

  it('chặn tải lên nếu file không phải là ảnh (Validation type)', async () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    const { container } = renderWithLang(<BackgroundSelectorModal />);
    const fileInput = container.querySelector('input[type="file"]') as HTMLInputElement;

    const dummyTextFile = new File(['content'], 'document.pdf', { type: 'application/pdf' });
    fireEvent.change(fileInput, { target: { files: [dummyTextFile] } });

    expect(window.alert).toHaveBeenCalledWith(
      expect.stringContaining('Vui lòng chọn file hình ảnh')
    );
    expect(mockAddCustomBackground).not.toHaveBeenCalled();
  });

  it('chặn tải lên nếu kích thước file > 5MB (Validation size)', async () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    const { container } = renderWithLang(<BackgroundSelectorModal />);
    const fileInput = container.querySelector('input[type="file"]') as HTMLInputElement;

    const bigFile = new File(['x'.repeat(6 * 1024 * 1024)], 'huge-image.jpg', {
      type: 'image/jpeg',
    });
    Object.defineProperty(bigFile, 'size', { value: 6 * 1024 * 1024 });

    fireEvent.change(fileInput, { target: { files: [bigFile] } });

    expect(window.alert).toHaveBeenCalledWith(
      expect.stringContaining('Kích thước ảnh tối đa 5MB')
    );
    expect(mockAddCustomBackground).not.toHaveBeenCalled();
  });

  it('cho phép tải lên thành công file ảnh hợp lệ và tự động áp dụng làm nền', async () => {
    const fakeCustomBg = {
      id: 'custom-123',
      name: 'My Custom View',
      type: 'image',
      category: 'custom',
      value: 'data:image/png;base64,123',
      thumbnail: 'data:image/png;base64,123',
      isCustom: true,
    };
    mockAddCustomBackground.mockResolvedValue(fakeCustomBg);

    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    const { container } = renderWithLang(<BackgroundSelectorModal />);
    const fileInput = container.querySelector('input[type="file"]') as HTMLInputElement;

    const validFile = new File(['valid'], 'avatar.jpg', { type: 'image/jpeg' });
    Object.defineProperty(validFile, 'size', { value: 1024 * 500 }); // 500KB

    fireEvent.change(fileInput, { target: { files: [validFile] } });

    await waitFor(() => {
      expect(mockAddCustomBackground).toHaveBeenCalledWith(validFile);
      expect(mockSetBackground).toHaveBeenCalledWith(fakeCustomBg);
    });
  });

  it('xóa ảnh custom thành công và ngăn chặn nổi bọt sự kiện chọn background (stopPropagation)', () => {
    const fakeCustomBg = {
      id: 'custom-999',
      name: 'Custom Sunset',
      type: 'image',
      category: 'custom',
      value: 'data:image/jpeg;base64,...',
      thumbnail: 'data:image/jpeg;base64,...',
      isCustom: true,
    };

    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [fakeCustomBg],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    renderWithLang(<BackgroundSelectorModal />);
    const deleteBtn = screen.getByTitle('Xóa ảnh này');
    expect(deleteBtn).toBeDefined();

    fireEvent.click(deleteBtn);
    expect(mockRemoveCustomBackground).toHaveBeenCalledWith('custom-999');
    expect(mockSetBackground).not.toHaveBeenCalled();
  });

  it('lọc danh sách hiển thị khi chuyển tab', () => {
    (useAudioApp as any).mockReturnValue({
      openBackgroundModal: true,
      setOpenBackgroundModal: mockSetOpenBackgroundModal,
      currentBackground: BACKGROUND_PRESETS[0],
      setBackground: mockSetBackground,
      customBackgrounds: [],
      addCustomBackground: mockAddCustomBackground,
      removeCustomBackground: mockRemoveCustomBackground,
    });

    renderWithLang(<BackgroundSelectorModal />);
    const videoTab = screen.getByRole('button', { name: /Video lặp/i });
    fireEvent.click(videoTab);

    expect(screen.getByText(/Mưa đêm bên cửa sổ/i)).toBeDefined();
    expect(screen.queryByText(/Chuyển đổi mượt mà giữa các dải màu/i)).toBeNull();
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
    });

    renderWithLang(<BackgroundSelectorModal />);
    const closeBtn = screen.getByText('Đóng');
    fireEvent.click(closeBtn);
    expect(mockSetOpenBackgroundModal).toHaveBeenCalledWith(false);
  });
});
