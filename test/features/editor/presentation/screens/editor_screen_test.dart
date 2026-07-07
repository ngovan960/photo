import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/editor/presentation/screens/editor_screen.dart';
import 'package:photo_id/features/editor/presentation/providers/editor_provider.dart';
import 'package:photo_id/features/editor/presentation/widgets/suit_painter.dart';

void main() {
  group('EditorScreen', () {
    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Photo Editor'), findsOneWidget);
    });

    testWidgets('should show background picker', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('CANVAS BACKGROUND'), findsOneWidget);
    });

    testWidgets('should show validation section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      // Tap on the Checklist navigation item to reveal validation results
      await tester.tap(find.text('Checklist'));
      await tester.pumpAndSettle();

      expect(find.text('Export Readiness'), findsOneWidget);
    });

    testWidgets('should show export button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Export'), findsOneWidget);
    });

    testWidgets('should update suit position on drag gesture', (tester) async {
      // Set physical size and surface size to avoid being off-screen
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      // 1. Go to Suits tab
      await tester.tap(find.text('Suits'));
      await tester.pumpAndSettle();

      // 2. Select a suit to make it visible
      final suitOptionFinder = find.text('Vest Nam Cổ Điển');
      await tester.ensureVisible(suitOptionFinder);
      await tester.tap(suitOptionFinder);
      await tester.pumpAndSettle();

      // 3. Verify SuitWidget is displayed
      expect(find.byType(SuitWidget), findsOneWidget);

      // 4. Drag the SuitWidget horizontally in small steps to simulate movement
      final gesture = await tester.startGesture(tester.getCenter(find.byType(SuitWidget)));
      for (int i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(12.0, 0.0));
        await tester.pump(const Duration(milliseconds: 20));
      }
      await gesture.up();
      await tester.pumpAndSettle();

      // 5. Verify the state coordinates have updated and are no longer zero
      final element = tester.element(find.byType(EditorScreen));
      final container = ProviderScope.containerOf(element);
      expect(container.read(editorProvider).suitDx, isNot(0.0));
      expect(container.read(editorProvider).suitDy, isNot(0.0));
    });
  });
}
