
import 'package:flutter/material.dart';

import '../models/raindrop.dart';

class RainDropsPainter extends CustomPainter {
  const RainDropsPainter({
    required this.drops,
    required this.blurMultiplier,
  });

  final List<Raindrop> drops;
  final double blurMultiplier;

  @override
  void paint(Canvas canvas, Size size) {
    for (final drop in drops) {
      final dx = drop.x * size.width;
      final dy = drop.y * size.height;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(drop.rotation);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: drop.w,
        height: drop.h,
      );

      final shadowPaint = Paint()
        ..color = const Color(0xFFB0C4DE).withOpacity(0.2 * drop.opacity)
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          4 * blurMultiplier,
        );
      canvas.drawOval(rect.translate(0, 3), shadowPaint);

      final rimPaint = Paint()
        ..color = const Color(0xFFADD8E6).withOpacity(0.4 * drop.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          2.5 * blurMultiplier,
        );
      canvas.drawOval(rect, rimPaint);

      final bodyPaint = Paint()
        ..color = Colors.white.withOpacity(0.05 * drop.opacity)
        ..blendMode = BlendMode.plus;
      canvas.drawOval(rect, bodyPaint);

      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.95 * drop.opacity);
      canvas.drawCircle(
        Offset(-drop.w * 0.22, -drop.h * 0.28),
        drop.w * 0.15,
        highlightPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant RainDropsPainter oldDelegate) {
    return oldDelegate.drops != drops ||
        oldDelegate.blurMultiplier != blurMultiplier;
  }
}
