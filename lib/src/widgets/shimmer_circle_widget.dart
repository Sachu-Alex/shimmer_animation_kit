import 'package:flutter/material.dart';

import '../shimmer_direction.dart';
import '../shimmer_scope.dart';
import '../shimmer_theme.dart';

/// An animated shimmer circle.
///
/// **Inside a [ShimmerScope]** (recommended): renders a solid white circle.
/// The parent [ShimmerScope] applies the animated gradient via [ShaderMask].
///
/// **Standalone**: renders a static placeholder filled with [baseColor].
///
/// ```dart
/// ShimmerScope(
///   child: Row(
///     children: [
///       ShimmerCircleWidget(diameter: 48),
///       SizedBox(width: 12),
///       ShimmerTextWidget(lines: 2, width: 160),
///     ],
///   ),
/// )
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
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ShimmerScope.hasScope(context)
            ? Colors.white
            : (baseColor ??
                (Theme.of(context).extension<ShimmerTheme>() ??
                        ShimmerTheme.light)
                    .baseColor),
      ),
    );
  }
}
