import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_icon_button.dart';

class SilkSvgButton extends StatefulWidget {
  const SilkSvgButton({
    required this.assetPath,
    required this.onPressed,
    this.variant = SilkIconButtonVariant.ghost,
    this.size = SilkIconButtonSize.md,
    this.tooltip,
    this.semanticLabel,
    super.key,
  });

  final String assetPath;
  final VoidCallback? onPressed;
  final SilkIconButtonVariant variant;
  final SilkIconButtonSize size;
  final String? tooltip;
  final String? semanticLabel;

  @override
  State<SilkSvgButton> createState() => _SilkSvgButtonState();
}

class _SilkSvgButtonState extends State<SilkSvgButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

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

    final (dimension, iconSize) = switch (widget.size) {
      SilkIconButtonSize.sm => (32.0, 16.0),
      SilkIconButtonSize.md => (40.0, 20.0),
      SilkIconButtonSize.lg => (48.0, 24.0),
    };

    final (bg, fg, border) = switch (widget.variant) {
      SilkIconButtonVariant.primary => (tokens.accent, Colors.white, null),
      SilkIconButtonVariant.ghost => (
          Colors.transparent,
          tokens.onSurface,
          Border.all(color: tokens.divider),
        ),
      SilkIconButtonVariant.subtle => (tokens.surfaceMuted, tokens.onSurface, null),
      SilkIconButtonVariant.destructive => (tokens.danger, Colors.white, null),
    };

    Widget button = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: MotionTokens.micro,
        curve: MotionTokens.sharp,
        child: AnimatedOpacity(
          opacity: _enabled ? (_pressed ? 0.8 : 1.0) : 0.4,
          duration: MotionTokens.micro,
          child: Container(
            width: dimension,
            height: dimension,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: border,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              widget.assetPath,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
              semanticsLabel: widget.semanticLabel,
            ),
          ),
        ),
      ),
    );

    final tooltip = widget.tooltip;
    if (tooltip != null) {
      button = Tooltip(message: tooltip, child: button);
    }

    return button;
  }
}
