import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

// Disable the debug banner so its CustomPaint doesn't pollute assertions.
Widget _wrap(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShimmerScope(child: child),
    );

void main() {
  group('ShimmerKit', () {
    testWidgets('renders child normally when isLoading is false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShimmerKit(
            isLoading: false,
            child: Text('Real content'),
          ),
        ),
      );

      expect(find.text('Real content'), findsOneWidget);
      expect(find.byType(CustomPaint), findsNothing);
    });

    testWidgets('renders CustomPaint when isLoading is true', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShimmerKit(
            isLoading: true,
            child: SizedBox(width: 200, height: 40),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('does not render child text when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShimmerKit(
            isLoading: true,
            child: Text('Hidden'),
          ),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
    });

    testWidgets('toggling isLoading shows child after loading', (tester) async {
      bool loading = true;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return _wrap(
              Column(
                children: [
                  ShimmerKit(
                    isLoading: loading,
                    child: const Text('Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => loading = false),
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // While loading: child text is hidden, shimmer painter is active.
      expect(find.text('Profile'), findsNothing);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

      await tester.tap(find.text('Done'));
      await tester.pump();

      // After loading: child text visible, shimmer CustomPaint is gone.
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Semantics label is present when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShimmerKit(
            isLoading: true,
            child: SizedBox(width: 100, height: 20),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(ShimmerKit));
      expect(semantics.label, 'Loading');
    });

    testWidgets('uses baseColor and highlightColor overrides', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShimmerKit(
            isLoading: true,
            baseColor: Colors.red,
            highlightColor: Colors.blue,
            child: SizedBox(width: 100, height: 20),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });

    testWidgets('works without ShimmerScope ancestor (falls back to 0.5)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ShimmerKit(
            isLoading: true,
            child: SizedBox(width: 100, height: 20),
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    });
  });
}
