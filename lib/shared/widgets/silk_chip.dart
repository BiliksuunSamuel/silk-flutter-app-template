import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkChip extends StatefulWidget {
  const SilkChip({
    required this.label,
    this.onTap,
    this.onDelete,
    this.leadingIcon,
    this.selected = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final IconData? leadingIcon;
  final bool selected;

  @override
  State<SilkChip> createState() => _SilkChipState();
}

class _SilkChipState extends State<SilkChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bg = widget.selected
        ? tokens.accent.withValues(alpha: 0.12)
        : tokens.surfaceMuted;
    final fg = widget.selected ? tokens.accent : tokens.onSurface;
    final borderColor =
        widget.selected ? tokens.accent.withValues(alpha: 0.4) : tokens.divider;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.65 : 1.0,
        duration: MotionTokens.micro,
        child: AnimatedContainer(
          duration: MotionTokens.fast,
          curve: MotionTokens.standardCurve,
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceSm + tokens.spaceXs,
            vertical: tokens.spaceXs + 2,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(tokens.radiusPill),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(widget.leadingIcon, size: 14, color: fg),
                SizedBox(width: tokens.spaceXs),
              ],
              Text(
                widget.label,
                style: tokens.captionStyle.copyWith(
                  color: fg,
                  fontWeight:
                      widget.selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              if (widget.onDelete != null) ...[
                SizedBox(width: tokens.spaceXs),
                GestureDetector(
                  onTap: widget.onDelete,
                  child: Icon(Icons.close, size: 14, color: fg),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
