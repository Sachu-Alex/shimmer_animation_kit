import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

void main() {
  group('ShimmerScope', () {
    testWidgets('provides animation value between 0.0 and 1.0', (tester) async {
      double? captured;

      await tester.pumpWidget(
        MaterialApp(
          home: ShimmerScope(
            child: Builder(
              builder: (context) {
                captured = ShimmerScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(captured, isNotNull);
      expect(captured, greaterThanOrEqualTo(0.0));
      expect(captured, lessThanOrEqualTo(1.0));
    });

    testWidgets('animation value changes over time when not disabled',
        (tester) async {
      final values = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: ShimmerScope(
            child: Builder(
              builder: (context) {
                values.add(ShimmerScope.of(context));
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Values should not all be identical when animations are running.
      final unique = values.toSet();
      expect(unique.length, greaterThan(1));
    });

    testWidgets('returns static 0.5 when MediaQuery.disableAnimations is true',
        (tester) async {
      double? captured;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: MaterialApp(
            home: ShimmerScope(
              child: Builder(
                builder: (context) {
                  captured = ShimmerScope.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );

      // Advance time — value must stay 0.5.
      await tester.pump(const Duration(seconds: 2));
      expect(captured, 0.5);
    });

    testWidgets('returns 0.5 fallback when used without a ShimmerScope ancestor',
        (tester) async {
      double? value;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              value = ShimmerScope.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(value, 0.5);
    });

    testWidgets('maybeOf returns null without a ShimmerScope ancestor',
        (tester) async {
      double? value = 1.0; // sentinel
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              value = ShimmerScope.maybeOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(value, isNull);
    });
  });
}
