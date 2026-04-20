import 'package:flutter/material.dart';

import 'shimmer_shapes.dart';

/// Walks [widget]'s subtree up to [maxDepth] levels deep and returns a list
/// of [ShimmerShape]s that approximate its visual layout.
///
/// Recognition is performed purely via `is` type checks — no reflection or
/// `dart:mirrors` are used. Unrecognised widget types produce an empty list.
///
/// Example:
/// ```dart
/// final shapes = detectShapes(myProfileCard);
/// ```
List<ShimmerShape> detectShapes(Widget widget, {int maxDepth = 10}) {
  return _detect(widget, maxDepth);
}

List<ShimmerShape> _detect(Widget widget, int depth) {
  if (depth <= 0) return [];

  // ── Transparent pass-through widgets ──────────────────────────────────────
  if (widget is Padding) {
    return _detect(widget.child ?? const SizedBox(), depth - 1);
  }
  if (widget is Center) {
    return _detect(widget.child ?? const SizedBox(), depth - 1);
  }
  if (widget is Align) {
    return _detect(widget.child ?? const SizedBox(), depth - 1);
  }
  if (widget is SafeArea) {
    return _detect(widget.child, depth - 1);
  }
  if (widget is Material) {
    return _detect(widget.child ?? const SizedBox(), depth - 1);
  }
  if (widget is InkWell) {
    return _detect(widget.child ?? const SizedBox(), depth - 1);
  }

  // ── ClipRRect → rectangle with its border radius ─────────────────────────
  if (widget is ClipRRect) {
    final br = widget.borderRadius;
    final childShapes = _detect(widget.child ?? const SizedBox(), depth - 1);
    if (childShapes.isNotEmpty) return childShapes;
    return [
      ShimmerRectangle(
        width: 100,
        height: 100,
        borderRadius: (br is BorderRadius) ? br : BorderRadius.zero,
      ),
    ];
  }

  // ── CircleAvatar → circle ─────────────────────────────────────────────────
  if (widget is CircleAvatar) {
    final diameter = (widget.radius ?? 20) * 2;
    return [ShimmerCircle(diameter: diameter)];
  }

  // ── Container ─────────────────────────────────────────────────────────────
  if (widget is Container) {
    final decoration = widget.decoration;
    final w = widget.constraints?.maxWidth ?? 100.0;
    final h = widget.constraints?.maxHeight ?? 100.0;

    if (decoration is BoxDecoration) {
      if (decoration.shape == BoxShape.circle) {
        return [ShimmerCircle(diameter: w.isFinite ? w : 40)];
      }
      final br = decoration.borderRadius;
      return [
        ShimmerRectangle(
          width: w.isFinite ? w : 100,
          height: h.isFinite ? h : 20,
          borderRadius: (br is BorderRadius) ? br : BorderRadius.zero,
        ),
      ];
    }

    if (widget.child != null) {
      final childShapes = _detect(widget.child!, depth - 1);
      if (childShapes.isNotEmpty) return childShapes;
    }

    return [
      ShimmerRectangle(
        width: w.isFinite ? w : 100,
        height: h.isFinite ? h : 20,
      ),
    ];
  }

  // ── SizedBox ──────────────────────────────────────────────────────────────
  if (widget is SizedBox) {
    if (widget.child != null) {
      final childShapes = _detect(widget.child!, depth - 1);
      if (childShapes.isNotEmpty) return childShapes;
    }
    final w = widget.width ?? 100;
    final h = widget.height ?? 20;
    return [
      ShimmerRectangle(
        width: w.isFinite ? w : 100,
        height: h.isFinite ? h : 20,
      ),
    ];
  }

  // ── Text / RichText → single text line ───────────────────────────────────
  if (widget is Text || widget is RichText) {
    return [const ShimmerText(lines: 1)];
  }

  // ── Image variants → rectangle ────────────────────────────────────────────
  if (widget is Image || widget is FadeInImage) {
    return [const ShimmerRectangle(width: 100, height: 100)];
  }

  // ── Row → horizontal group ────────────────────────────────────────────────
  if (widget is Row) {
    final childShapes = widget.children
        .map((c) => _detect(c, depth - 1))
        .where((s) => s.isNotEmpty)
        .map((s) => s.length == 1 ? s.first : ShimmerGroup(children: s))
        .toList();
    if (childShapes.isEmpty) return [];
    return [ShimmerGroup(children: childShapes, axis: Axis.horizontal, spacing: 8)];
  }

  // ── Column → vertical group ───────────────────────────────────────────────
  if (widget is Column) {
    final childShapes = widget.children
        .map((c) => _detect(c, depth - 1))
        .where((s) => s.isNotEmpty)
        .map((s) => s.length == 1 ? s.first : ShimmerGroup(children: s))
        .toList();
    if (childShapes.isEmpty) return [];
    return [ShimmerGroup(children: childShapes, axis: Axis.vertical, spacing: 8)];
  }

  // ── ListTile → horizontal group (leading + column of two lines) ───────────
  if (widget is ListTile) {
    final parts = <ShimmerShape>[];
    if (widget.leading != null) {
      final ls = _detect(widget.leading!, depth - 1);
      parts.addAll(ls.isNotEmpty ? ls : [const ShimmerCircle(diameter: 40)]);
    }
    parts.add(
      const ShimmerGroup(
        children: [
          ShimmerText(lines: 1, width: 140),
          ShimmerText(lines: 1, width: 100),
        ],
        axis: Axis.vertical,
        spacing: 4,
      ),
    );
    return [ShimmerGroup(children: parts, axis: Axis.horizontal, spacing: 12)];
  }

  // ── Card → recurse into child ─────────────────────────────────────────────
  if (widget is Card) {
    return _detect(widget.child ?? const SizedBox(), depth - 1);
  }

  return [];
}
