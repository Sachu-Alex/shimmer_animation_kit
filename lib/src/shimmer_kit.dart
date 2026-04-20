import 'package:flutter/material.dart';

import 'shape_detector.dart';
import 'shimmer_direction.dart';
import 'shimmer_painter.dart';
import 'shimmer_scope.dart';
import 'shimmer_theme.dart';

/// The primary shimmer widget.
///
/// ### Recommended — explicit skeleton
///
/// Provide a [skeleton] built from [ShimmerBox], [ShimmerCircleWidget],
/// [ShimmerTextWidget] or any white-filled containers. [ShimmerKit] wraps it
/// in a [ShimmerScope] so the gradient flows across the whole layout:
///
/// ```dart
/// ShimmerKit(
///   isLoading: _loading,
///   skeleton: Column(
///     children: [
///       ShimmerBox(width: double.infinity, height: 180),
///       SizedBox(height: 12),
///       Row(children: [
///         ShimmerCircleWidget(diameter: 48),
///         SizedBox(width: 12),
///         ShimmerTextWidget(lines: 2, width: 160),
///       ]),
///     ],
///   ),
///   child: MyRealContent(),
/// )
/// ```
///
/// ### Fallback — auto-detect
///
/// Omit [skeleton] and [ShimmerKit] walks the [child] widget tree to infer
/// placeholder shapes. Works well for simple layouts; prefer the explicit
/// skeleton approach for complex screens.
class ShimmerKit extends StatelessWidget {
  const ShimmerKit({
    super.key,
    required this.child,
    required this.isLoading,
    this.skeleton,
    this.baseColor,
    this.highlightColor,
    this.direction,
    this.duration = const Duration(milliseconds: 1500),
  });

  /// The real content shown when [isLoading] is `false`.
  final Widget child;

  /// When `true` shows the shimmer skeleton; when `false` shows [child].
  final bool isLoading;

  /// Optional explicit skeleton layout. When provided, [ShimmerKit] wraps it
  /// in a [ShimmerScope] so the gradient covers the entire layout via
  /// [ShaderMask] — exactly like the popular `shimmer` package.
  ///
  /// Skeleton widgets should use white or opaque fills so the gradient is
  /// visible. [ShimmerBox], [ShimmerCircleWidget] and [ShimmerTextWidget]
  /// handle this automatically.
  final Widget? skeleton;

  /// Overrides [ShimmerTheme.baseColor] (auto-detect mode only).
  final Color? baseColor;

  /// Overrides [ShimmerTheme.highlightColor] (auto-detect mode only).
  final Color? highlightColor;

  /// Overrides [ShimmerTheme.direction] (auto-detect mode only).
  final ShimmerDirection? direction;

  /// Shimmer animation duration. Only used when no parent [ShimmerScope] is
  /// present. Prefer wrapping with [ShimmerScope] to sync multiple widgets.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    // ── Skeleton mode — like the shimmer package ───────────────────────────
    if (skeleton != null) {
      final scope = Semantics(
        label: 'Loading',
        excludeSemantics: true,
        child: skeleton!,
      );
      // Avoid double-wrapping if already inside a ShimmerScope.
      if (ShimmerScope.hasScope(context)) return scope;
      return ShimmerScope(duration: duration, child: scope);
    }

    // ── Auto-detect fallback ───────────────────────────────────────────────
    final theme = Theme.of(context).extension<ShimmerTheme>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? ShimmerTheme.dark
            : ShimmerTheme.light);

    final effectiveBase = baseColor ?? theme.baseColor;
    final effectiveHighlight = highlightColor ?? theme.highlightColor;
    final effectiveDirection = direction ?? theme.direction;

    final shapes = detectShapes(child);

    return Semantics(
      label: 'Loading',
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final animValue = ShimmerScope.of(context);
          return SizedBox(
            width: constraints.maxWidth.isFinite ? constraints.maxWidth : 200,
            height:
                constraints.maxHeight.isFinite ? constraints.maxHeight : 100,
            child: CustomPaint(
              painter: ShimmerPainter(
                shapes: shapes,
                animationValue: animValue,
                baseColor: effectiveBase,
                highlightColor: effectiveHighlight,
                direction: effectiveDirection,
              ),
            ),
          );
        },
      ),
    );
  }
}
