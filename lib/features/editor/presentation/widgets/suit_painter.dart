import 'package:flutter/material.dart';

enum SuitType {
  none,
  menClassic,
  menModern,
  womenClassic,
  womenModern,
}

class SuitPainter extends CustomPainter {
  final SuitType type;
  final Color jacketColor;
  final Color shirtColor;
  final Color tieColor;

  SuitPainter({
    required this.type,
    this.jacketColor = const Color(0xFF1B223C),
    this.shirtColor = Colors.white,
    this.tieColor = const Color(0xFFC62828), // Dark Red
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (type == SuitType.none) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final width = size.width;
    final height = size.height;

    // We draw relative to a 100x100 grid for simplicity
    canvas.save();
    canvas.scale(width / 100, height / 100);

    if (type == SuitType.menClassic || type == SuitType.menModern) {
      _paintMenSuit(canvas, paint);
    } else if (type == SuitType.womenClassic || type == SuitType.womenModern) {
      _paintWomenSuit(canvas, paint);
    }

    canvas.restore();
  }

  void _paintMenSuit(Canvas canvas, Paint paint) {
    // 1. Draw Shoulders & Jacket body
    paint.color = jacketColor;
    final jacketPath = Path()
      ..moveTo(0, 75) // Left shoulder bottom
      ..quadraticBezierTo(10, 45, 25, 45) // Left shoulder top
      ..lineTo(38, 52) // Left neck point
      ..lineTo(38, 85) // Left inner opening
      ..lineTo(50, 100) // V center bottom
      ..lineTo(62, 85) // Right inner opening
      ..lineTo(62, 52) // Right neck point
      ..lineTo(75, 45) // Right shoulder top
      ..quadraticBezierTo(90, 45, 100, 75) // Right shoulder bottom
      ..lineTo(100, 100)
      ..lineTo(0, 100)
      ..close();
    canvas.drawPath(jacketPath, paint);

    // 2. Draw Shirt (White V-Neck)
    paint.color = shirtColor;
    final shirtPath = Path()
      ..moveTo(38, 52) // Left neck point
      ..lineTo(50, 52) // Top neck center
      ..lineTo(62, 52) // Right neck point
      ..lineTo(50, 85) // Bottom of shirt V
      ..close();
    canvas.drawPath(shirtPath, paint);

    // 3. Draw Tie
    paint.color = type == SuitType.menClassic ? tieColor : const Color(0xFF0D47A1); // Red or Blue tie
    final tiePath = Path()
      ..moveTo(47, 56) // Top left of tie knot
      ..lineTo(53, 56) // Top right of tie knot
      ..lineTo(52, 62) // Bottom right of knot
      ..lineTo(48, 62) // Bottom left of knot
      ..close();
    canvas.drawPath(tiePath, paint);

    final tieBodyPath = Path()
      ..moveTo(48, 62)
      ..lineTo(52, 62)
      ..lineTo(54, 88)
      ..lineTo(50, 95) // Tie tip
      ..lineTo(46, 88)
      ..close();
    canvas.drawPath(tieBodyPath, paint);

    // 4. Draw Lapels (Vest Lapels for 3D look)
    paint.color = jacketColor.withRed((jacketColor.red + 15).clamp(0, 255)).withGreen((jacketColor.green + 15).clamp(0, 255)).withBlue((jacketColor.blue + 25).clamp(0, 255));
    
    // Left Lapel
    final leftLapel = Path()
      ..moveTo(25, 45)
      ..lineTo(38, 52)
      ..lineTo(38, 80)
      ..lineTo(28, 65)
      ..close();
    canvas.drawPath(leftLapel, paint);

    // Right Lapel
    final rightLapel = Path()
      ..moveTo(75, 45)
      ..lineTo(62, 52)
      ..lineTo(62, 80)
      ..lineTo(72, 65)
      ..close();
    canvas.drawPath(rightLapel, paint);
  }

  void _paintWomenSuit(Canvas canvas, Paint paint) {
    // 1. Draw Shoulders & Jacket body
    paint.color = type == SuitType.womenClassic ? jacketColor : const Color(0xFF37474F); // Dark blue or grey blazer
    final jacketPath = Path()
      ..moveTo(0, 75)
      ..quadraticBezierTo(10, 48, 25, 48)
      ..lineTo(35, 55)
      ..lineTo(35, 80)
      ..lineTo(50, 100) // Lower V neck
      ..lineTo(65, 80)
      ..lineTo(65, 55)
      ..lineTo(75, 48)
      ..quadraticBezierTo(90, 48, 100, 75)
      ..lineTo(100, 100)
      ..lineTo(0, 100)
      ..close();
    canvas.drawPath(jacketPath, paint);

    // 2. Draw Inner blouse (White or light color)
    paint.color = shirtColor;
    final blousePath = Path()
      ..moveTo(35, 55)
      ..quadraticBezierTo(50, 60, 65, 55)
      ..lineTo(50, 85)
      ..close();
    canvas.drawPath(blousePath, paint);

    // 3. Draw necklace or accent detail for women's modern outfit
    if (type == SuitType.womenModern) {
      paint.color = const Color(0xFFFFD700); // Gold necklace line
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.0;
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(50, 56), radius: 10),
        0.2,
        2.74,
        false,
        paint,
      );
      paint.style = PaintingStyle.fill;
    }

    // 4. Draw Lapels (Vest Lapels for 3D look)
    paint.color = paint.color = type == SuitType.womenClassic 
        ? const Color(0xFF2A3454) 
        : const Color(0xFF455A64);
    
    // Left Lapel
    final leftLapel = Path()
      ..moveTo(25, 48)
      ..lineTo(35, 55)
      ..lineTo(44, 82)
      ..lineTo(32, 70)
      ..close();
    canvas.drawPath(leftLapel, paint);

    // Right Lapel
    final rightLapel = Path()
      ..moveTo(75, 48)
      ..lineTo(65, 55)
      ..lineTo(56, 82)
      ..lineTo(68, 70)
      ..close();
    canvas.drawPath(rightLapel, paint);
  }

  @override
  bool shouldRepaint(covariant SuitPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.jacketColor != jacketColor ||
        oldDelegate.shirtColor != shirtColor ||
        oldDelegate.tieColor != tieColor;
  }
}

class SuitWidget extends StatelessWidget {
  final SuitType type;
  final double width;
  final double height;

  const SuitWidget({
    super.key,
    required this.type,
    this.width = 300,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (type == SuitType.none) return const SizedBox.shrink();

    String assetName;
    switch (type) {
      case SuitType.menClassic:
        assetName = 'men_classic.png';
        break;
      case SuitType.menModern:
        assetName = 'men_modern.png';
        break;
      case SuitType.womenClassic:
        assetName = 'women_classic.png';
        break;
      case SuitType.womenModern:
        assetName = 'women_modern.png';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Image.asset(
      'assets/images/$assetName',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
