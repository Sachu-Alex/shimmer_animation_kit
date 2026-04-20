import 'package:flutter/material.dart';

import 'shimmer_theme.dart';

/// Provides a single shared [AnimationController] to all descendant shimmer
/// widgets, ensuring they pulse in perfect sync.
///
/// Place [ShimmerScope] above any widget tree that contains shimmer widgets:
/// ```dart
/// ShimmerScope(
///   child: Column(
///     children: [
///       ShimmerBox(width: 200, height: 20),
///       ShimmerCircle(diameter: 48),
///     ],
///   ),
/// )
/// ```
///
/// When [MediaQueryData.disableAnimations] is `true` the controller is stopped
/// and [ShimmerScope.of] returns the static value `0.5` so that the shimmer
/// appears frozen at mid-point rather than invisible.
class ShimmerScope extends StatefulWidget {
  const ShimmerScope({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;

  /// Duration of one complete shimmer cycle. Defaults to 1500 ms.
  final Duration duration;

  /// Returns the current animation value (0.0 – 1.0) from the nearest
  /// [ShimmerScope] ancestor, or `0.5` if no scope is present.
  ///
  /// When no [ShimmerScope] is found the shimmer is shown frozen at mid-point.
  /// Wrap with [ShimmerScope] to get a live repeating animation.
  static double of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_ShimmerScopeInherited>();
    return inherited?.value ?? 0.5;
  }

  /// Returns the current animation value if a [ShimmerScope] ancestor exists,
  /// otherwise `null`.
  static double? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ShimmerScopeInherited>()
        ?.value;
  }

  @override
  State<ShimmerScope> createState() => _ShimmerScopeState();
}

class _ShimmerScopeState extends State<ShimmerScope>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Duration _effectiveDuration;

  @override
  void initState() {
    super.initState();
    _effectiveDuration = widget.duration;
    _controller = AnimationController(vsync: this, duration: _effectiveDuration)
      ..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncWithMediaQuery();

    // Also honour ShimmerTheme duration if no explicit duration provided.
    final theme = Theme.of(context).extension<ShimmerTheme>();
    if (theme != null && widget.duration == const Duration(milliseconds: 1500)) {
      if (_effectiveDuration != theme.duration) {
        _effectiveDuration = theme.duration;
        _controller.duration = _effectiveDuration;
        _syncWithMediaQuery();
      }
    }
  }

  void _syncWithMediaQuery() {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    if (disableAnimations) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _syncWithMediaQuery();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _ShimmerScopeInherited(
          value: _controller.value,
          child: child!,
        );
      },
      child: widget.child,
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
