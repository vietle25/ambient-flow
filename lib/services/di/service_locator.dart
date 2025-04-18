import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/auth/auth_repository_interface.dart';
import '../auth/auth_service_interface.dart';
import '../auth/firebase_auth_service.dart';
import '../storage/secure_storage_service.dart';
import '../storage/storage_service_interface.dart';

/// Service locator for dependency injection.
class ServiceLocator {
  // Private constructor to prevent instantiation
  ServiceLocator._();

  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._();

  /// Gets the singleton instance of [ServiceLocator].
  static ServiceLocator get instance => _instance;

  // Services
  AuthServiceInterface? _authService;
  StorageServiceInterface? _storageService;

  // Repositories
  AuthRepositoryInterface? _authRepository;

  // Cubits
  AuthCubit? _authCubit;

  /// Initializes the service locator.
  Future<void> init() async {
    // Initialize services
    _authService = FirebaseAuthService(
      firebaseAuth: FirebaseAuth.instance,
    );

    _storageService = SecureStorageService(
      secureStorage: const FlutterSecureStorage(),
    );

    // Initialize repositories
    _authRepository = AuthRepository(
      authService: _authService!,
      storageService: _storageService!,
    );

    // Initialize cubits
    _authCubit = AuthCubit(
      authRepository: _authRepository!,
    );
  }

  /// Gets the authentication service.
  AuthServiceInterface get authService {
    if (_authService == null) {
      throw Exception('AuthService not initialized');
    }
    return _authService!;
  }

  /// Gets the storage service.
  StorageServiceInterface get storageService {
    if (_storageService == null) {
      throw Exception('StorageService not initialized');
    }
    return _storageService!;
  }

  /// Gets the authentication repository.
  AuthRepositoryInterface get authRepository {
    if (_authRepository == null) {
      throw Exception('AuthRepository not initialized');
    }
    return _authRepository!;
  }

  /// Gets the authentication cubit.
  AuthCubit get authCubit {
    if (_authCubit == null) {
      throw Exception('AuthCubit not initialized');
    }
    return _authCubit!;
  }
}
