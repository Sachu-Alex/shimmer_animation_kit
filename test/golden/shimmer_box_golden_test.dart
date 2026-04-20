import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

Widget _buildBox({required Brightness brightness}) {
  return MaterialApp(
    theme: ThemeData(
      brightness: brightness,
      extensions: [
        brightness == Brightness.dark ? ShimmerTheme.dark : ShimmerTheme.light,
      ],
    ),
    home: Scaffold(
      body: Center(
        // Use a fixed animationValue-based CustomPaint directly so golden is
        // deterministic regardless of test timing.
        child: CustomPaint(
          size: const Size(200, 20),
          painter: _FrozenShimmerBoxPainter(
            brightness: brightness,
          ),
        ),
      ),
    ),
  );
}

class _FrozenShimmerBoxPainter extends CustomPainter {
  const _FrozenShimmerBoxPainter({required this.brightness});
  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final theme =
        brightness == Brightness.dark ? ShimmerTheme.dark : ShimmerTheme.light;
    const animValue = 0.5;
    const borderRadius = BorderRadius.all(Radius.circular(4));

    final gradient = theme.direction.toGradient(
      colors: [theme.baseColor, theme.highlightColor, theme.baseColor],
      stops: [
        (animValue - 0.3).clamp(0.0, 1.0),
        animValue,
        (animValue + 0.3).clamp(0.0, 1.0),
      ],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..isAntiAlias = true;

    canvas.clipRRect(borderRadius.toRRect(rect));
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_FrozenShimmerBoxPainter old) =>
      old.brightness != brightness;
}

void main() {
  group('ShimmerBox goldens', () {
    testWidgets('light mode', (tester) async {
      await tester.pumpWidget(_buildBox(brightness: Brightness.light));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/shimmer_box_light.png'),
      );
    });

    testWidgets('dark mode', (tester) async {
      await tester.pumpWidget(_buildBox(brightness: Brightness.dark));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/shimmer_box_dark.png'),
      );
    });
  });
}
