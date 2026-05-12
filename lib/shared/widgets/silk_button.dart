import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkButtonVariant { primary, secondary, ghost, destructive }

class SilkButton extends StatefulWidget {
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

  @override
  State<SilkButton> createState() => _SilkButtonState();
}

class _SilkButtonState extends State<SilkButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _handleTapDown(TapDownDetails _) {
    if (!_enabled) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_enabled) return;
    setState(() => _pressed = false);
    Haptics.light();
    widget.onPressed?.call();
  }

  void _handleTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (bg, fg) = switch (widget.variant) {
      SilkButtonVariant.primary => (tokens.accent, Colors.white),
      SilkButtonVariant.secondary => (
          tokens.surfaceMuted,
          tokens.onSurface,
        ),
      SilkButtonVariant.ghost => (Colors.transparent, tokens.accent),
      SilkButtonVariant.destructive => (tokens.danger, Colors.white),
    };

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: MotionTokens.micro,
        curve: MotionTokens.sharp,
        child: AnimatedOpacity(
          opacity: _enabled ? (_pressed ? 0.8 : 1.0) : 0.4,
          duration: MotionTokens.micro,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              border: widget.variant == SilkButtonVariant.ghost
                  ? Border.all(color: tokens.accent.withValues(alpha: 0.4))
                  : null,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
            child: widget.isLoading
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
                      if (widget.icon != null) ...[
                        IconTheme(data: IconThemeData(color: fg, size: 18), child: widget.icon!),
                        SizedBox(width: tokens.spaceSm),
                      ],
                      Text(
                        widget.label,
                        style: tokens.bodyStyle.copyWith(
                          color: fg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
