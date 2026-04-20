import 'package:flutter/material.dart';

import '../shimmer_direction.dart';
import '../shimmer_scope.dart';
import '../shimmer_theme.dart';

/// An animated shimmer rectangle.
///
/// **Inside a [ShimmerScope]** (recommended): renders a solid white box. The
/// parent [ShimmerScope] applies the animated gradient via [ShaderMask] —
/// zero per-frame rebuild cost, perfect sync with every other shimmer widget.
///
/// **Standalone** (no [ShimmerScope] ancestor): renders a static placeholder
/// filled with [baseColor]. Wrap with [ShimmerScope] for live animation.
///
/// ```dart
/// ShimmerScope(
///   child: Column(
///     children: [
///       ShimmerBox(width: double.infinity, height: 180),
///       SizedBox(height: 12),
///       ShimmerBox(width: 200, height: 16, borderRadius: BorderRadius.circular(4)),
///     ],
///   ),
/// )
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

  /// Overrides [ShimmerTheme.baseColor]. Only used when **not** inside a
  /// [ShimmerScope] (standalone mode).
  final Color? baseColor;

  /// Unused when inside a [ShimmerScope] — kept for API consistency.
  final Color? highlightColor;

  /// Unused when inside a [ShimmerScope] — kept for API consistency.
  final ShimmerDirection? direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        // White inside ShimmerScope: the parent ShaderMask tints it with the
        // gradient. Base color standalone: visible static placeholder.
        color: ShimmerScope.hasScope(context)
            ? Colors.white
            : (baseColor ??
                (Theme.of(context).extension<ShimmerTheme>() ??
                        ShimmerTheme.light)
                    .baseColor),
        borderRadius: borderRadius,
      ),
    );
  }
}
