import 'package:flutter/material.dart';
import 'package:shimmer_animation_kit/shimmer_animation_kit.dart';

class ManualDemo extends StatelessWidget {
  const ManualDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Manual Widgets')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const _Section(
              label: 'ShimmerCircleWidget(diameter: 60)',
              child: ShimmerCircleWidget(diameter: 60),
            ),
            _Section(
              label: 'ShimmerBox(width: 200, height: 16, radius: 4)',
              child: ShimmerBox(
                width: 200,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const _Section(
              label: 'ShimmerTextWidget(lines: 4)',
              child: ShimmerTextWidget(lines: 4, width: 280),
            ),
            _Section(
              label: 'ShimmerList(itemCount: 4)',
              child: ShimmerList(
                itemCount: 4,
                itemBuilder: (_) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 20),
                      SizedBox(width: 12),
                      SizedBox(
                        width: 180,
                        height: 14,
                        child: ColoredBox(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey,
                  fontFamily: 'monospace',
                ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
