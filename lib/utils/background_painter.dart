import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  final double animation;
  BackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withAlpha(13)
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 1; i <= 3; i++) {
      double factor = i * 0.2;
      double offset = animation * 200 * factor;
      path.moveTo(0, size.height * (0.2 + 0.15 * i) + offset);
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * (0.3 + 0.15 * i) + offset,
        size.width * 0.5,
        size.height * (0.2 + 0.15 * i) + offset,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * (0.1 + 0.15 * i) + offset,
        size.width,
        size.height * (0.2 + 0.15 * i) + offset,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
