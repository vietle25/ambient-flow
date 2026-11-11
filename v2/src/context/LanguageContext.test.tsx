import { describe, it, expect, beforeEach, vi } from 'vitest';
import { render, screen, fireEvent, renderHook, act } from '@testing-library/react';
import React from 'react';
import { LanguageProvider, useLanguage } from './LanguageContext';

describe('LanguageContext - i18n System', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
  });

  it('mặc định là tiếng Việt nếu browser language bắt đầu bằng "vi"', () => {
    Object.defineProperty(window.navigator, 'language', {
      value: 'vi-VN',
      configurable: true,
    });
    Object.defineProperty(window.navigator, 'languages', {
      value: ['vi-VN', 'vi', 'en-US'],
      configurable: true,
    });

    const { result } = renderHook(() => useLanguage(), {
      wrapper: ({ children }) => <LanguageProvider>{children}</LanguageProvider>,
    });

    expect(result.current.language).toBe('vi');
    expect(result.current.t.all).toBe('Tất cả');
  });

  it('mặc định là tiếng Anh nếu browser language không phải tiếng Việt', () => {
    Object.defineProperty(window.navigator, 'language', {
      value: 'en-US',
      configurable: true,
    });
    Object.defineProperty(window.navigator, 'languages', {
      value: ['en-US', 'en'],
      configurable: true,
    });

    const { result } = renderHook(() => useLanguage(), {
      wrapper: ({ children }) => <LanguageProvider>{children}</LanguageProvider>,
    });

    expect(result.current.language).toBe('en');
    expect(result.current.t.all).toBe('All');
  });

  it('ưu tiên giá trị đã lưu trong localStorage', () => {
    localStorage.setItem('floum_language', 'vi');
    Object.defineProperty(window.navigator, 'language', {
      value: 'en-US',
      configurable: true,
    });

    const { result } = renderHook(() => useLanguage(), {
      wrapper: ({ children }) => <LanguageProvider>{children}</LanguageProvider>,
    });

    expect(result.current.language).toBe('vi');
    expect(result.current.t.all).toBe('Tất cả');
  });

  it('chuyển đổi ngôn ngữ khi gọi toggleLanguage() và lưu vào localStorage', () => {
    localStorage.setItem('floum_language', 'vi');

    const { result } = renderHook(() => useLanguage(), {
      wrapper: ({ children }) => <LanguageProvider>{children}</LanguageProvider>,
    });

    expect(result.current.language).toBe('vi');

    act(() => {
      result.current.toggleLanguage();
    });

    expect(result.current.language).toBe('en');
    expect(localStorage.getItem('floum_language')).toBe('en');
    expect(result.current.t.all).toBe('All');

    act(() => {
      result.current.toggleLanguage();
    });

    expect(result.current.language).toBe('vi');
    expect(localStorage.getItem('floum_language')).toBe('vi');
    expect(result.current.t.all).toBe('Tất cả');
  });
});
