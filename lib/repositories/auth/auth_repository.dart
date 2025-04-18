import 'dart:convert';

import '../../models/user_model.dart';
import '../../services/auth/auth_service_interface.dart';
import '../../services/storage/storage_service_interface.dart';
import 'auth_repository_interface.dart';

/// Implementation of [AuthRepositoryInterface].
class AuthRepository implements AuthRepositoryInterface {
  final AuthServiceInterface _authService;
  final StorageServiceInterface _storageService;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Creates a new [AuthRepository] instance.
  AuthRepository({
    required AuthServiceInterface authService,
    required StorageServiceInterface storageService,
  })  : _authService = authService,
        _storageService = storageService;

  @override
  Future<UserModel?> signInWithGoogle() async {
    final UserModel? user = await _authService.signInWithGoogle();
    if (user != null) {
      // Save user data to secure storage
      await _storageService.saveSecure(_userKey, jsonEncode(user.toJson()));

      // Save token to secure storage
      final String? token = await _authService.getToken();
      if (token != null) {
        await _storageService.saveSecure(_tokenKey, token);
      }
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
    await _storageService.removeSecure(_tokenKey);
    await _storageService.removeSecure(_userKey);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // First try to get the user from the auth service
    UserModel? user = await _authService.getCurrentUser();

    // If the user is not signed in, try to get the user from secure storage
    if (user == null) {
      final String? userData = await _storageService.getSecure(_userKey);
      if (userData != null) {
        try {
          // Parse the user data from secure storage
          final Map<String, dynamic> userMap =
              jsonDecode(userData) as Map<String, dynamic>;
          user = UserModel.fromJson(userMap);
        } catch (e) {
          // ignore: avoid_print
          print('Error parsing user data: $e');
        }
      }
    }

    return user;
  }

  @override
  Future<bool> isSignedIn() async {
    // First check if the user is signed in with the auth service
    final bool isSignedInWithService = await _authService.isSignedIn();
    if (isSignedInWithService) {
      return true;
    }

    // If not, check if we have a token in secure storage
    final bool hasToken = await _storageService.containsKeySecure(_tokenKey);
    return hasToken;
  }

  @override
  Future<String?> getToken() async {
    // First try to get the token from the auth service
    String? token = await _authService.getToken();

    // If the token is not available, try to get it from secure storage
    token ??= await _storageService.getSecure(_tokenKey);

    return token;
  }
}
