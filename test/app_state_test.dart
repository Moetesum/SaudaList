import 'package:flutter_test/flutter_test.dart';
import 'package:saudalist/models/app_user.dart';
import 'package:saudalist/services/auth_service.dart';
import 'package:saudalist/state/app_state.dart';

class ThrowingAuthService implements AuthService {
  final Exception exception;
  ThrowingAuthService(this.exception);

  @override
  Future<AppUser?> getCurrentUser() async => null;

  @override
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    throw exception;
  }

  @override
  Future<AppUser?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    throw exception;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPassword({required String email}) async {
    throw exception;
  }
}

void main() {
  group('AppState Auth Unit Tests', () {
    test(
      'AppState.signUp rejects passwords shorter than 6 characters',
      () async {
        final appState = AppState();
        final result = await appState.signUp(
          'Test User',
          'test@example.com',
          '12345',
        );
        expect(result, equals('Password must be at least 6 characters.'));
        expect(appState.currentUser, isNull);
      },
    );

    test(
      'AppState.login returns AuthFailure message when service throws',
      () async {
        final authService = ThrowingAuthService(
          const AuthFailure('Invalid login credentials.'),
        );
        final appState = AppState(authService: authService);

        final result = await appState.login(
          'test@example.com',
          'wrongpassword',
        );
        expect(result, equals('Invalid login credentials.'));
        expect(appState.errorMessage, equals('Invalid login credentials.'));
        expect(appState.currentUser, isNull);
      },
    );
  });
}
