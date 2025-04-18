import 'package:ambientflow/cubits/auth/auth_cubit.dart';
import 'package:ambientflow/cubits/auth/auth_state.dart';
import 'package:ambientflow/models/user_model.dart';
import 'package:ambientflow/repositories/auth/auth_repository_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks(<Type>[AuthRepositoryInterface])
void main() {
  late MockAuthRepositoryInterface mockAuthRepository;
  late AuthCubit authCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryInterface();
    authCubit = AuthCubit(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    const testUser = UserModel(
      uid: 'test-uid',
      displayName: 'Test User',
      email: 'test@example.com',
    );

    test('initial state is AuthState.initial', () {
      expect(authCubit.state, AuthState.initial());
    });

    group('checkAuthStatus', () {
      test('emits [loading, authenticated] when user is signed in', () async {
        // Arrange
        when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => true);
        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => testUser);

        // Act
        await authCubit.checkAuthStatus();

        // Assert
        verify(mockAuthRepository.isSignedIn()).called(1);
        verify(mockAuthRepository.getCurrentUser()).called(1);
        expect(authCubit.state.status, AuthStatus.authenticated);
        expect(authCubit.state.user, testUser);
      });

      test('emits [loading, unauthenticated] when user is not signed in', () async {
        // Arrange
        when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => false);

        // Act
        await authCubit.checkAuthStatus();

        // Assert
        verify(mockAuthRepository.isSignedIn()).called(1);
        verifyNever(mockAuthRepository.getCurrentUser());
        expect(authCubit.state.status, AuthStatus.unauthenticated);
        expect(authCubit.state.user, null);
      });

      test(
          'emits [loading, unauthenticated] when user is signed in but getCurrentUser returns null',
          () async {
        // Arrange
        when(mockAuthRepository.isSignedIn()).thenAnswer((_) async => true);
        when(mockAuthRepository.getCurrentUser()).thenAnswer((_) async => null);

        // Act
        await authCubit.checkAuthStatus();

        // Assert
        verify(mockAuthRepository.isSignedIn()).called(1);
        verify(mockAuthRepository.getCurrentUser()).called(1);
        expect(authCubit.state.status, AuthStatus.unauthenticated);
        expect(authCubit.state.user, null);
      });

      test('emits [loading, error] when an exception is thrown', () async {
        // Arrange
        when(mockAuthRepository.isSignedIn()).thenThrow(Exception('Test error'));

        // Act
        await authCubit.checkAuthStatus();

        // Assert
        verify(mockAuthRepository.isSignedIn()).called(1);
        expect(authCubit.state.status, AuthStatus.error);
        expect(authCubit.state.errorMessage, 'Exception: Test error');
      });
    });

    group('signInWithGoogle', () {
      test('emits [loading, authenticated] when sign in is successful', () async {
        // Arrange
        when(mockAuthRepository.signInWithGoogle()).thenAnswer((_) async => testUser);

        // Act
        await authCubit.signInWithGoogle();

        // Assert
        verify(mockAuthRepository.signInWithGoogle()).called(1);
        expect(authCubit.state.status, AuthStatus.authenticated);
        expect(authCubit.state.user, testUser);
      });

      test('emits [loading, unauthenticated] when sign in fails', () async {
        // Arrange
        when(mockAuthRepository.signInWithGoogle()).thenAnswer((_) async => null);

        // Act
        await authCubit.signInWithGoogle();

        // Assert
        verify(mockAuthRepository.signInWithGoogle()).called(1);
        expect(authCubit.state.status, AuthStatus.unauthenticated);
        expect(authCubit.state.user, null);
        expect(authCubit.state.errorMessage, 'Google sign-in failed');
      });

      test('emits [loading, error] when an exception is thrown', () async {
        // Arrange
        when(mockAuthRepository.signInWithGoogle()).thenThrow(Exception('Test error'));

        // Act
        await authCubit.signInWithGoogle();

        // Assert
        verify(mockAuthRepository.signInWithGoogle()).called(1);
        expect(authCubit.state.status, AuthStatus.error);
        expect(authCubit.state.errorMessage, 'Exception: Test error');
      });
    });

    group('signOut', () {
      test('emits [loading, unauthenticated] when sign out is successful', () async {
        // Arrange
        when(mockAuthRepository.signOut()).thenAnswer((_) async => null);

        // Act
        await authCubit.signOut();

        // Assert
        verify(mockAuthRepository.signOut()).called(1);
        expect(authCubit.state.status, AuthStatus.unauthenticated);
        expect(authCubit.state.user, null);
      });

      test('emits [loading, error] when an exception is thrown', () async {
        // Arrange
        when(mockAuthRepository.signOut()).thenThrow(Exception('Test error'));

        // Act
        await authCubit.signOut();

        // Assert
        verify(mockAuthRepository.signOut()).called(1);
        expect(authCubit.state.status, AuthStatus.error);
        expect(authCubit.state.errorMessage, 'Exception: Test error');
      });
    });

    test('getToken calls repository.getToken', () async {
      // Arrange
      when(mockAuthRepository.getToken()).thenAnswer((_) async => 'test-token');

      // Act
      final token = await authCubit.getToken();

      // Assert
      verify(mockAuthRepository.getToken()).called(1);
      expect(token, 'test-token');
    });
  });
}
