import 'package:flutter/material.dart';

import 'shimmer_direction.dart';

/// A [ThemeExtension] that controls the visual appearance of shimmer widgets.
///
/// Attach to [ThemeData.extensions] to apply shimmer defaults app-wide:
/// ```dart
/// ThemeData(
///   extensions: [ShimmerTheme.light],
/// )
/// ```
class ShimmerTheme extends ThemeExtension<ShimmerTheme> {
  const ShimmerTheme({
    required this.baseColor,
    required this.highlightColor,
    required this.duration,
    required this.direction,
  });

  /// The base (background) color of the shimmer.
  final Color baseColor;

  /// The bright highlight color that travels across the shimmer.
  final Color highlightColor;

  /// How long one full shimmer cycle takes.
  final Duration duration;

  /// The direction the highlight travels.
  final ShimmerDirection direction;

  /// Default light-mode shimmer theme.
  static const ShimmerTheme light = ShimmerTheme(
    baseColor: Color(0xFFE0E0E0),
    highlightColor: Color(0xFFF5F5F5),
    duration: Duration(milliseconds: 1500),
    direction: ShimmerDirection.leftToRight,
  );

  /// Default dark-mode shimmer theme.
  static const ShimmerTheme dark = ShimmerTheme(
    baseColor: Color(0xFF2C2C2C),
    highlightColor: Color(0xFF3D3D3D),
    duration: Duration(milliseconds: 1500),
    direction: ShimmerDirection.leftToRight,
  );

  @override
  ShimmerTheme copyWith({
    Color? baseColor,
    Color? highlightColor,
    Duration? duration,
    ShimmerDirection? direction,
  }) {
    return ShimmerTheme(
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      duration: duration ?? this.duration,
      direction: direction ?? this.direction,
    );
  }

  @override
  ShimmerTheme lerp(ShimmerTheme? other, double t) {
    if (other == null) return this;
    return ShimmerTheme(
      baseColor: Color.lerp(baseColor, other.baseColor, t)!,
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t)!,
      duration: Duration(
        microseconds: (duration.inMicroseconds +
                (other.duration.inMicroseconds - duration.inMicroseconds) * t)
            .round(),
      ),
      direction: t < 0.5 ? direction : other.direction,
    );
  }
}
