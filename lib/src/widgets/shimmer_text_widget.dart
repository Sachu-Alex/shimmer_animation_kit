import 'package:flutter/material.dart';

import '../shimmer_direction.dart';
import '../shimmer_scope.dart';
import '../shimmer_theme.dart';

/// An animated shimmer text placeholder — stacked bars that mimic a paragraph.
///
/// **Inside a [ShimmerScope]** (recommended): renders solid white bars. The
/// parent [ShimmerScope] applies the animated gradient via [ShaderMask].
///
/// **Standalone**: renders static grey bars.
///
/// ```dart
/// ShimmerScope(
///   child: ShimmerTextWidget(lines: 3, width: 240),
/// )
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

  /// Width fraction (0–1) of the last line relative to [width].
  final double lastLineWidthFraction;

  final double width;
  final Color? baseColor;
  final Color? highlightColor;
  final ShimmerDirection? direction;

  @override
  Widget build(BuildContext context) {
    final inScope = ShimmerScope.hasScope(context);
    final fallbackColor = baseColor ??
        (Theme.of(context).extension<ShimmerTheme>() ?? ShimmerTheme.light)
            .baseColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (i) {
        final isLast = i == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : lineSpacing),
          child: Container(
            width: isLast ? width * lastLineWidthFraction : width,
            height: lineHeight,
            decoration: BoxDecoration(
              color: inScope ? Colors.white : fallbackColor,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
        );
      }),
    );
  }
}
