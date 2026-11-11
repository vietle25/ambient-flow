import { describe, it, expect, vi } from 'vitest';
import { render } from '@testing-library/react';
import React from 'react';
import { UpgradeProModal } from './UpgradeProModal';
import { useAudioApp } from '@/context/AudioAppContext';
import { LanguageProvider } from '@/context/LanguageContext';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

describe('UpgradeProModal - Re-export alias to DonateModal', () => {
  it('không render khi openProModal = false', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: false,
      setOpenProModal: vi.fn(),
    });

    const { container } = render(
      <LanguageProvider>
        <UpgradeProModal />
      </LanguageProvider>
    );
    expect(container.firstChild).toBeNull();
  });
});
