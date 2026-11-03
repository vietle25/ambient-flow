import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import React from 'react';
import HomePage from './page';

// Mock audioManager để không báo lỗi web audio trong jsdom
vi.mock('@/lib/audioManager', () => ({
  audioManager: {
    setGlobalVolume: vi.fn(),
    setMuted: vi.fn(),
    playTrack: vi.fn(),
    stopTrack: vi.fn(),
    setTrackVolume: vi.fn(),
    stopAll: vi.fn(),
  },
}));

// Mock firebase auth & firestore
vi.mock('@/lib/firebase', () => ({
  auth: { currentUser: null },
  googleProvider: {},
  db: {},
}));

vi.mock('firebase/auth', () => ({
  onAuthStateChanged: vi.fn((auth, cb) => {
    cb(null);
    return () => {};
  }),
  getAuth: vi.fn(),
  GoogleAuthProvider: vi.fn(),
  signInWithPopup: vi.fn(),
  signOut: vi.fn(),
}));

describe('HomePage URL Payment Callback - Kích hoạt Pro qua URL', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
    vi.spyOn(window, 'alert').mockImplementation(() => {});
  });

  it('tự động kích hoạt Pro và dọn URL param khi truy cập với ?payment=success&orderCode=123', async () => {
    // Giả lập URL có param payment=success
    const originalLocation = window.location;
    delete (window as any).location;
    window.location = new URL('https://ambient-flow.vercel.app/?payment=success&orderCode=123456') as any;

    const replaceStateSpy = vi.spyOn(window.history, 'replaceState');

    render(<HomePage />);

    await waitFor(() => {
      // 1. Phải lưu cờ Pro vào localStorage
      expect(localStorage.getItem('ambient_flow_is_pro')).toBe('true');
      // 2. Phải dọn query param trên thanh URL
      expect(replaceStateSpy).toHaveBeenCalled();
      // 3. Phải hiển thị alert chúc mừng
      expect(window.alert).toHaveBeenCalledWith(expect.stringContaining('Chúc mừng bạn đã nâng cấp thành công'));
    });

    window.location = originalLocation;
  });

  it('không kích hoạt Pro nếu param payment=cancel', async () => {
    const originalLocation = window.location;
    delete (window as any).location;
    window.location = new URL('https://ambient-flow.vercel.app/?payment=cancel') as any;

    render(<HomePage />);

    expect(localStorage.getItem('ambient_flow_is_pro')).toBeNull();
    expect(window.alert).not.toHaveBeenCalled();

    window.location = originalLocation;
  });
});
