import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vms_frontend/main.dart';

void main() {
  testWidgets('Renders corporate login screen initially', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: VmsApp()));
    expect(find.text('SquareHealth-VMS'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
