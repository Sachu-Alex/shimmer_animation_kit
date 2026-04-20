import 'package:flutter/material.dart';

import 'shimmer_theme.dart';

/// Provides a single shared [AnimationController] to all descendant shimmer
/// widgets and applies a [ShaderMask] gradient across the entire subtree.
///
/// Place [ShimmerScope] around any widget that should shimmer — typically a
/// skeleton placeholder layout built from [ShimmerBox], [ShimmerCircleWidget],
/// [ShimmerTextWidget], or custom white-filled containers:
///
/// ```dart
/// ShimmerScope(
///   child: Column(
///     children: [
///       ShimmerBox(width: double.infinity, height: 180),
///       ShimmerBox(width: 200, height: 20),
///       ShimmerCircleWidget(diameter: 48),
///     ],
///   ),
/// )
/// ```
///
/// Because the gradient is applied once at this level via [ShaderMask], every
/// child is animated in perfect sync with zero per-widget rebuild cost.
///
/// When [MediaQueryData.disableAnimations] is `true` the controller is stopped
/// and a static mid-point shimmer is shown.
class ShimmerScope extends StatefulWidget {
  const ShimmerScope({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;

  /// Duration of one complete shimmer cycle. Defaults to 1 500 ms.
  final Duration duration;

  /// Returns the current animation value (0.0–1.0) from the nearest
  /// [ShimmerScope], or `0.5` when no scope is present.
  static double of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<_ShimmerScopeInherited>()
            ?.value ??
        0.5;
  }

  /// Returns the animation value if a [ShimmerScope] ancestor exists,
  /// otherwise `null`.
  static double? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ShimmerScopeInherited>()
        ?.value;
  }

  /// Returns `true` if a [ShimmerScope] ancestor is present **without**
  /// subscribing to its updates (no per-frame rebuild side-effect).
  static bool hasScope(BuildContext context) {
    return context
            .getElementForInheritedWidgetOfExactType<_ShimmerScopeInherited>() !=
        null;
  }

  @override
  State<ShimmerScope> createState() => _ShimmerScopeState();
}

class _ShimmerScopeState extends State<ShimmerScope>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    if (disableAnimations) {
      _controller
        ..stop()
        ..value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerScope old) {
    super.didUpdateWidget(old);
    if (old.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ShimmerTheme>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? ShimmerTheme.dark
            : ShimmerTheme.light);

    return AnimatedBuilder(
      animation: _controller,
      // widget.child is cached — it never rebuilds due to animation ticks.
      child: widget.child,
      builder: (context, child) {
        final value = _controller.value;

        // Shift the three-stop gradient across the surface each frame.
        final gradient = theme.direction.toGradient(
          colors: [theme.baseColor, theme.highlightColor, theme.baseColor],
          stops: [
            (value - 0.3).clamp(0.0, 1.0),
            value.clamp(0.0, 1.0),
            (value + 0.3).clamp(0.0, 1.0),
          ],
        );

        return _ShimmerScopeInherited(
          value: value,
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: child!,
          ),
        );
      },
    );
  }
}

class _ShimmerScopeInherited extends InheritedWidget {
  const _ShimmerScopeInherited({
    required this.value,
    required super.child,
  });

  final double value;

  @override
  bool updateShouldNotify(_ShimmerScopeInherited old) => old.value != value;
}
