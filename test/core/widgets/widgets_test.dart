import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/core/widgets/accessible_widgets.dart';
import 'package:photo_id/core/widgets/empty_state.dart';
import 'package:photo_id/core/widgets/error_state.dart';
import 'package:photo_id/core/widgets/loading_state.dart';

void main() {
  group('AccessibleButton', () {
    testWidgets('should render with semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleButton(
              semanticLabel: 'Test button',
              onPressed: () {},
              child: const Text('Tap me'),
            ),
          ),
        ),
      );

      expect(find.text('Tap me'), findsOneWidget);
    });
  });

  group('AccessibleImage', () {
    testWidgets('should render with semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessibleImage(
              semanticLabel: 'Test image',
              child: const Icon(Icons.image),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.image), findsOneWidget);
    });
  });

  group('EmptyState', () {
    testWidgets('should render with title and description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.photo_library,
              title: 'No photos',
              description: 'Take your first photo',
            ),
          ),
        ),
      );

      expect(find.text('No photos'), findsOneWidget);
      expect(find.text('Take your first photo'), findsOneWidget);
    });

    testWidgets('should render with action button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.photo_library,
              title: 'No photos',
              actionLabel: 'Take Photo',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.text('Take Photo'), findsOneWidget);
    });
  });

  group('ErrorState', () {
    testWidgets('should render with error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('should render with retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Error occurred',
              actionLabel: 'Retry',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('LoadingState', () {
    testWidgets('should render with message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingState(
              message: 'Loading...',
            ),
          ),
        ),
      );

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should render with progress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingState(
              message: 'Processing...',
              progress: 0.5,
            ),
          ),
        ),
      );

      expect(find.text('Processing...'), findsOneWidget);
    });
  });
}
