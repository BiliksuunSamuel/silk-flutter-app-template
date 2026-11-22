import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkTagVariant { accent, success, warning, danger, muted }

class SilkTag extends StatelessWidget {
  const SilkTag({
    required this.label,
    this.variant = SilkTagVariant.muted,
    this.icon,
    super.key,
  });

  final String label;
  final SilkTagVariant variant;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (fg, bg) = switch (variant) {
      SilkTagVariant.accent => (tokens.accentInk, tokens.accentTint),
      SilkTagVariant.success => (tokens.success, tokens.successTint),
      SilkTagVariant.warning => (tokens.warning, tokens.warningTint),
      SilkTagVariant.danger => (tokens.danger, tokens.dangerTint),
      SilkTagVariant.muted => (tokens.onSurfaceMuted, tokens.surfaceMuted),
    };

    final leadingIcon = icon;

    return Container(
      // 16 line-height + 2×4 = 24 high pill.
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(tokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 11, color: fg),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: tokens.captionStyle.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
