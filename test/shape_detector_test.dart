import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';
import 'package:shimmer_animation_kit/src/shape_detector.dart';

void main() {
  group('detectShapes()', () {
    test('Container with no decoration → ShimmerRectangle', () {
      final shapes = detectShapes(const SizedBox(width: 100, height: 50));
      expect(shapes, hasLength(1));
      expect(shapes.first, isA<ShimmerRectangle>());
    });

    test('Container with BoxDecoration borderRadius → ShimmerRectangle', () {
      final shapes = detectShapes(
        Container(
          width: 120,
          height: 30,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        ),
      );
      expect(shapes, hasLength(1));
      final rect = shapes.first as ShimmerRectangle;
      expect(rect.borderRadius, BorderRadius.circular(8));
    });

    test('Container with BoxShape.circle → ShimmerCircle', () {
      final shapes = detectShapes(
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(shape: BoxShape.circle),
        ),
      );
      expect(shapes, hasLength(1));
      expect(shapes.first, isA<ShimmerCircle>());
    });

    test('ClipRRect → ShimmerRectangle with borderRadius', () {
      final shapes = detectShapes(
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const SizedBox(width: 80, height: 80),
        ),
      );
      expect(shapes, hasLength(1));
      expect(shapes.first, isA<ShimmerRectangle>());
    });

    test('CircleAvatar → ShimmerCircle with correct diameter', () {
      final shapes = detectShapes(const CircleAvatar(radius: 24));
      expect(shapes, hasLength(1));
      final circle = shapes.first as ShimmerCircle;
      expect(circle.diameter, 48.0);
    });

    test('Text → ShimmerText with 1 line', () {
      final shapes = detectShapes(const Text('Hello'));
      expect(shapes, hasLength(1));
      expect(shapes.first, isA<ShimmerText>());
      final text = shapes.first as ShimmerText;
      expect(text.lines, 1);
    });

    test('Column → ShimmerGroup with vertical axis', () {
      final shapes = detectShapes(
        const Column(
          children: [
            SizedBox(width: 100, height: 20),
            Text('line'),
          ],
        ),
      );
      expect(shapes, hasLength(1));
      final group = shapes.first as ShimmerGroup;
      expect(group.axis, Axis.vertical);
      expect(group.children, hasLength(2));
    });

    test('Row → ShimmerGroup with horizontal axis', () {
      final shapes = detectShapes(
        const Row(
          children: [
            CircleAvatar(radius: 20),
            SizedBox(width: 100, height: 16),
          ],
        ),
      );
      expect(shapes, hasLength(1));
      final group = shapes.first as ShimmerGroup;
      expect(group.axis, Axis.horizontal);
    });

    test('Padding wrapping Container → unwraps and returns ShimmerRectangle', () {
      final shapes = detectShapes(
        const Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(width: 80, height: 40),
        ),
      );
      expect(shapes, hasLength(1));
      expect(shapes.first, isA<ShimmerRectangle>());
    });

    test('maxDepth 0 → returns empty list', () {
      final shapes = detectShapes(const Text('hi'), maxDepth: 0);
      expect(shapes, isEmpty);
    });

    test('Unrecognised widget → returns empty list', () {
      final shapes = detectShapes(const Placeholder());
      expect(shapes, isEmpty);
    });
  });

  group('ShimmerShape.toRects()', () {
    test('ShimmerRectangle produces one rect at origin', () {
      const shape = ShimmerRectangle(width: 100, height: 20);
      final rects = shape.toRects(Offset.zero);
      expect(rects, hasLength(1));
      expect(rects.first.$1, const Rect.fromLTWH(0, 0, 100, 20));
    });

    test('ShimmerCircle produces rect with circular borderRadius', () {
      const shape = ShimmerCircle(diameter: 40);
      final rects = shape.toRects(Offset.zero);
      expect(rects, hasLength(1));
      expect(rects.first.$2, BorderRadius.circular(20));
    });

    test('ShimmerText produces correct number of rects', () {
      const shape = ShimmerText(lines: 3);
      final rects = shape.toRects(Offset.zero);
      expect(rects, hasLength(3));
    });

    test('ShimmerGroup combines children rects', () {
      const group = ShimmerGroup(
        axis: Axis.vertical,
        children: [
          ShimmerRectangle(width: 80, height: 16),
          ShimmerRectangle(width: 60, height: 16),
        ],
      );
      final rects = group.toRects(Offset.zero);
      expect(rects, hasLength(2));
    });
  });
}
