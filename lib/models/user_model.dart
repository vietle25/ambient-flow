import 'package:equatable/equatable.dart';

/// Model class representing a user in the application.
class UserModel extends Equatable {
  /// The unique identifier for the user.
  final String uid;

  /// The display name of the user.
  final String? displayName;

  /// The email address of the user.
  final String? email;

  /// The URL of the user's profile photo.
  final String? photoUrl;

  /// Whether the user's email is verified.
  final bool emailVerified;

  /// Creates a new [UserModel] instance.
  const UserModel({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.emailVerified = false,
  });

  /// Creates an empty [UserModel] instance.
  factory UserModel.empty() {
    return const UserModel(uid: '');
  }

  /// Creates a copy of this [UserModel] with the given fields replaced with new values.
  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    bool? emailVerified,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  /// Converts a Firebase User to a [UserModel].
  factory UserModel.fromFirebaseUser(dynamic firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email,
      photoUrl: firebaseUser.photoURL,
      emailVerified: firebaseUser.emailVerified,
    );
  }

  /// Converts this [UserModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
    };
  }

  /// Creates a [UserModel] from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl, emailVerified];

  @override
  String toString() => 'UserModel(uid: $uid, displayName: $displayName, email: $email)';
}
