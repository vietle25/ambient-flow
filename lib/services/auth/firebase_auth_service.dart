import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/user_model.dart';
import 'auth_service_interface.dart';

/// Implementation of [AuthServiceInterface] using Firebase Authentication.
class FirebaseAuthService implements AuthServiceInterface {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn? _googleSignIn;

  /// Creates a new [FirebaseAuthService] instance.
  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        // Only initialize GoogleSignIn for non-web platforms
        _googleSignIn = kIsWeb ? null : (googleSignIn ?? GoogleSignIn());

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // For web, use Firebase Auth directly with Google provider
        // This avoids the client ID issues with GoogleSignIn on web
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        // Sign in with popup for better user experience
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // For mobile platforms, use GoogleSignIn
        if (_googleSignIn != null) {
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            // User canceled the sign-in flow
            return null;
          }

          // Obtain auth details from the request
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          // Create a new credential for Firebase
          final OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Sign in to Firebase with the Google credential
          userCredential = await _firebaseAuth.signInWithCredential(credential);
        } else {
          // Fallback to web method if GoogleSignIn is null
          final GoogleAuthProvider googleProvider = GoogleAuthProvider();
          googleProvider.addScope('email');
          googleProvider.addScope('profile');
          userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
        }
      }

      final User? user = userCredential.user;

      if (user == null) {
        return null;
      }

      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      // Handle any errors that occurred during the sign-in process
      // ignore: avoid_print
      print('Error signing in with Google: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (kIsWeb) {
        // For web, only sign out from Firebase Auth
        await _firebaseAuth.signOut();
      } else {
        // For mobile platforms, sign out from both Firebase Auth and GoogleSignIn (if available)
        if (_googleSignIn != null) {
          await Future.wait(<Future<void>>[
            _firebaseAuth.signOut(),
            _googleSignIn.signOut(),
          ]);
        } else {
          await _firebaseAuth.signOut();
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error signing out: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<bool> isSignedIn() async {
    final User? user = _firebaseAuth.currentUser;
    return user != null;
  }

  @override
  Future<String?> getToken() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }
      return await user.getIdToken();
    } catch (e) {
      // ignore: avoid_print
      print('Error getting token: $e');
      return null;
    }
  }
}
