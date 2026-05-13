import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

enum SilkFABSize { sm, md, lg }

enum SilkFABVariant { primary, surface }

class SilkFAB extends StatelessWidget {
  const SilkFAB({
    required this.icon,
    required this.onPressed,
    this.label,
    this.size = SilkFABSize.md,
    this.variant = SilkFABVariant.primary,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  /// When set, renders an extended FAB with icon + label side by side.
  final String? label;

  final SilkFABSize size;
  final SilkFABVariant variant;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (dimension, iconSize, elevation) = switch (size) {
      SilkFABSize.sm => (40.0, 18.0, tokens.shadowSm),
      SilkFABSize.md => (56.0, 24.0, tokens.shadowMd),
      SilkFABSize.lg => (68.0, 28.0, tokens.shadowMd),
    };

    final (bg, fg) = switch (variant) {
      SilkFABVariant.primary => (tokens.accent, Colors.white),
      SilkFABVariant.surface => (tokens.surface, tokens.onSurface),
    };

    final lbl = label;
    final radius = lbl != null
        ? BorderRadius.circular(tokens.radiusPill)
        : BorderRadius.circular(dimension / 2);

    Widget fab = Container(
      height: dimension,
      padding: lbl != null
          ? EdgeInsets.symmetric(horizontal: tokens.spaceLg)
          : null,
      width: lbl != null ? null : dimension,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        boxShadow: elevation,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: fg),
          if (lbl != null) ...[
            SizedBox(width: tokens.spaceSm),
            Text(
              lbl,
              style: tokens.labelStyle.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );

    if (onPressed != null) {
      fab = SilkReactionBurst(
        onTap: onPressed,
        color: variant == SilkFABVariant.primary ? bg : tokens.accent,
        particleCount: 10,
        spreadRadius: 36,
        child: fab,
      );
    }

    final tip = tooltip;
    if (tip != null) {
      fab = Tooltip(message: tip, child: fab);
    }

    return AnimatedOpacity(
      opacity: onPressed != null ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 100),
      child: fab,
    );
  }
}
