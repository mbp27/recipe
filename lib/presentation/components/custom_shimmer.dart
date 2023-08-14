import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final int loop;
  final bool enabled;

  const CustomShimmer({
    Key? key,
    required this.child,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).focusColor;
    final highlightColor = Theme.of(context).focusColor.withOpacity(0.2);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      direction: direction,
      period: period,
      loop: loop,
      enabled: enabled,
      child: child,
    );
  }
}
