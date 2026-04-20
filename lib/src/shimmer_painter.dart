import 'package:flutter/widgets.dart';

import 'shimmer_direction.dart';
import 'shimmer_shapes.dart';

/// A [CustomPainter] that renders one or more [ShimmerShape]s with an
/// animated gradient highlight.
///
/// The gradient shift is driven by [animationValue] (0.0 – 1.0), which
/// should come from a [ShimmerScope].
class ShimmerPainter extends CustomPainter {
  const ShimmerPainter({
    required this.shapes,
    required this.animationValue,
    required this.baseColor,
    required this.highlightColor,
    required this.direction,
  });

  final List<ShimmerShape> shapes;
  final double animationValue;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // Build a gradient that shifts across the surface based on animationValue.
    // We extend the gradient by one extra copy on each side so the highlight
    // slides smoothly without a hard edge at 0.0 and 1.0.
    final double shift = animationValue;
    final gradient = direction.toGradient(
      colors: [baseColor, highlightColor, baseColor],
      stops: [
        (shift - 0.3).clamp(0.0, 1.0),
        shift.clamp(0.0, 1.0),
        (shift + 0.3).clamp(0.0, 1.0),
      ],
    );

    final gradientRect = Rect.fromLTWH(0, 0, size.width, size.height);

    for (final shape in shapes) {
      final rects = shape.toRects(Offset.zero);
      for (final (rect, borderRadius) in rects) {
        canvas.save();

        // Clip to this shape so the gradient is masked to its boundary.
        if (borderRadius != null && borderRadius != BorderRadius.zero) {
          canvas.clipRRect(borderRadius.toRRect(rect));
        } else {
          canvas.clipRect(rect);
        }

        paint.shader = gradient.createShader(gradientRect);
        canvas.drawRect(gradientRect, paint);

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(ShimmerPainter old) =>
      old.animationValue != animationValue ||
      old.baseColor != baseColor ||
      old.highlightColor != highlightColor ||
      old.direction != direction ||
      old.shapes != shapes;
}
