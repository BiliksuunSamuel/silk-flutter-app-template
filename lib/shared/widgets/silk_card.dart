import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/pressable_scale.dart';

/// Shadow recipe for a card. Solid UI cards are flat — [none] is the default.
/// Only use a shadow when the card genuinely floats over content.
enum SilkCardElevation { none, sm, md, lg }

/// Flat card: [surface] fill, radius 20, soft hairline border, no shadow.
/// Tappable cards use press-scale (no ripple).
class SilkCard extends StatelessWidget {
  const SilkCard({
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
    this.hasBorder = true,
    this.elevation = SilkCardElevation.none,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;

  /// Soft hairline border (default). Set false for a borderless card on a
  /// background that already separates it.
  final bool hasBorder;
  final SilkCardElevation elevation;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final radius = BorderRadius.circular(borderRadius ?? tokens.radiusLg);

    final shadow = switch (elevation) {
      SilkCardElevation.none => const <BoxShadow>[],
      SilkCardElevation.sm => tokens.shadowSm,
      SilkCardElevation.md => tokens.shadowMd,
      SilkCardElevation.lg => tokens.shadowLg,
    };

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? tokens.surface,
        borderRadius: radius,
        border: hasBorder ? Border.all(color: tokens.hairlineSoft) : null,
        boxShadow: shadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Padding(
          padding: padding ?? EdgeInsets.all(tokens.spaceMd),
          child: child,
        ),
      ),
    );

    if (onTap == null) return card;
    return PressableScale(onTap: onTap, scale: 0.98, child: card);
  }
}
