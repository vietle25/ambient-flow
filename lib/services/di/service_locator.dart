import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../repositories/auth/auth_repository_interface.dart';
import '../../state/app_state.dart';
import '../audio/audio_service.dart';
import '../audio/just_audio_service.dart';
import '../auth/auth_service_interface.dart';
import '../auth/firebase_auth_service.dart';
import '../storage/secure_storage_service.dart';
import '../storage/storage_service_interface.dart';

/// Global GetIt instance for dependency injection.
final GetIt getIt = GetIt.instance;

/// Service locator for dependency injection using get_it.
class ServiceLocator {
  // Private constructor to prevent instantiation
  ServiceLocator._();

  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._();

  /// Gets the singleton instance of [ServiceLocator].
  static ServiceLocator get instance => _instance;

  /// Initializes the service locator with all dependencies.
  ///
  /// This method registers all services, repositories, and cubits
  /// in a lazy manner, meaning they will only be instantiated when first accessed.
  Future<void> init() async {
    // Register services as lazy singletons
    // This means they will only be created when first accessed
    _registerServices();

    // Register repositories
    _registerRepositories();

    // Register app state
    _registerAppState();
  }

  /// Register all services
  void _registerServices() {
    // Auth service
    getIt.registerLazySingleton<AuthServiceInterface>(
      () => FirebaseAuthService(
        firebaseAuth: FirebaseAuth.instance,
      ),
    );

    // Storage service
    getIt.registerLazySingleton<StorageServiceInterface>(
      () => SecureStorageService(
        secureStorage: const FlutterSecureStorage(),
      ),
    );

    // Audio service
    getIt.registerLazySingleton<AudioService>(
      () => JustAudioService(),
    );
  }

  /// Register all repositories
  void _registerRepositories() {
    // Auth repository
    getIt.registerLazySingleton<AuthRepositoryInterface>(
      () => AuthRepository(
        authService: getIt<AuthServiceInterface>(),
        storageService: getIt<StorageServiceInterface>(),
      ),
    );
  }

  /// Register app state
  void _registerAppState() {
    // App state notifier
    getIt.registerLazySingleton<AppState>(
      () => AppState(),
    );
  }

  /// Gets the authentication service.
  AuthServiceInterface get authService => getIt<AuthServiceInterface>();

  /// Gets the storage service.
  StorageServiceInterface get storageService =>
      getIt<StorageServiceInterface>();

  /// Gets the authentication repository.
  AuthRepositoryInterface get authRepository =>
      getIt<AuthRepositoryInterface>();

  /// Gets the authentication cubit.
  AuthCubit get authCubit => getIt<AuthCubit>();

  /// Gets the app state notifier.
  AppState get appState => getIt<AppState>();

  /// Gets the audio service.
  AudioService get audioService => getIt<AudioService>();
}
