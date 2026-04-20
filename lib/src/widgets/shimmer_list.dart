import 'package:flutter/widgets.dart';

import '../shimmer_kit.dart';
import '../shimmer_scope.dart';

/// Renders [itemCount] shimmer placeholders using [itemBuilder](0) as the
/// skeleton template.
///
/// Wrap with [ShimmerScope] so all items animate in sync. If no scope is
/// present, each row gets its own controller automatically.
///
/// ```dart
/// ShimmerScope(
///   child: ShimmerList(
///     itemCount: 5,
///     itemBuilder: (_) => MyListTileSkeleton(),
///   ),
/// )
/// ```
class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final skeleton = itemBuilder(0);
        // If already inside a ShimmerScope the parent ShaderMask handles
        // animation; pass the skeleton directly to avoid double-scoping.
        if (ShimmerScope.hasScope(context)) {
          return skeleton;
        }
        return ShimmerKit(
          isLoading: true,
          skeleton: skeleton,
          child: skeleton,
        );
      },
    );
  }
}
