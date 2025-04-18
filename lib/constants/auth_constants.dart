/// Constants related to authentication.
class AuthConstants {
  // Private constructor to prevent instantiation
  AuthConstants._();

  /// Google OAuth client ID for web.
  ///
  /// This is the client ID from the Google Cloud Console for web applications.
  /// It should match the client ID in your Firebase project settings.
  ///
  /// Note: For web applications, we'll use the Firebase Auth provider directly
  /// instead of using the client ID with GoogleSignIn.
  static const String webClientId = '';
}
