import 'package:flutter/material.dart';
import 'package:photo_id/core/theme/app_colors.dart';

class CropOverlay extends StatelessWidget {
  final double aspectRatio;
  final bool showGrid;

  const CropOverlay({
    super.key,
    this.aspectRatio = 3 / 4, // Default 3:4 for ID photos
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width / aspectRatio;

        return Stack(
          children: [
            // Semi-transparent overlay outside crop area
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _CropOverlayPainter(
                cropWidth: width,
                cropHeight: height,
                showGrid: showGrid,
              ),
            ),
            // Eye alignment lines
            if (showGrid)
              Positioned(
                top: constraints.maxHeight / 2 - height * 0.15,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ),
            // Center vertical line
            if (showGrid)
              Positioned(
                top: 0,
                bottom: 0,
                left: (constraints.maxWidth - width) / 2,
                child: Container(
                  width: 1,
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CropOverlayPainter extends CustomPainter {
  final double cropWidth;
  final double cropHeight;
  final bool showGrid;

  _CropOverlayPainter({
    required this.cropWidth,
    required this.cropHeight,
    required this.showGrid,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: cropWidth,
        height: cropHeight,
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);

    // Draw crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: cropWidth,
        height: cropHeight,
      ),
      borderPaint,
    );

    // Draw corner marks
    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final cornerLength = 20.0;
    final corners = [
      // Top-left
      Offset(centerX - cropWidth / 2, centerY - cropHeight / 2),
      // Top-right
      Offset(centerX + cropWidth / 2, centerY - cropHeight / 2),
      // Bottom-left
      Offset(centerX - cropWidth / 2, centerY + cropHeight / 2),
      // Bottom-right
      Offset(centerX + cropWidth / 2, centerY + cropHeight / 2),
    ];

    for (int i = 0; i < corners.length; i++) {
      final corner = corners[i];
      final isTop = i < 2;
      final isLeft = i % 2 == 0;

      canvas.drawLine(
        corner,
        Offset(
          corner.dx + (isLeft ? cornerLength : -cornerLength),
          corner.dy,
        ),
        cornerPaint,
      );
      canvas.drawLine(
        corner,
        Offset(
          corner.dx,
          corner.dy + (isTop ? cornerLength : -cornerLength),
        ),
        cornerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
