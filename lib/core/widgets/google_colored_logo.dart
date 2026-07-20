import 'package:flutter/material.dart';

class GoogleColoredLogo extends StatelessWidget {
  final double size;

  const GoogleColoredLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 48.0;
    canvas.scale(scale, scale);

    // 1. Red Path (Top Arc)
    final Paint redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final Path redPath = Path()
      ..moveTo(24, 9.5)
      ..cubicTo(27.54, 9.5, 30.71, 10.72, 33.21, 13.1)
      ..lineTo(40.06, 6.25)
      ..cubicTo(35.9, 2.38, 30.47, 0, 24, 0)
      ..cubicTo(14.66, 0, 6.51, 5.38, 2.56, 13.22)
      ..lineTo(10.54, 19.41)
      ..cubicTo(12.43, 13.72, 17.74, 9.5, 24, 9.5)
      ..close();
    canvas.drawPath(redPath, redPaint);

    // 2. Yellow Path (Left Arc)
    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final Path yellowPath = Path()
      ..moveTo(10.54, 28.59)
      ..cubicTo(10.06, 27.14, 9.78, 25.6, 9.78, 24)
      ..cubicTo(9.78, 22.4, 10.06, 20.86, 10.54, 19.41)
      ..lineTo(2.56, 13.22)
      ..cubicTo(0.92, 16.46, 0, 20.12, 0, 24)
      ..cubicTo(0, 27.88, 0.92, 31.54, 2.56, 34.78)
      ..lineTo(10.54, 28.59)
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // 3. Green Path (Bottom Arc)
    final Paint greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final Path greenPath = Path()
      ..moveTo(24, 38.5)
      ..cubicTo(17.74, 38.5, 12.43, 34.28, 10.54, 28.59)
      ..lineTo(2.56, 34.78)
      ..cubicTo(6.51, 42.62, 14.66, 48, 24, 48)
      ..cubicTo(30.48, 48, 35.93, 45.87, 39.89, 42.19)
      ..lineTo(32.16, 36.19)
      ..cubicTo(30.01, 37.64, 27.24, 38.5, 24, 38.5)
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // 4. Blue Path (Right Arc & Center Bar)
    final Paint bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final Path bluePath = Path()
      ..moveTo(46.1, 24.55)
      ..cubicTo(46.1, 22.98, 45.96, 21.46, 45.72, 20)
      ..lineTo(24, 20)
      ..lineTo(24, 29.02)
      ..lineTo(36.4, 29.02)
      ..cubicTo(35.87, 31.86, 34.27, 34.27, 31.87, 35.88)
      ..lineTo(39.6, 41.88)
      ..cubicTo(44.11, 37.7, 47, 31.51, 47, 24.55)
      ..close();
    canvas.drawPath(bluePath, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
