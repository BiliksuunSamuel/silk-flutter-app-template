import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkBadgeVariant { accent, success, danger, muted }

class SilkBadge extends StatelessWidget {
  const SilkBadge({
    required this.label,
    this.variant = SilkBadgeVariant.accent,
    super.key,
  });

  const SilkBadge.count({
    required int count,
    Key? key,
  }) : this(label: '$count', key: key);

  final String label;
  final SilkBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final bg = switch (variant) {
      SilkBadgeVariant.accent => tokens.accent,
      SilkBadgeVariant.success => tokens.success,
      SilkBadgeVariant.danger => tokens.danger,
      SilkBadgeVariant.muted => tokens.surfaceMuted,
    };

    final fg = switch (variant) {
      SilkBadgeVariant.muted => tokens.onSurfaceMuted,
      _ => Colors.white,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spaceSm,
        vertical: tokens.spaceXs / 2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(tokens.radiusPill),
      ),
      child: Text(
        label,
        style: tokens.captionStyle.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
