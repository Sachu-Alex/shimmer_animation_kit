import 'package:flutter/widgets.dart';

import '../shimmer_kit.dart';

/// Renders [itemCount] shimmer placeholders using the shape of [itemBuilder](0).
///
/// Every item is wrapped in [ShimmerKit] with `isLoading: true`, so they all
/// animate in sync when inside a [ShimmerScope].
///
/// ```dart
/// ShimmerList(
///   itemCount: 5,
///   itemBuilder: (index) => MyListTile(),
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
        return ShimmerKit(
          isLoading: true,
          child: itemBuilder(0),
        );
      },
    );
  }
}
