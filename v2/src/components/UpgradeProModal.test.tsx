import { describe, it, expect, vi } from 'vitest';
import { render } from '@testing-library/react';
import React from 'react';
import { UpgradeProModal } from './UpgradeProModal';
import { useAudioApp } from '@/context/AudioAppContext';

vi.mock('@/context/AudioAppContext', () => ({
  useAudioApp: vi.fn(),
}));

describe('UpgradeProModal - Re-export alias to DonateModal', () => {
  it('không render khi openProModal = false', () => {
    (useAudioApp as any).mockReturnValue({
      openProModal: false,
      setOpenProModal: vi.fn(),
    });

    const { container } = render(<UpgradeProModal />);
    expect(container.firstChild).toBeNull();
  });
});
