import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('FlutterSonnerDemoApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterSonnerDemoApp());
    expect(find.text('flutter_sonner'), findsOneWidget);
    expect(find.text('v1.0.0'), findsOneWidget);
  });
}
