import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/pressable_scale.dart';

/// - [primary]: one per screen. Filled accent, 52 high, glow shadow + top highlight.
/// - [secondary]: 48 high, surface fill, strong hairline border.
/// - [ghost]: text button — no container, accent-ink label, 44 min tap target.
/// - [destructive]: filled danger. Use only inside a confirmation sheet/dialog.
/// - [destructiveText]: text button in danger red — the default for delete actions.
enum SilkButtonVariant {
  primary,
  secondary,
  ghost,
  destructive,
  destructiveText,
}

class SilkButton extends StatelessWidget {
  const SilkButton({
    required this.label,
    required this.onPressed,
    this.variant = SilkButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final SilkButtonVariant variant;
  final bool isLoading;
  final Widget? icon;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (bg, fg) = switch (variant) {
      SilkButtonVariant.primary => (tokens.accent, tokens.onAccent),
      SilkButtonVariant.secondary => (tokens.surface, tokens.onSurface),
      SilkButtonVariant.ghost => (Colors.transparent, tokens.accentInk),
      SilkButtonVariant.destructive => (tokens.danger, Colors.white),
      SilkButtonVariant.destructiveText => (Colors.transparent, tokens.danger),
    };

    final isText =
        variant == SilkButtonVariant.ghost ||
        variant == SilkButtonVariant.destructiveText;
    final height = switch (variant) {
      SilkButtonVariant.primary || SilkButtonVariant.destructive => 52.0,
      SilkButtonVariant.secondary => 48.0,
      _ => 44.0,
    };

    final filled =
        variant == SilkButtonVariant.primary ||
        variant == SilkButtonVariant.destructive;
    final radius = BorderRadius.circular(tokens.radiusMd);

    final content = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: fg, size: 18),
                  child: icon!,
                ),
                SizedBox(width: tokens.spaceSm),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.titleSmStyle.copyWith(color: fg),
                ),
              ),
            ],
          );

    final container = Container(
      constraints: BoxConstraints(minHeight: height),
      padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: variant == SilkButtonVariant.secondary
            ? Border.all(color: tokens.hairlineStrong)
            : null,
        boxShadow: filled && _enabled
            ? (variant == SilkButtonVariant.primary
                  ? tokens.shadowPrimaryButton
                  : null)
            : null,
      ),
      // Inner top highlight on filled buttons.
      foregroundDecoration: filled
          ? BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.4],
                colors: [
                  Colors.white.withValues(alpha: 0.18),
                  Colors.white.withValues(alpha: 0),
                ],
              ),
            )
          : null,
      child: content,
    );

    return Semantics(
      button: true,
      enabled: _enabled,
      label: label,
      excludeSemantics: true,
      child: PressableScale(
        onTap: _enabled ? onPressed : null,
        haptic: variant == SilkButtonVariant.primary
            ? PressHaptic.light
            : PressHaptic.selection,
        scale: 0.97,
        child: AnimatedOpacity(
          opacity: _enabled || isLoading ? 1 : 0.4,
          duration: const Duration(milliseconds: 120),
          child: isText
              ? ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 44),
                  child: container,
                )
              : container,
        ),
      ),
    );
  }
}
