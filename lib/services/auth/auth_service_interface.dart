import '../../models/user_model.dart';

/// Interface for authentication services.
abstract class AuthServiceInterface {
  /// Signs in a user with Google.
  Future<UserModel?> signInWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();

  /// Gets the current user.
  Future<UserModel?> getCurrentUser();

  /// Checks if a user is signed in.
  Future<bool> isSignedIn();

  /// Gets the auth token for the current user.
  Future<String?> getToken();
}
