import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/core/animations/app_animations.dart';
import 'package:photo_id/core/animations/page_transitions.dart';

void main() {
  group('AppAnimations', () {
    testWidgets('should create slide from right animation', (tester) async {
      final controller = AnimationController(
        vsync: tester,
        duration: const Duration(milliseconds: 300),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AppAnimations.slideFromRight(
            const Text('Test'),
            controller,
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should create fade in animation', (tester) async {
      final controller = AnimationController(
        vsync: tester,
        duration: const Duration(milliseconds: 300),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AppAnimations.fadeIn(
            const Text('Test'),
            controller,
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('PageTransitions', () {
    test('FadeRoute should have correct duration', () {
      final route = FadeRoute(page: const Text('Test'));
      expect(route.transitionDuration, const Duration(milliseconds: 300));
    });

    test('SlideRoute should have correct duration', () {
      final route = SlideRoute(page: const Text('Test'));
      expect(route.transitionDuration, const Duration(milliseconds: 300));
    });

    test('SlideUpRoute should have correct duration', () {
      final route = SlideUpRoute(page: const Text('Test'));
      expect(route.transitionDuration, const Duration(milliseconds: 300));
    });
  });
}
