class WebAudioManager {
  private audioElements: Map<string, HTMLAudioElement> = new Map();
  private volumes: Map<string, number> = new Map(); // soundId -> 0..100
  private globalVolume: number = 50; // 0..100
  private isMuted: boolean = false;
  private audioContextResumed: boolean = false;

  private resumeContext() {
    if (this.audioContextResumed) return;
    this.audioContextResumed = true;
  }

  public getOrCreateAudio(soundId: string, audioPath: string): HTMLAudioElement {
    let audio = this.audioElements.get(soundId);
    if (!audio) {
      audio = new Audio(audioPath);
      audio.loop = true;
      audio.preload = 'auto';
      this.audioElements.set(soundId, audio);
      if (!this.volumes.has(soundId)) {
        this.volumes.set(soundId, 50);
      }
    }
    return audio;
  }

  public async playSound(soundId: string, audioPath: string, volume: number = 50): Promise<boolean> {
    this.resumeContext();
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
      return;
    }

    const soundVol = this.volumes.get(soundId) ?? 50;
    // Calculate final volume: (soundVol / 100) * (globalVolume / 100)
    const normalized = Math.min(1, Math.max(0, (soundVol / 100) * (this.globalVolume / 100)));
    audio.volume = normalized;
  }
}

export const audioManager = typeof window !== 'undefined' ? new WebAudioManager() : (null as unknown as WebAudioManager);
