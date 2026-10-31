class WebAudioManager {
  private audioElements: Map<string, HTMLAudioElement> = new Map();
  private gainNodes: Map<string, GainNode> = new Map();
  private volumes: Map<string, number> = new Map(); // soundId -> 0..100
  private globalVolume: number = 50; // 0..100
  private isMuted: boolean = false;
  private audioContext: AudioContext | null = null;

  // Hệ số khuếch đại tối đa (boost thêm 30% khi cả 2 volume ở mức 100%)
  private readonly VOLUME_BOOST_MULTIPLIER = 1.3;

  private getAudioContext(): AudioContext | null {
    if (typeof window === 'undefined') return null;
    if (!this.audioContext) {
      const AudioCtx = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext;
      if (AudioCtx) {
        this.audioContext = new AudioCtx();
      }
    }
    if (this.audioContext && this.audioContext.state === 'suspended') {
      this.audioContext.resume().catch((e) => console.warn('Could not resume audioContext', e));
    }
    return this.audioContext;
  }

  public getOrCreateAudio(soundId: string, audioPath: string): HTMLAudioElement {
    let audio = this.audioElements.get(soundId);
    if (!audio) {
      audio = new Audio(audioPath);
      audio.loop = true;
      audio.preload = 'auto';
      audio.crossOrigin = 'anonymous';

      // Kết nối với Web Audio API GainNode để có thể boost volume vượt mốc 100% (+30%)
      const ctx = this.getAudioContext();
      if (ctx) {
        try {
          const source = ctx.createMediaElementSource(audio);
          const gainNode = ctx.createGain();
          source.connect(gainNode);
          gainNode.connect(ctx.destination);
          this.gainNodes.set(soundId, gainNode);
        } catch (e) {
          console.warn(`Could not connect Web Audio GainNode for ${soundId}:`, e);
        }
      }

      this.audioElements.set(soundId, audio);
      if (!this.volumes.has(soundId)) {
        this.volumes.set(soundId, 50);
      }
    }
    return audio;
  }

  public async playSound(soundId: string, audioPath: string, volume: number = 50): Promise<boolean> {
    this.getAudioContext();
    const audio = this.getOrCreateAudio(soundId, audioPath);
    this.volumes.set(soundId, volume);
    this.applyVolumeToAudio(soundId);

    try {
      await audio.play();
      return true;
    } catch (e) {
      console.warn(`Could not play sound ${soundId}:`, e);
      return false;
    }
  }

  public stopSound(soundId: string): void {
    const audio = this.audioElements.get(soundId);
    if (audio) {
      audio.pause();
      audio.currentTime = 0;
    }
  }

  public setSoundVolume(soundId: string, volume: number): void {
    this.volumes.set(soundId, volume);
    this.applyVolumeToAudio(soundId);
  }

  public setGlobalVolume(volume: number): void {
    this.globalVolume = volume;
    this.audioElements.forEach((_, soundId) => {
      this.applyVolumeToAudio(soundId);
    });
  }

  public setMuted(muted: boolean): void {
    this.isMuted = muted;
    this.audioElements.forEach((_, soundId) => {
      this.applyVolumeToAudio(soundId);
    });
  }

  public stopAll(): void {
    this.audioElements.forEach((audio) => {
      audio.pause();
      audio.currentTime = 0;
    });
  }

  private applyVolumeToAudio(soundId: string): void {
    const audio = this.audioElements.get(soundId);
    if (!audio) return;

    if (this.isMuted) {
      audio.volume = 0;
      const gainNode = this.gainNodes.get(soundId);
      if (gainNode) gainNode.gain.value = 0;
      return;
    }

    const soundVol = this.volumes.get(soundId) ?? 50;
    // Tính toán mức cơ bản: (soundVol / 100) * (globalVolume / 100)
    const baseVolume = (soundVol / 100) * (this.globalVolume / 100);

    // Khuếch đại thêm 30% (tối đa đạt 1.3)
    const boostedVolume = baseVolume * this.VOLUME_BOOST_MULTIPLIER;

    const gainNode = this.gainNodes.get(soundId);
    if (gainNode) {
      // Dùng GainNode của Web Audio API (hỗ trợ gain > 1.0 mượt mà)
      gainNode.gain.value = boostedVolume;
      audio.volume = 1; // giữ audio nguyên bản 100% để GainNode khuếch đại
    } else {
      // Fallback nếu browser không hỗ trợ Web Audio Context
      audio.volume = Math.min(1, Math.max(0, boostedVolume));
    }
  }
}

export const audioManager = typeof window !== 'undefined' ? new WebAudioManager() : (null as unknown as WebAudioManager);
