class AppState {
  Set<String>? activeSoundIds;
  double appVolume = 50;
  double previousVolume = 50; // Store previous volume level for mute/unmute toggle

  AppState({
    this.activeSoundIds,
    this.appVolume = 50,
    this.previousVolume = 50,
  });

  void addActiveSound(String soundId) {
    activeSoundIds ??= <String>{};
    activeSoundIds?.add(soundId);
  }

  void removeActiveSound(String soundId) {
    activeSoundIds?.remove(soundId);
  }

  bool isSoundActive(String soundId) {
    return activeSoundIds?.contains(soundId) ?? false;
  }
}
