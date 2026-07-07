import 'dart:math' show pi;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_id/features/editor/presentation/providers/editor_provider.dart';
import 'package:photo_id/features/editor/domain/models/background_color.dart';
import 'package:photo_id/features/editor/presentation/widgets/suit_painter.dart';
import 'package:photo_id/features/editor/presentation/widgets/gesture_editor.dart';
import 'package:photo_id/features/editor/data/outfit_library_service.dart';
import 'package:photo_id/features/editor/domain/models/outfit_template.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String photoId;

  const EditorScreen({
    super.key,
    required this.photoId,
  });

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  int _activeNavIndex = 0; // 0: Canvas, 1: Suits, 2: Filters, 3: Adjust, 4: Checklist
  final GlobalKey _previewKey = GlobalKey();

  // Gesture state for manual suit alignment
  double _baseScale = 1.0;
  double _baseDx = 0.0;
  double _baseDy = 0.0;
  Offset _startFocalPoint = Offset.zero;

  SuitType _mapStringToSuitType(String suit) {
    switch (suit) {
      case 'men_classic':
        return SuitType.menClassic;
      case 'men_modern':
        return SuitType.menModern;
      case 'women_classic':
        return SuitType.womenClassic;
      case 'women_modern':
        return SuitType.womenModern;
      default:
        return SuitType.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF);
    final cardColor = isDark ? const Color(0xFF1D2438) : Colors.white;
    final dividerColor = isDark ? const Color(0xFF333D55) : const Color(0xFFE2E7FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF131B2E) : const Color(0xFFFAF8FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: isDark ? Colors.white70 : const Color(0xFF434656),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Photo Editor',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF131B2E),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final goRouter = GoRouter.of(context);

                    // Show processing dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );

                    try {
                      // Capture the repaint boundary
                      final boundary = _previewKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
                      if (boundary != null) {
                        final image = await boundary.toImage(pixelRatio: 3.0); // export high-res
                        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                        if (byteData != null) {
                          final bytes = byteData.buffer.asUint8List();
                          ref.read(editorProvider.notifier).setProcessedBytes(bytes);
                        }
                      }
                    } catch (e) {
                      debugPrint("Error capturing preview: $e");
                    } finally {
                      // Dismiss dialog
                      navigator.pop();
                    }

                    // Navigate to export screen
                    goRouter.push('/export/${widget.photoId}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004AC6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text(
                    'Export',
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Photo Preview Container (3:4 ratio) wrapped in RepaintBoundary for high-fidelity export
            RepaintBoundary(
              key: _previewKey,
              child: Container(
                decoration: BoxDecoration(
                  color: editorState.selectedBackground.color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        // Background Color Layer
                        Container(
                          color: editorState.selectedBackground.color,
                        ),

                        // Image Layer with Rotation (Alignment)
                        if (editorState.photo?.processedBytes != null || editorState.photo?.originalBytes != null)
                          Transform.rotate(
                            angle: editorState.rotationAngle * (pi / 180.0),
                            child: Image.memory(
                              editorState.photo!.processedBytes ?? editorState.photo!.originalBytes!,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Center(
                            child: Icon(
                              Icons.photo,
                              size: 64,
                              color: isDark ? Colors.white24 : Colors.grey.shade300,
                            ),
                          ),

                        // Suit Overlay Layer
                        if (editorState.selectedSuit != 'none')
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Transform.translate(
                              offset: Offset(editorState.suitDx, editorState.suitDy),
                              child: Transform.scale(
                                scale: editorState.suitScale,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onScaleStart: (details) {
                                    _baseScale = editorState.suitScale;
                                    _baseDx = editorState.suitDx;
                                    _baseDy = editorState.suitDy;
                                    _startFocalPoint = details.focalPoint;
                                  },
                                  onScaleUpdate: (details) {
                                    final double newScale = (_baseScale * details.scale).clamp(0.5, 3.0);
                                    final double newDx = _baseDx + (details.focalPoint.dx - _startFocalPoint.dx);
                                    final double newDy = _baseDy + (details.focalPoint.dy - _startFocalPoint.dy);
                                    
                                    ref.read(editorProvider.notifier).updateSuitScale(newScale);
                                    ref.read(editorProvider.notifier).updateSuitPosition(
                                      newDx.clamp(-200.0, 200.0),
                                      newDy.clamp(-200.0, 300.0),
                                    );
                                  },
                                  child: SuitWidget(
                                    type: _mapStringToSuitType(editorState.selectedSuit),
                                    width: 260,
                                    height: 260,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Processing indicator overlay
                        if (editorState.isProcessing)
                          Container(
                            color: Colors.black45,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),

                        // Floating overlays for Canvas Tools
                        Positioned(
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildFloatingToolIcon(Icons.zoom_in, () {}),
                                const SizedBox(width: 12),
                                _buildFloatingToolIcon(Icons.grid_4x4, () {}),
                                const SizedBox(width: 12),
                                _buildFloatingToolIcon(Icons.flip, () {}),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. Dynamic Control Panel according to active Tab index
            _buildTabControls(isDark, cardColor, dividerColor, editorState),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131B2E) : Colors.white,
          border: Border(
            top: BorderSide(color: dividerColor.withOpacity(0.5)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(0, Icons.aspect_ratio, 'Canvas'),
              _buildNavBarItem(1, Icons.face, 'Suits'),
              _buildNavBarItem(2, Icons.filter_vintage, 'Filters'),
              _buildNavBarItem(3, Icons.tune, 'Adjust'),
              _buildNavBarItem(4, Icons.fact_check, 'Checklist'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabControls(bool isDark, Color cardColor, Color dividerColor, EditorState editorState) {
    switch (_activeNavIndex) {
      case 0: // Canvas: Background and Straighten/Rotation
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CANVAS BACKGROUND',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Color(0xFF004AC6),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Custom Hex',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xFF004AC6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D2438) : const Color(0xFFF3F3F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: BackgroundColor.values.map((colorVal) {
                  final isSelected = editorState.selectedBackground == colorVal;
                  return GestureDetector(
                    onTap: () {
                      ref.read(editorProvider.notifier).changeBackground(colorVal);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF004AC6) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorVal.color,
                              border: Border.all(color: Colors.black12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          colorVal.name[0].toUpperCase() + colorVal.name.substring(1),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF004AC6)
                                : (isDark ? Colors.white60 : const Color(0xFF414755)),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ALIGNMENT & ROTATE (THẲNG NGƯỜI)',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Color(0xFF004AC6),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D2438) : const Color(0xFFF3F3F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Straighten photo',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13),
                      ),
                      Text(
                        '${editorState.rotationAngle.toStringAsFixed(1)}°',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004AC6),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: editorState.rotationAngle,
                    min: -15.0,
                    max: 15.0,
                    activeColor: const Color(0xFF004AC6),
                    onChanged: (val) {
                      ref.read(editorProvider.notifier).setRotationAngle(val);
                    },
                  ),
                ],
              ),
            ),
          ],
        );

      case 1: // Suits: Chosen Suit Type and Positioning sliders
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CHOOSE FORMAL WEAR (GHÉP ÁO VEST)',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Color(0xFF004AC6),
                  ),
                ),
                if (editorState.selectedSuit != 'none')
                  TextButton.icon(
                    onPressed: () {
                      final templates = OutfitLibraryService.getAllTemplates();
                      if (templates.isNotEmpty) {
                        _openGestureEditor(templates.first);
                      }
                    },
                    icon: const Icon(Icons.touch_app, size: 16),
                    label: const Text(
                      'Áo',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSuitOption('Không áo', 'none', Icons.block),
                  _buildSuitOption('Vest Nam Cổ Điển', 'men_classic', Icons.person),
                  _buildSuitOption('Vest Nam Hiện Đại', 'men_modern', Icons.person_outline),
                  _buildSuitOption('Blazer Nữ Sơ Mi', 'women_classic', Icons.person_2),
                  _buildSuitOption('Blazer Nữ Cổ V', 'women_modern', Icons.person_3),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (editorState.selectedSuit != 'none') ...[
              const Text(
                'ADJUST CLOTHES POSITION (CĂN CHỈNH ÁO)',
                style: TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Color(0xFF004AC6),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1D2438) : const Color(0xFFF3F3F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Scale Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kích thước (Scale)', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                        Text(
                          '${editorState.suitScale.toStringAsFixed(2)}x',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004AC6)),
                        ),
                      ],
                    ),
                    Slider(
                      value: editorState.suitScale.clamp(0.5, 3.0),
                      min: 0.5,
                      max: 3.0,
                      activeColor: const Color(0xFF004AC6),
                      onChanged: (val) {
                        ref.read(editorProvider.notifier).updateSuitScale(val);
                      },
                    ),
                    const SizedBox(height: 8),

                    // Vertical position (Y) Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dịch dọc (Position Y)', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                        Text(
                          editorState.suitDy.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004AC6)),
                        ),
                      ],
                    ),
                    Slider(
                      value: editorState.suitDy.clamp(-200.0, 300.0),
                      min: -200.0,
                      max: 300.0,
                      activeColor: const Color(0xFF004AC6),
                      onChanged: (val) {
                        ref.read(editorProvider.notifier).updateSuitPosition(editorState.suitDx, val);
                      },
                    ),
                    const SizedBox(height: 8),

                    // Horizontal position (X) Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dịch ngang (Position X)', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                        Text(
                          editorState.suitDx.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004AC6)),
                        ),
                      ],
                    ),
                    Slider(
                      value: editorState.suitDx.clamp(-200.0, 200.0),
                      min: -200.0,
                      max: 200.0,
                      activeColor: const Color(0xFF004AC6),
                      onChanged: (val) {
                        ref.read(editorProvider.notifier).updateSuitPosition(val, editorState.suitDy);
                      },
                    ),
                  ],
                ),
              ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1D2438) : const Color(0xFFF3F3F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Chọn một mẫu áo vest ở trên để ghép vào ảnh thẻ của bạn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        );

      case 2: // Filters
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PHOTO FILTERS (BỘ LỌC ẢNH)',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Color(0xFF004AC6),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterOption('Original'),
                  _buildFilterOption('Studio Light'),
                  _buildFilterOption('Warm Portrait'),
                  _buildFilterOption('Cool Accent'),
                  _buildFilterOption('Monochrome'),
                ],
              ),
            ),
          ],
        );

      case 3: // Manual Adjust
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MANUAL ADJUSTMENTS (TÙY CHỈNH THỦ CÔNG)',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Color(0xFF004AC6),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1D2438) : const Color(0xFFF3F3F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Brightness', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                      Text('100%', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004AC6))),
                    ],
                  ),
                  Slider(value: 1.0, min: 0.5, max: 1.5, activeColor: const Color(0xFF004AC6), onChanged: (val) {}),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Contrast', style: TextStyle(fontFamily: 'Inter', fontSize: 12)),
                      Text('100%', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004AC6))),
                    ],
                  ),
                  Slider(value: 1.0, min: 0.5, max: 1.5, activeColor: const Color(0xFF004AC6), onChanged: (val) {}),
                ],
              ),
            ),
          ],
        );

      case 4: // Checklist: Export Readiness Bento Grid
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.fact_check,
                  color: Color(0xFF006E28),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Export Readiness',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _buildBentoItem(
                  title: 'Face visible',
                  subtitle: 'Detection verified',
                  passed: editorState.validationResult?.faceSizeOk ?? true,
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                ),
                _buildBentoItem(
                  title: 'Good lighting',
                  subtitle: 'Optimal lux',
                  passed: editorState.validationResult?.lightingOk ?? true,
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                ),
                _buildBentoItem(
                  title: 'Neutral bg',
                  subtitle: 'Contrast high',
                  passed: editorState.validationResult?.backgroundOk ?? true,
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                ),
                _buildBentoItem(
                  title: 'Correct dim.',
                  subtitle: '300 DPI set',
                  passed: true,
                  cardColor: cardColor,
                  dividerColor: dividerColor,
                ),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildFloatingToolIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildSuitOption(String name, String value, IconData icon) {
    final editorState = ref.watch(editorProvider);
    final isSelected = editorState.selectedSuit == value;
    return GestureDetector(
      onTap: () {
        ref.read(editorProvider.notifier).selectSuit(value);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004AC6) : Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String name) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBentoItem({
    required String title,
    required String subtitle,
    required bool passed,
    required Color cardColor,
    required Color dividerColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: passed ? const Color(0xFFD4EDDA) : const Color(0xFFF8D7DA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              passed ? Icons.check : Icons.close,
              color: passed ? const Color(0xFF155724) : const Color(0xFF721C24),
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openGestureEditor(OutfitTemplate outfit) {
    final editorState = ref.read(editorProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: GestureEditor(
            outfit: outfit,
            photoBytes: editorState.photo?.processedBytes ?? editorState.photo?.originalBytes,
            backgroundColor: editorState.selectedBackground.color,
            onTransformChanged: (transform) {
              ref.read(editorProvider.notifier).updateSuitPosition(
                    transform.position.dx,
                    transform.position.dy,
                  );
              ref.read(editorProvider.notifier).updateSuitScale(transform.scale);
            },
            onConfirm: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index, IconData icon, String label) {
    final isActive = _activeNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeNavIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF6FFB85).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF00732A) : Colors.grey,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFF00732A) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
