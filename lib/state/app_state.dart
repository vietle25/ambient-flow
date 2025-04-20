class AppState {
  Set<String>? activeSoundIds;

  AppState({
    this.activeSoundIds,
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
