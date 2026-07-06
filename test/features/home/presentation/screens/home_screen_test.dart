import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/home/presentation/screens/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.text('Photo ID'), findsOneWidget);
    });

    testWidgets('should show quick action buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.text('Chụp ảnh mới'), findsOneWidget);
      expect(find.text('Chọn từ thư viện'), findsOneWidget);
      expect(find.text('Kiểm tra ảnh'), findsOneWidget);
    });

    testWidgets('should show settings icon', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('should show recent section', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      expect(find.text('Gần đây'), findsOneWidget);
    });
  });
}
