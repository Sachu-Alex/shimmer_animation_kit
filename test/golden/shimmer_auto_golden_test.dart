import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

Widget _buildAutoDetect({required Brightness brightness}) {
  final shimmerTheme =
      brightness == Brightness.dark ? ShimmerTheme.dark : ShimmerTheme.light;

  return MaterialApp(
    theme: ThemeData(brightness: brightness, extensions: [shimmerTheme]),
    home: Scaffold(
      body: Center(
        child: ShimmerScope(
          child: ShimmerKit(
            isLoading: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 30),
                const SizedBox(height: 8),
                const Text('Name Placeholder'),
                const SizedBox(height: 4),
                const Text('Subtitle Placeholder'),
                const SizedBox(height: 8),
                Container(width: 200, height: 100, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('ShimmerKit auto-detect goldens', () {
    testWidgets('light mode', (tester) async {
      await tester.pumpWidget(_buildAutoDetect(brightness: Brightness.light));
      // Pump one frame so the shimmer painter draws.
      await tester.pump();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/shimmer_auto_light.png'),
      );
    });

    testWidgets('dark mode', (tester) async {
      await tester.pumpWidget(_buildAutoDetect(brightness: Brightness.dark));
      await tester.pump();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/shimmer_auto_dark.png'),
      );
    });
  });
}
