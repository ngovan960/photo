import 'package:flutter/material.dart';
import 'package:photo_id/core/theme/app_colors.dart';

class GuideOverlay extends StatelessWidget {
  final double faceWidth;
  final double faceHeight;

  const GuideOverlay({
    super.key,
    this.faceWidth = 200,
    this.faceHeight = 260,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _GuidePainter(
        faceWidth: faceWidth,
        faceHeight: faceHeight,
      ),
    );
  }
}

class _GuidePainter extends CustomPainter {
  final double faceWidth;
  final double faceHeight;

  _GuidePainter({
    required this.faceWidth,
    required this.faceHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 20);

    // Semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5);

    // Clear oval area
    final ovalPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCenter(
        center: center,
        width: faceWidth,
        height: faceHeight,
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(ovalPath, overlayPaint);

    // Oval border
    final borderPaint = Paint()
      ..color = AppColors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: faceWidth,
        height: faceHeight,
      ),
      borderPaint,
    );

    // Eye level line (dashed)
    final eyeY = center.dy - faceHeight * 0.15;
    _drawDashedLine(
      canvas,
      Offset(center.dx - faceWidth * 0.35, eyeY),
      Offset(center.dx + faceWidth * 0.35, eyeY),
      AppColors.white.withOpacity(0.5),
    );

    // Mouth level line (dashed)
    final mouthY = center.dy + faceHeight * 0.25;
    _drawDashedLine(
      canvas,
      Offset(center.dx - faceWidth * 0.35, mouthY),
      Offset(center.dx + faceWidth * 0.35, mouthY),
      AppColors.white.withOpacity(0.5),
    );

    // Center vertical line (dashed)
    _drawDashedLine(
      canvas,
      Offset(center.dx, center.dy - faceHeight * 0.4),
      Offset(center.dx, center.dy + faceHeight * 0.4),
      AppColors.white.withOpacity(0.3),
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final distance = (end - start).distance;
    final dashWidth = 5.0;
    final dashSpace = 5.0;
    final steps = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < steps; i++) {
      final startOffset = Offset(
        start.dx + (end.dx - start.dx) * i / steps,
        start.dy + (end.dy - start.dy) * i / steps,
      );
      final endOffset = Offset(
        start.dx + (end.dx - start.dx) * (i + 0.5) / steps,
        start.dy + (end.dy - start.dy) * (i + 0.5) / steps,
      );
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
