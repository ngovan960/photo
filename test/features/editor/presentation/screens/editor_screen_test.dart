import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/editor/presentation/screens/editor_screen.dart';

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

      expect(find.text('Chỉnh sửa'), findsOneWidget);
    });

    testWidgets('should show background picker', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Nền'), findsOneWidget);
    });

    testWidgets('should show validation section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Validation'), findsOneWidget);
    });

    testWidgets('should show export button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: EditorScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Xuất ảnh'), findsOneWidget);
    });
  });
}
