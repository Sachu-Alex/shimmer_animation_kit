import 'package:flutter/material.dart';

import '../shimmer_direction.dart';
import '../shimmer_painter.dart';
import '../shimmer_scope.dart';
import '../shimmer_shapes.dart';
import '../shimmer_theme.dart';

/// A standalone animated shimmer text placeholder.
///
/// Renders [lines] stacked shimmer bars that mimic a paragraph of text.
/// Requires a [ShimmerScope] ancestor for animation sync.
///
/// ```dart
/// ShimmerTextWidget(lines: 3, lineHeight: 12, lineSpacing: 6)
/// ```
class ShimmerTextWidget extends StatelessWidget {
  const ShimmerTextWidget({
    super.key,
    this.lines = 3,
    this.lineHeight = 12.0,
    this.lineSpacing = 6.0,
    this.lastLineWidthFraction = 0.6,
    this.width = 200.0,
    this.baseColor,
    this.highlightColor,
    this.direction,
  });

  final int lines;
  final double lineHeight;
  final double lineSpacing;
  final double lastLineWidthFraction;
  final double width;
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
    final totalHeight =
        lines * lineHeight + (lines - 1).clamp(0, lines) * lineSpacing;

    final shape = ShimmerText(
      lines: lines,
      lineHeight: lineHeight,
      lineSpacing: lineSpacing,
      lastLineWidthFraction: lastLineWidthFraction,
      width: width,
    );

    return CustomPaint(
      size: Size(width, totalHeight),
      painter: ShimmerPainter(
        shapes: [shape],
        animationValue: animValue,
        baseColor: baseColor ?? theme.baseColor,
        highlightColor: highlightColor ?? theme.highlightColor,
        direction: direction ?? theme.direction,
      ),
    );
  }
}
