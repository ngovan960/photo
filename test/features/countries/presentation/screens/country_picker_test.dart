import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/countries/presentation/screens/country_picker_screen.dart';

void main() {
  group('CountryPickerScreen', () {
    testWidgets('should render without errors', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountryPickerScreen(),
          ),
        ),
      );

      expect(find.text('Chọn quốc gia'), findsOneWidget);
    });

    testWidgets('should show search bar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountryPickerScreen(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should show back button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CountryPickerScreen(),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
