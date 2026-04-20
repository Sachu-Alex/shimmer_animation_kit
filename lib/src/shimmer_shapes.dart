import 'package:flutter/widgets.dart';

/// A sealed base class for all shimmer shape descriptors.
///
/// Shapes describe the geometry that [ShimmerPainter] will render.
/// Use the concrete subclasses ([ShimmerRectangle], [ShimmerCircle],
/// [ShimmerText], [ShimmerGroup]) or obtain them automatically via
/// `detectShapes()`.
sealed class ShimmerShape {
  const ShimmerShape();

  /// Returns a list of `(Rect, BorderRadius?)` pairs that describe every
  /// individual rectangle the painter should draw, offset by [origin].
  List<(Rect, BorderRadius?)> toRects(Offset origin);
}

/// A rectangular shimmer placeholder, optionally with rounded corners.
///
/// ```dart
/// ShimmerRectangle(
///   width: 200,
///   height: 16,
///   borderRadius: BorderRadius.circular(4),
/// )
/// ```
class ShimmerRectangle extends ShimmerShape {
  /// Creates a rectangular shimmer with the given dimensions.
  const ShimmerRectangle({
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
  });

  /// Width of the rectangle in logical pixels.
  final double width;

  /// Height of the rectangle in logical pixels.
  final double height;

  /// Corner radii. Defaults to [BorderRadius.zero] (sharp corners).
  final BorderRadius borderRadius;

  @override
  List<(Rect, BorderRadius?)> toRects(Offset origin) {
    return [
      (Rect.fromLTWH(origin.dx, origin.dy, width, height), borderRadius),
    ];
  }
}

/// A circular shimmer placeholder.
///
/// ```dart
/// ShimmerCircle(diameter: 48)
/// ```
class ShimmerCircle extends ShimmerShape {
  /// Creates a circular shimmer with the given [diameter].
  const ShimmerCircle({required this.diameter});

  /// Diameter of the circle in logical pixels.
  final double diameter;

  @override
  List<(Rect, BorderRadius?)> toRects(Offset origin) {
    final r = diameter / 2;
    return [
      (
        Rect.fromLTWH(origin.dx, origin.dy, diameter, diameter),
        BorderRadius.circular(r),
      ),
    ];
  }
}

/// A multi-line text shimmer placeholder.
///
/// Renders [lines] stacked rectangles that mimic a paragraph of text, with
/// the last line shortened to [lastLineWidthFraction] of full width.
///
/// ```dart
/// ShimmerText(lines: 3, lineHeight: 12, lineSpacing: 6)
/// ```
class ShimmerText extends ShimmerShape {
  /// Creates a text shimmer placeholder.
  const ShimmerText({
    this.lines = 3,
    this.lineHeight = 12.0,
    this.lineSpacing = 6.0,
    this.lastLineWidthFraction = 0.6,
    this.width = 200.0,
  });

  /// Number of text lines to render.
  final int lines;

  /// Height of each line rectangle in logical pixels.
  final double lineHeight;

  /// Vertical gap between consecutive lines in logical pixels.
  final double lineSpacing;

  /// Width fraction (0.0–1.0) applied to the last line so it looks natural.
  final double lastLineWidthFraction;

  /// Total available width. Full lines fill this; last line is a fraction.
  final double width;

  @override
  List<(Rect, BorderRadius?)> toRects(Offset origin) {
    final rects = <(Rect, BorderRadius?)>[];
    const radius = BorderRadius.all(Radius.circular(2));
    for (var i = 0; i < lines; i++) {
      final y = origin.dy + i * (lineHeight + lineSpacing);
      final w = (i == lines - 1) ? width * lastLineWidthFraction : width;
      rects.add((Rect.fromLTWH(origin.dx, y, w, lineHeight), radius));
    }
    return rects;
  }
}

/// A group of [ShimmerShape]s laid out along a single [axis] with [spacing].
///
/// ```dart
/// ShimmerGroup(
///   axis: Axis.horizontal,
///   spacing: 8,
///   children: [ShimmerCircle(diameter: 40), ShimmerRectangle(width: 120, height: 16)],
/// )
/// ```
class ShimmerGroup extends ShimmerShape {
  /// Creates a group of shapes arranged along [axis].
  const ShimmerGroup({
    required this.children,
    this.axis = Axis.vertical,
    this.spacing = 8.0,
  });

  /// The child shapes in this group.
  final List<ShimmerShape> children;

  /// Whether children are laid out horizontally or vertically.
  final Axis axis;

  /// Gap between consecutive children in logical pixels.
  final double spacing;

  @override
  List<(Rect, BorderRadius?)> toRects(Offset origin) {
    final result = <(Rect, BorderRadius?)>[];
    var cursor = origin;

    for (final child in children) {
      final childRects = child.toRects(cursor);
      result.addAll(childRects);

      if (childRects.isNotEmpty) {
        final bounds = childRects.fold<Rect>(
          childRects.first.$1,
          (acc, r) => acc.expandToInclude(r.$1),
        );
        if (axis == Axis.horizontal) {
          cursor = Offset(cursor.dx + bounds.width + spacing, cursor.dy);
        } else {
          cursor = Offset(cursor.dx, cursor.dy + bounds.height + spacing);
        }
      }
    }
    return result;
  }
}
