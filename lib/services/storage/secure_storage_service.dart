import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_service_interface.dart';

/// Implementation of [StorageServiceInterface] using Flutter Secure Storage.
class SecureStorageService implements StorageServiceInterface {
  final FlutterSecureStorage _secureStorage;

  /// Creates a new [SecureStorageService] instance.
  SecureStorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> removeSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<bool> containsKeySecure(String key) async {
    return await _secureStorage.containsKey(key: key);
  }

  @override
  Future<void> clearSecure() async {
    await _secureStorage.deleteAll();
  }
}
