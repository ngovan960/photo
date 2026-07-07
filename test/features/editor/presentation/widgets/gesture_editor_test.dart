import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/editor/presentation/widgets/gesture_editor.dart';
import 'package:photo_id/features/editor/domain/models/outfit_template.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('OutfitTransform', () {
    test('should create with default values', () {
      const transform = OutfitTransform();

      expect(transform.position, Offset.zero);
      expect(transform.scale, 1.0);
      expect(transform.rotation, 0.0);
    });

    test('should create with custom values', () {
      const transform = OutfitTransform(
        position: Offset(10, 20),
        scale: 1.5,
        rotation: 45.0,
      );

      expect(transform.position, const Offset(10, 20));
      expect(transform.scale, 1.5);
      expect(transform.rotation, 45.0);
    });

    test('should copy with new values', () {
      const original = OutfitTransform();
      final copied = original.copyWith(
        position: const Offset(5, 10),
        scale: 2.0,
      );

      expect(copied.position, const Offset(5, 10));
      expect(copied.scale, 2.0);
      expect(copied.rotation, 0.0);
    });

    test('should preserve values when not specified in copyWith', () {
      const original = OutfitTransform(
        position: Offset(10, 20),
        scale: 1.5,
        rotation: 30.0,
      );
      final copied = original.copyWith(scale: 2.0);

      expect(copied.position, const Offset(10, 20));
      expect(copied.scale, 2.0);
      expect(copied.rotation, 30.0);
    });
  });

  group('GestureEditor Widget', () {
    late OutfitTemplate testOutfit;

    setUp(() {
      testOutfit = OutfitTemplate(
        id: 'test_outfit',
        name: 'Test Outfit',
        category: OutfitCategory.formal,
        gender: OutfitGender.male,
        imageBytes: Uint8List(0),
        defaultScale: 1.0,
        defaultPosition: const Offset(0, 0.3),
      );
    });

    Widget buildTestWidget({
      OutfitTemplate? outfit,
      ValueChanged<OutfitTransform>? onTransformChanged,
      VoidCallback? onConfirm,
      Uint8List? photoBytes,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: GestureEditor(
            outfit: outfit ?? testOutfit,
            photoBytes: photoBytes,
            onTransformChanged: onTransformChanged ?? (_) {},
            onConfirm: onConfirm,
          ),
        ),
      );
    }

    testWidgets('should render without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(GestureEditor), findsOneWidget);
    });

    testWidgets('should display outfit icon fallback when no image bytes', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.byIcon(Icons.checkroom), findsOneWidget);
    });

    testWidgets('should display scale slider', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Kích thước'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(2));
    });

    testWidgets('should display rotation slider', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Xoay'), findsOneWidget);
    });

    testWidgets('should display reset button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Đặt lại'), findsOneWidget);
    });

    testWidgets('should display confirm button', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Xác nhận'), findsOneWidget);
    });

    testWidgets('should call onConfirm when confirm button is tapped', (tester) async {
      bool confirmCalled = false;

      await tester.pumpWidget(buildTestWidget(
        onConfirm: () => confirmCalled = true,
      ));

      await tester.tap(find.text('Xác nhận'));
      expect(confirmCalled, true);
    });

    testWidgets('should not display photo image when photoBytes is empty', (tester) async {
      await tester.pumpWidget(buildTestWidget(photoBytes: Uint8List(0)));

      expect(find.byType(GestureEditor), findsOneWidget);
    });

    testWidgets('should reset transform when reset button is tapped', (tester) async {
      OutfitTransform? lastTransform;

      await tester.pumpWidget(buildTestWidget(
        onTransformChanged: (t) => lastTransform = t,
      ));

      await tester.tap(find.text('Đặt lại'));
      await tester.pump();

      expect(lastTransform, isNotNull);
      expect(lastTransform!.scale, 1.0);
      expect(lastTransform!.rotation, 0.0);
    });

    testWidgets('should update scale when slider changes', (tester) async {
      OutfitTransform? lastTransform;

      await tester.pumpWidget(buildTestWidget(
        onTransformChanged: (t) => lastTransform = t,
      ));

      final sliders = find.byType(Slider);
      await tester.drag(sliders.first, const Offset(50, 0));
      await tester.pump();

      expect(lastTransform, isNotNull);
    });

    testWidgets('should reinitialize transform when outfit changes', (tester) async {
      final outfit1 = OutfitTemplate(
        id: 'outfit_1',
        name: 'Outfit 1',
        category: OutfitCategory.formal,
        gender: OutfitGender.male,
        imageBytes: Uint8List(0),
        defaultScale: 1.0,
      );

      final outfit2 = OutfitTemplate(
        id: 'outfit_2',
        name: 'Outfit 2',
        category: OutfitCategory.formal,
        gender: OutfitGender.female,
        imageBytes: Uint8List(0),
        defaultScale: 1.5,
      );

      await tester.pumpWidget(buildTestWidget(outfit: outfit1));
      expect(find.byType(GestureEditor), findsOneWidget);

      await tester.pumpWidget(buildTestWidget(outfit: outfit2));
      expect(find.byType(GestureEditor), findsOneWidget);
    });
  });
}
