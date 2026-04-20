import 'package:flutter/material.dart';

import 'shape_detector.dart';
import 'shimmer_direction.dart';
import 'shimmer_painter.dart';
import 'shimmer_scope.dart';
import 'shimmer_theme.dart';

/// The primary shimmer widget.
///
/// Wrap any widget with [ShimmerKit] and toggle [isLoading] to switch between
/// the real content and an animated shimmer skeleton that matches its layout:
///
/// ```dart
/// ShimmerScope(
///   child: ShimmerKit(
///     isLoading: _loading,
///     child: MyProfileCard(),
///   ),
/// )
/// ```
///
/// When [isLoading] is `false` the [child] is rendered normally.
/// When [isLoading] is `true` the widget tree is analysed with `detectShapes`
/// and a [CustomPaint] shimmer overlay is shown in its place.
///
/// Colors default to [ShimmerTheme] from the nearest [Theme] if not provided.
class ShimmerKit extends StatelessWidget {
  const ShimmerKit({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
    this.direction,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;

  /// When `true` shows the shimmer skeleton; when `false` shows [child].
  final bool isLoading;

  /// Overrides [ShimmerTheme.baseColor].
  final Color? baseColor;

  /// Overrides [ShimmerTheme.highlightColor].
  final Color? highlightColor;

  /// Overrides [ShimmerTheme.direction].
  final ShimmerDirection? direction;

  /// Shimmer animation duration — only used when no parent [ShimmerScope] is
  /// present. Prefer wrapping with [ShimmerScope] to sync multiple widgets.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

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
          final animValue = _animationValue(context);
          return SizedBox(
            width: constraints.maxWidth.isFinite ? constraints.maxWidth : 200,
            height: constraints.maxHeight.isFinite ? constraints.maxHeight : 100,
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

  /// Reads animation value from [ShimmerScope] if present, otherwise 0.5.
  double _animationValue(BuildContext context) {
    try {
      return ShimmerScope.of(context);
    } catch (_) {
      return 0.5;
    }
  }
}
