import 'package:flutter/material.dart';

class ReviewBubbleIcon extends StatelessWidget {
  final double size;
  final Color color;

  const ReviewBubbleIcon({
    super.key,
    this.size = 24,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Calculate dimensions relative to the requested size
    final double totalWidth = size * 1.5;
    final double totalHeight = size * 1.2;
    final double starIconSize = size * 0.3; // Size of individual stars

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. The Bubble Outline (Custom Paint)
          CustomPaint(
            size: Size(totalWidth, totalHeight),
            painter: _BubblePainter(color: color, strokeWidth: 2.0),
          ),

          // 2. The Stars (Centered in the upper "body" part of the bubble)
          // We push them up slightly so they sit in the middle of the rectangle
          Positioned(
            top: (totalHeight - 6.0 - starIconSize) /
                2, // Vertically center in body
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.5),
                  child: Icon(
                    Icons.star_rounded,
                    size: starIconSize,
                    color: color,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints a rounded rectangle with a speech bubble tail at the bottom
class _BubblePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _BubblePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Dimensions
    final double r = 5.0; // Corner radius
    final double tailH = 5.0; // Height of the tail
    final double bodyH = size.height - tailH; // Height of the rectangular part

    // Start Top-Left
    path.moveTo(r, 0);
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);

    // Right Side
    path.lineTo(size.width, bodyH - r);
    path.quadraticBezierTo(size.width, bodyH, size.width - r, bodyH);

    // Bottom Side (with Tail)
    // Tail tip position (approx 70% to the right)
    final double tailX = size.width * 0.7;

    path.lineTo(tailX + 5, bodyH); // Start of tail
    path.lineTo(tailX, size.height); // Tip of tail
    path.lineTo(tailX - 3, bodyH); // End of tail

    path.lineTo(r, bodyH);
    // Bottom-Left Corner
    path.quadraticBezierTo(0, bodyH, 0, bodyH - r);

    // Left Side
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
