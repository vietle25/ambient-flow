import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

/// Enum representing the status of authentication.
enum AuthStatus {
  /// Initial state, authentication status is unknown.
  initial,

  /// Authentication is in progress.
  loading,

  /// User is authenticated.
  authenticated,

  /// User is not authenticated.
  unauthenticated,

  /// Authentication failed.
  error,
}

/// State class for authentication.
class AuthState extends Equatable {
  /// The current authentication status.
  final AuthStatus status;

  /// The current user, if authenticated.
  final UserModel? user;

  /// The error message, if authentication failed.
  final String? errorMessage;

  /// Creates a new [AuthState] instance.
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// Initial state of authentication.
  factory AuthState.initial() {
    return const AuthState(
      status: AuthStatus.initial,
      user: null,
      errorMessage: null,
    );
  }

  /// Creates a copy of this [AuthState] with the given fields replaced with new values.
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Whether the user is authenticated.
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Whether the authentication status is loading.
  bool get isLoading => status == AuthStatus.loading;

  @override
  List<Object?> get props => [status, user, errorMessage];

  @override
  String toString() => 'AuthState(status: $status, user: $user, errorMessage: $errorMessage)';
}
