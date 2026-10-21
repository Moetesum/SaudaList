import 'package:flutter_test/flutter_test.dart';
import 'package:saudalist/app.dart';

void main() {
  testWidgets('SaudaListApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SaudaListApp());

    // Verify that Login screen renders
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
