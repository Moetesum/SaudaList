import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:saudalist/app.dart';
import 'package:saudalist/state/app_state.dart';

void main() {
  testWidgets('SaudaListApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState()..bootstrap(),
        child: const SaudaListApp(),
      ),
    );

    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
