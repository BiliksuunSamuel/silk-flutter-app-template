import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkShimmer extends StatelessWidget {
  const SilkShimmer({
    required this.width,
    required this.height,
    this.borderRadius,
    super.key,
  });

  /// Semi-transparent overlay variant — for [AsyncValue.whenSmooth].
  factory SilkShimmer.overlay({Key? key}) => SilkShimmer(
        key: key,
        width: double.infinity,
        height: double.infinity,
        borderRadius: 0,
      );

  final double width;
  final double height;

  /// Defaults to [AppTokens.radiusMd] when null.
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final radius = borderRadius ?? tokens.radiusMd;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(radius),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: const Duration(milliseconds: 1400),
          color: tokens.surface.withValues(alpha: 0.6),
          angle: 0.2,
        );
  }
}
