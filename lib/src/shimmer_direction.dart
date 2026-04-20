import 'package:flutter/widgets.dart';

/// Defines the direction in which the shimmer highlight travels.
enum ShimmerDirection {
  /// Highlight moves from left to right.
  leftToRight,

  /// Highlight moves from right to left.
  rightToLeft,

  /// Highlight moves from top to bottom.
  topToBottom,

  /// Highlight moves from bottom to top.
  bottomToTop,

  /// Highlight moves diagonally from top-left to bottom-right.
  diagonal;

  /// Returns a [LinearGradient] with [begin] and [end] alignments
  /// corresponding to this direction.
  LinearGradient toGradient({
    required List<Color> colors,
    required List<double> stops,
  }) {
    final (begin, end) = _alignments;
    return LinearGradient(begin: begin, end: end, colors: colors, stops: stops);
  }

  /// The [Alignment] pair (begin, end) for this direction.
  (Alignment, Alignment) get _alignments => switch (this) {
        ShimmerDirection.leftToRight => (Alignment.centerLeft, Alignment.centerRight),
        ShimmerDirection.rightToLeft => (Alignment.centerRight, Alignment.centerLeft),
        ShimmerDirection.topToBottom => (Alignment.topCenter, Alignment.bottomCenter),
        ShimmerDirection.bottomToTop => (Alignment.bottomCenter, Alignment.topCenter),
        ShimmerDirection.diagonal => (Alignment.topLeft, Alignment.bottomRight),
      };

  /// The raw begin alignment for this direction.
  Alignment get begin => _alignments.$1;

  /// The raw end alignment for this direction.
  Alignment get end => _alignments.$2;
}
