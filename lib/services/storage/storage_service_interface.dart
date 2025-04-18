/// Interface for secure storage services.
abstract class StorageServiceInterface {
  /// Saves a value to secure storage.
  Future<void> saveSecure(String key, String value);

  /// Gets a value from secure storage.
  Future<String?> getSecure(String key);

  /// Removes a value from secure storage.
  Future<void> removeSecure(String key);

  /// Checks if a key exists in secure storage.
  Future<bool> containsKeySecure(String key);

  /// Clears all values from secure storage.
  Future<void> clearSecure();
}
