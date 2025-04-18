import 'package:bloc/bloc.dart';

import '../../models/user_model.dart';
import '../../repositories/auth/auth_repository_interface.dart';
import 'auth_state.dart';

/// Cubit for managing authentication state.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryInterface _authRepository;

  /// Creates a new [AuthCubit] instance.
  AuthCubit({
    required AuthRepositoryInterface authRepository,
  })  : _authRepository = authRepository,
        super(AuthState.initial());

  /// Checks the current authentication status.
  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final bool isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final UserModel? user = await _authRepository.getCurrentUser();
        if (user != null) {
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          ));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Signs in a user with Google.
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final UserModel? user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Google sign-in failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Gets the auth token for the current user.
  Future<String?> getToken() async {
    return await _authRepository.getToken();
  }
}
