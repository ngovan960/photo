import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/export/presentation/screens/export_screen.dart';

void main() {
  group('ExportScreen', () {
    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExportScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Xuất ảnh'), findsOneWidget);
    });

    testWidgets('should show format picker', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExportScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Định dạng'), findsOneWidget);
      expect(find.text('JPEG'), findsOneWidget);
      expect(find.text('PNG'), findsOneWidget);
    });

    testWidgets('should show layout picker', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExportScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Layout'), findsOneWidget);
      expect(find.text('Đơn'), findsOneWidget);
      expect(find.text('4 bản'), findsOneWidget);
      expect(find.text('8 bản'), findsOneWidget);
    });

    testWidgets('should show action buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExportScreen(photoId: 'test-photo'),
          ),
        ),
      );

      expect(find.text('Lưu'), findsOneWidget);
      expect(find.text('Chia sẻ'), findsOneWidget);
      expect(find.text('In'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
    });
  });
}
