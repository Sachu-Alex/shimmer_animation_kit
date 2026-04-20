import 'package:flutter/material.dart';

import '../shimmer_direction.dart';
import '../shimmer_painter.dart';
import '../shimmer_scope.dart';
import '../shimmer_shapes.dart';
import '../shimmer_theme.dart';

/// A standalone animated shimmer circle.
///
/// Requires a [ShimmerScope] ancestor for animation sync. Falls back to the
/// [ShimmerTheme] in the nearest [Theme] for colors.
///
/// ```dart
/// ShimmerCircleWidget(diameter: 48)
/// ```
class ShimmerCircleWidget extends StatelessWidget {
  const ShimmerCircleWidget({
    super.key,
    required this.diameter,
    this.baseColor,
    this.highlightColor,
    this.direction,
  });

  final double diameter;
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
      size: Size(diameter, diameter),
      painter: ShimmerPainter(
        shapes: [ShimmerCircle(diameter: diameter)],
        animationValue: animValue,
        baseColor: baseColor ?? theme.baseColor,
        highlightColor: highlightColor ?? theme.highlightColor,
        direction: direction ?? theme.direction,
      ),
    );
  }
}
