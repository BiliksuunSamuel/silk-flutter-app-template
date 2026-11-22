import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
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
    final bg = widget.selected ? tokens.accentTint : tokens.surfaceMuted;
    final fg = widget.selected ? tokens.accentInk : tokens.onSurface;

    return GestureDetector(
      onTapDown: widget.onTap != null
          ? (_) => setState(() => _pressed = true)
          : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              Haptics.selection();
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
          constraints: const BoxConstraints(minHeight: 32),
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceSm + tokens.spaceXs,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(tokens.radiusSegment),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(widget.leadingIcon, size: 14, color: fg),
                SizedBox(width: tokens.spaceXs),
              ],
              Text(
                widget.label,
                style: tokens.captionStyle.copyWith(
                  color: fg,
                  fontWeight: widget.selected
                      ? FontWeight.w600
                      : FontWeight.w500,
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
