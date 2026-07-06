import 'package:flutter/material.dart';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';

class SmartGuideOverlay extends StatelessWidget {
  final FaceDetectionResult? faceResult;
  final String? hintText;

  const SmartGuideOverlay({
    super.key,
    this.faceResult,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Semi-transparent overlay with oval cutout
        CustomPaint(
          size: Size.infinite,
          painter: _OverlayPainter(
            faceResult: faceResult,
          ),
        ),
        // Hint text at bottom
        if (hintText != null)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  hintText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final FaceDetectionResult? faceResult;

  _OverlayPainter({this.faceResult});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 30);
    final ovalWidth = size.width * 0.65;
    final ovalHeight = ovalWidth * 1.3;

    // Draw semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5);

    // Create path with oval cutout
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCenter(
        center: center,
        width: ovalWidth,
        height: ovalHeight,
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);

    // Draw oval border
    final borderPaint = Paint()
      ..color = faceResult?.isFrontal == true
          ? Colors.green.withOpacity(0.8)
          : Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: ovalWidth,
        height: ovalHeight,
      ),
      borderPaint,
    );

    // Draw eye level line
    final eyeY = center.dy - ovalHeight * 0.15;
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx - ovalWidth * 0.35, eyeY),
      Offset(center.dx + ovalWidth * 0.35, eyeY),
      linePaint,
    );

    // Draw mouth level line
    final mouthY = center.dy + ovalHeight * 0.25;
    canvas.drawLine(
      Offset(center.dx - ovalWidth * 0.35, mouthY),
      Offset(center.dx + ovalWidth * 0.35, mouthY),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
