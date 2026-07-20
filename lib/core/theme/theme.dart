import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color whiteColor = const Color(0xffFFFFFF);
Color primaryColor = const Color(0xff11998e);
MaterialColor primaryMaterialColor = MaterialColor(
  0xff11998e,
  <int, Color>{
    50: const Color(0xff11998e).withOpacity(0.1),
    100: const Color(0xff11998e).withOpacity(0.2),
    200: const Color(0xff11998e).withOpacity(0.3),
    300: const Color(0xff11998e).withOpacity(0.4),
    400: const Color(0xff11998e).withOpacity(0.5),
    500: const Color(0xff11998e).withOpacity(0.6),
    600: const Color(0xff11998e).withOpacity(0.7),
    700: const Color(0xff11998e).withOpacity(0.8),
    800: const Color(0xff11998e).withOpacity(0.9),
    900: const Color(0xff11998e).withOpacity(1.0),
  },
);
Color blackColor = const Color(0xff14193F);
Color greyColor = const Color(0xffA4A8AE);
Color lightBackgroundColor = const Color(0xffEBF4F3);
Color darkBackgroundColor = const Color(0xff020518);
Color blueColor = const Color(0xff53C1F9);
Color borderColor = const Color(0xff3783FB);
Color purpleColor = const Color(0xff5142E6);
Color greenColor = const Color(0xff22B07D);
Color numberBackgroundColor = const Color(0xff1A1D2E);
Color redColor = const Color(0xffFF2566);

const Color primary = Color(0xfff2f9fe);
const Color secondary = Color(0xFFdbe4f3);
const Color black2 = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);
const Color grey = Colors.grey;
const Color red = Color(0xFFec5766);
const Color green = Color(0xFF43aa8b);
const Color blue = Color(0xFF28c2ff);
const Color buttoncolor = Color(0xff3e4784);
const Color mainFontColor = Color(0xff565c95);
const Color arrowbgColor = Color(0xffe4e9f7);

TextStyle blackTextStyle = GoogleFonts.poppins(color: blackColor);
TextStyle whiteTextStyle = GoogleFonts.poppins(color: whiteColor);
TextStyle greyTextStyle = GoogleFonts.poppins(color: greyColor);
TextStyle blueTextStyle = GoogleFonts.poppins(color: blueColor);
TextStyle greenTextStyle = GoogleFonts.poppins(color: greenColor);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

class IslamicBackground extends StatelessWidget {
  final Widget child;
  const IslamicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: IslamicPatternPainter(
              color: Theme.of(context).primaryColor.withOpacity(0.04),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    const double cellSize = 70.0;
    for (double x = 0; x < size.width + cellSize; x += cellSize) {
      for (double y = 0; y < size.height + cellSize; y += cellSize) {
        _drawEightPointedStar(canvas, Offset(x, y), cellSize * 0.22, paint);
        canvas.drawCircle(Offset(x, y), cellSize * 0.11, paint);
      }
    }
  }

  void _drawEightPointedStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path1 = Path();
    final path2 = Path();
    
    for (int i = 0; i < 4; i++) {
      double angle1 = (i * 90) * math.pi / 180;
      double angle2 = (i * 90 + 45) * math.pi / 180;
      
      double x1 = center.dx + radius * math.cos(angle1);
      double y1 = center.dy + radius * math.sin(angle1);
      double x2 = center.dx + radius * math.cos(angle2);
      double y2 = center.dy + radius * math.sin(angle2);
      
      if (i == 0) {
        path1.moveTo(x1, y1);
        path2.moveTo(x2, y2);
      } else {
        path1.lineTo(x1, y1);
        path2.lineTo(x2, y2);
      }
    }
    path1.close();
    path2.close();
    
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
