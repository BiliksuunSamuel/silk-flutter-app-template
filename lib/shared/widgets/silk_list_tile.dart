import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkListTile extends StatefulWidget {
  const SilkListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  State<SilkListTile> createState() => _SilkListTileState();
}

class _SilkListTileState extends State<SilkListTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap != null
          ? (_) => setState(() => _pressed = true)
          : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              Haptics.selection();
              widget.onTap!();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: MotionTokens.micro,
        curve: MotionTokens.sharp,
        child: AnimatedOpacity(
          opacity: _pressed ? 0.85 : 1.0,
          duration: MotionTokens.micro,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spaceMd,
                  vertical: tokens.spaceSm + 2,
                ),
                // Rows are at least 52 high.
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 32),
                  child: Row(
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        SizedBox(width: tokens.spaceMd),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DefaultTextStyle(
                              style: tokens.titleSmStyle.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              child: widget.title,
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 2),
                              DefaultTextStyle(
                                style: tokens.bodySmStyle.copyWith(
                                  color: tokens.onSurfaceMuted,
                                ),
                                child: widget.subtitle!,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.trailing != null) ...[
                        SizedBox(width: tokens.spaceMd),
                        widget.trailing!,
                      ],
                    ],
                  ),
                ),
              ),
              if (widget.showDivider)
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: tokens.divider,
                  indent: widget.leading != null
                      ? tokens.spaceMd + 40 + tokens.spaceMd
                      : tokens.spaceMd,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
