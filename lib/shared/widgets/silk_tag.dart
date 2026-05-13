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
      SilkTagVariant.accent   => (tokens.accent,                    tokens.accent.withValues(alpha: 0.12)),
      SilkTagVariant.success  => (tokens.success,                   tokens.success.withValues(alpha: 0.12)),
      SilkTagVariant.warning  => (const Color(0xFFF59E0B),          const Color(0xFFFEF3C7)),
      SilkTagVariant.danger   => (tokens.danger,                    tokens.danger.withValues(alpha: 0.12)),
      SilkTagVariant.muted    => (tokens.onSurfaceMuted,            tokens.surfaceMuted),
    };

    final leadingIcon = icon;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spaceSm,
        vertical: 3,
      ),
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
            style: tokens.overlineStyle.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
