import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:saudalist/app.dart';
import 'package:saudalist/models/app_user.dart';
import 'package:saudalist/services/auth_service.dart';
import 'package:saudalist/state/app_state.dart';

class FakeAuthService implements AuthService {
  @override
  Future<AppUser?> getCurrentUser() async => null;

  @override
  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async => null;

  @override
  Future<AppUser?> signUp({
    required String name,
    required String email,
    required String password,
  }) async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPassword({required String email}) async {}
}

void main() {
  testWidgets('SaudaListApp smoke test', (WidgetTester tester) async {
    final appState = AppState(authService: FakeAuthService());
    await appState.bootstrap();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const SaudaListApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
