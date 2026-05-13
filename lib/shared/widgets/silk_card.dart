import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkCardElevation { none, sm, md, lg }

class SilkCard extends StatelessWidget {
  const SilkCard({
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
    this.hasBorder = false,
    this.elevation = SilkCardElevation.none,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? borderRadius;
  final bool hasBorder;
  final SilkCardElevation elevation;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final radius = borderRadius ?? tokens.radiusMd;
    final bg = color ?? tokens.surface;

    final shadow = switch (elevation) {
      SilkCardElevation.none => <BoxShadow>[],
      SilkCardElevation.sm   => tokens.shadowSm,
      SilkCardElevation.md   => tokens.shadowMd,
      SilkCardElevation.lg   => tokens.shadowLg,
    };

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    Widget card = Ink(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: hasBorder ? Border.all(color: tokens.divider) : null,
        boxShadow: shadow,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(tokens.spaceMd),
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        customBorder: shape,
        child: card,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: card,
    );
  }
}
