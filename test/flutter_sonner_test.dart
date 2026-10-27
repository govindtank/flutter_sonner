import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sonner/flutter_sonner.dart';

void main() {
  setUp(() {
    Sonner.dismissAll();
  });

  group('Sonner controller logic', () {
    test('show creates a toast at index 0', () {
      final id1 = Sonner.show('First toast');
      expect(Sonner.toasts.value.length, equals(1));
      expect(Sonner.toasts.value.first.id, equals(id1));

      final id2 = Sonner.show('Second toast');
      expect(Sonner.toasts.value.length, equals(2));
      expect(Sonner.toasts.value.first.id, equals(id2));
    });

    test('dismiss removes toast by id', () {
      final id = Sonner.success('Done!');
      expect(Sonner.toasts.value.any((t) => t.id == id), isTrue);

      Sonner.dismiss(id);
      expect(Sonner.toasts.value.any((t) => t.id == id), isFalse);
    });

    test('promise resolves from loading to success', () async {
      final future = Future.delayed(
        const Duration(milliseconds: 50),
        () => 'Payload',
      );

      final promiseFuture = Sonner.promise<String>(
        future,
        loading: 'Uploading...',
        success: (res) => 'Uploaded $res',
        error: (err) => 'Failed',
      );

      // Verify loading toast exists
      expect(Sonner.toasts.value.first.type, equals(SonnerType.loading));
      expect(Sonner.toasts.value.first.title, equals('Uploading...'));

      final result = await promiseFuture;
      expect(result, equals('Payload'));

      // Verify updated to success
      expect(Sonner.toasts.value.first.type, equals(SonnerType.success));
      expect(Sonner.toasts.value.first.title, equals('Uploaded Payload'));
    });
  });

  group('SonnerTheme presets', () {
    test('instantiates valid theme palettes', () {
      final dark = SonnerTheme.dark();
      final light = SonnerTheme.light();
      final glass = SonnerTheme.glass();

      expect(dark.backgroundColor, isNotNull);
      expect(light.backgroundColor, isNotNull);
      expect(glass.backgroundColor, isNotNull);
    });
  });

  group('SonnerToaster Widget Tests', () {
    testWidgets('renders active toast with action button', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SonnerToaster(
              child: Container(),
            ),
          ),
        ),
      );

      Sonner.show(
        'File deleted',
        description: 'Moved to trash bin.',
        action: SonnerAction(
          label: 'Undo',
          onPressed: () {
            actionTriggered = true;
          },
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('File deleted'), findsOneWidget);
      expect(find.text('Moved to trash bin.'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pump();

      expect(actionTriggered, isTrue);
    });
  });
}
