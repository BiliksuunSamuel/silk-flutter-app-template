import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

enum SilkIconButtonVariant { primary, ghost, subtle, destructive }

enum SilkIconButtonSize { sm, md, lg }

class SilkIconButton extends StatelessWidget {
  const SilkIconButton({
    required this.icon,
    required this.onPressed,
    this.variant = SilkIconButtonVariant.ghost,
    this.size = SilkIconButtonSize.md,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final SilkIconButtonVariant variant;
  final SilkIconButtonSize size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (dimension, iconSize) = switch (size) {
      SilkIconButtonSize.sm => (32.0, 16.0),
      SilkIconButtonSize.md => (40.0, 20.0),
      SilkIconButtonSize.lg => (48.0, 24.0),
    };

    final (bg, fg, border) = switch (variant) {
      SilkIconButtonVariant.primary => (tokens.accent, Colors.white, null),
      SilkIconButtonVariant.ghost => (
          Colors.transparent,
          tokens.onSurface,
          Border.all(color: tokens.divider),
        ),
      SilkIconButtonVariant.subtle => (tokens.surfaceMuted, tokens.onSurface, null),
      SilkIconButtonVariant.destructive => (tokens.danger, Colors.white, null),
    };

    final burstColor = switch (variant) {
      SilkIconButtonVariant.destructive => tokens.danger,
      _ => tokens.accent,
    };

    // Spread scales with button size so particles stay proportional.
    final spreadRadius = switch (size) {
      SilkIconButtonSize.sm => 22.0,
      SilkIconButtonSize.md => 28.0,
      SilkIconButtonSize.lg => 34.0,
    };

    Widget button = AnimatedOpacity(
      opacity: onPressed != null ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 100),
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: border,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: iconSize, color: fg),
      ),
    );

    if (onPressed != null) {
      button = SilkReactionBurst(
        onTap: onPressed,
        color: burstColor,
        particleCount: 8,
        spreadRadius: spreadRadius,
        child: button,
      );
    }

    final tip = tooltip;
    if (tip != null) {
      button = Tooltip(message: tip, child: button);
    }

    return button;
  }
}
