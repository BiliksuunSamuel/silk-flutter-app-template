import 'package:flutter/material.dart';
import 'package:silk/core/theme/app_typography.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkBadgeVariant { accent, success, warning, danger, muted }

class SilkBadge extends StatelessWidget {
  const SilkBadge({
    required this.label,
    this.variant = SilkBadgeVariant.accent,
    super.key,
  });

  const SilkBadge.count({required int count, Key? key})
    : this(label: '$count', key: key);

  final String label;
  final SilkBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    // `accent` is the solid unread/count pill; the rest are tinted status pills.
    final (bg, fg) = switch (variant) {
      SilkBadgeVariant.accent => (tokens.accent, tokens.onAccent),
      SilkBadgeVariant.success => (tokens.successTint, tokens.success),
      SilkBadgeVariant.warning => (tokens.warningTint, tokens.warning),
      SilkBadgeVariant.danger => (tokens.dangerTint, tokens.danger),
      SilkBadgeVariant.muted => (tokens.surfaceMuted, tokens.onSurfaceMuted),
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
        style: AppTypography.tabular(
          tokens.captionStyle.copyWith(color: fg, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
