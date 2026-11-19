import 'package:flutter/material.dart';

import 'neumorphic_theme.dart';

class SaudaListLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isHorizontal;

  const SaudaListLogo({
    super.key,
    this.size = 80,
    this.showText = true,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final logoIcon = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.12),
      decoration: NeumorphicStyles.raised(
        radius: size * 0.28,
        backgroundColor: NeumorphicColors.background,
      ),
      child: CustomPaint(painter: _SaudaListLogoPainter()),
    );

    if (!showText) return logoIcon;

    final textWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isHorizontal
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Sauda',
                style: TextStyle(
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.w900,
                  color: NeumorphicColors.primaryGreen,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'List',
                style: TextStyle(
                  fontSize: size * 0.38,
                  fontWeight: FontWeight.w900,
                  color: NeumorphicColors.accentOrange,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size * 0.04),
        Text(
          'Smart Grocery List',
          style: TextStyle(
            fontSize: size * 0.16,
            fontWeight: FontWeight.w600,
            color: NeumorphicColors.textSecondary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );

    if (isHorizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoIcon,
          SizedBox(width: size * 0.18),
          textWidget,
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoIcon,
        SizedBox(height: size * 0.15),
        textWidget,
      ],
    );
  }
}

class _SaudaListLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.08;

    final greenPaint = Paint()
      ..color = NeumorphicColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final orangePaint = Paint()
      ..color = NeumorphicColors.accentOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.85
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Draw Green Shopping Bag Handle
    final handlePath = Path();
    handlePath.addArc(
      Rect.fromLTWH(
        size.width * 0.28,
        size.height * 0.02,
        size.width * 0.44,
        size.height * 0.38,
      ),
      3.14,
      3.14,
    );
    canvas.drawPath(handlePath, greenPaint);

    // 2. Draw Green Shopping Bag Body
    final bagPath = Path()
      ..moveTo(size.width * 0.22, size.height * 0.32)
      ..lineTo(size.width * 0.78, size.height * 0.32)
      ..lineTo(size.width * 0.88, size.height * 0.92)
      ..arcToPoint(
        Offset(size.width * 0.80, size.height * 0.96),
        radius: Radius.circular(size.width * 0.08),
      )
      ..lineTo(size.width * 0.20, size.height * 0.96)
      ..arcToPoint(
        Offset(size.width * 0.12, size.height * 0.92),
        radius: Radius.circular(size.width * 0.08),
      )
      ..close();
    canvas.drawPath(bagPath, greenPaint);

    // 3. Draw Orange Receipt inside Bag
    final receiptLeft = size.width * 0.34;
    final receiptRight = size.width * 0.66;
    final receiptTop = size.height * 0.26;

    final receiptPath = Path()
      ..moveTo(receiptLeft, receiptTop)
      ..lineTo(receiptRight, receiptTop)
      ..lineTo(receiptRight, size.height * 0.78)
      // Zigzag bottom
      ..lineTo(size.width * 0.60, size.height * 0.84)
      ..lineTo(size.width * 0.54, size.height * 0.78)
      ..lineTo(size.width * 0.46, size.height * 0.84)
      ..lineTo(size.width * 0.40, size.height * 0.78)
      ..lineTo(receiptLeft, size.height * 0.84)
      ..close();
    canvas.drawPath(receiptPath, orangePaint);

    // 4. Draw Checkmarks and Lines on Receipt
    final checkPositions = [0.38, 0.48, 0.58];
    for (final pos in checkPositions) {
      final y = size.height * pos;

      // Checkmark (v)
      final checkPath = Path()
        ..moveTo(size.width * 0.39, y + size.height * 0.02)
        ..lineTo(size.width * 0.43, y + size.height * 0.04)
        ..lineTo(size.width * 0.48, y - size.height * 0.01);
      canvas.drawPath(checkPath, orangePaint);

      // Horizontal line (—)
      canvas.drawLine(
        Offset(size.width * 0.54, y + size.height * 0.02),
        Offset(size.width * 0.61, y + size.height * 0.02),
        orangePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
