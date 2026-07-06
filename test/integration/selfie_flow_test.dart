import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/home/presentation/screens/home_screen.dart';

void main() {
  group('Selfie Flow Integration', () {
    testWidgets('should navigate from home to country picker', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify home screen loads
      expect(find.text('Photo ID'), findsOneWidget);

      // Note: Actual navigation testing requires mock router
      // This is a placeholder for the full flow test
    });

    testWidgets('should display quick actions', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Verify all quick actions are present
      expect(find.text('Chụp ảnh mới'), findsOneWidget);
      expect(find.text('Chọn từ thư viện'), findsOneWidget);
      expect(find.text('Kiểm tra ảnh'), findsOneWidget);
    });
  });
}
