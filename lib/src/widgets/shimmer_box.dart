import 'package:flutter/material.dart';

import '../shimmer_direction.dart';
import '../shimmer_painter.dart';
import '../shimmer_scope.dart';
import '../shimmer_shapes.dart';
import '../shimmer_theme.dart';

/// A standalone animated shimmer rectangle.
///
/// Requires a [ShimmerScope] ancestor for animation sync. Falls back to the
/// [ShimmerTheme] in the nearest [Theme] for colors.
///
/// ```dart
/// ShimmerBox(width: 200, height: 16, borderRadius: BorderRadius.circular(8))
/// ```
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
    this.baseColor,
    this.highlightColor,
    this.direction,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final ShimmerDirection? direction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ShimmerTheme>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? ShimmerTheme.dark
            : ShimmerTheme.light);

    final animValue = ShimmerScope.of(context);

    return CustomPaint(
      size: Size(width, height),
      painter: ShimmerPainter(
        shapes: [
          ShimmerRectangle(
            width: width,
            height: height,
            borderRadius: borderRadius,
          ),
        ],
        animationValue: animValue,
        baseColor: baseColor ?? theme.baseColor,
        highlightColor: highlightColor ?? theme.highlightColor,
        direction: direction ?? theme.direction,
      ),
    );
  }
}
