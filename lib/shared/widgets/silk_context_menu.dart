import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

class SilkContextMenuItem {
  const SilkContextMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
}

class SilkContextMenu extends StatefulWidget {
  const SilkContextMenu({
    required this.child,
    required this.items,
    super.key,
  });

  final Widget child;
  final List<SilkContextMenuItem> items;

  @override
  State<SilkContextMenu> createState() => _SilkContextMenuState();
}

class _SilkContextMenuState extends State<SilkContextMenu>
    with TickerProviderStateMixin {
  late final AnimationController _menuCtrl;
  late final AnimationController _squishCtrl;
  late final Animation<double> _menuScale;
  late final Animation<double> _squishAnim;
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _menuCtrl = AnimationController(vsync: this, duration: MotionTokens.standard);
    _menuScale =
        CurvedAnimation(parent: _menuCtrl, curve: MotionTokens.emphasizedDecel);

    // Child squish: 1.0 → 0.93 → 1.0 on long press
    _squishCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _squishAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.93), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.93, end: 1), weight: 65),
    ]).animate(
      CurvedAnimation(parent: _squishCtrl, curve: MotionTokens.emphasizedDecel),
    );
  }

  @override
  void dispose() {
    _menuCtrl.dispose();
    _squishCtrl.dispose();
    super.dispose();
  }

  void _openMenu() {
    Haptics.medium();
    _squishCtrl.forward(from: 0);
    SilkReactionBurst.trigger(
      context: context,
      color: context.tokens.accent,
      particleCount: 10,
      spreadRadius: 36,
    );
    setState(() => _showMenu = true);
    _menuCtrl.forward();
  }

  void _closeMenu() {
    _menuCtrl.reverse().then((_) {
      if (mounted) setState(() => _showMenu = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onLongPress: _openMenu,
      child: Stack(
        children: [
          ScaleTransition(
            scale: _squishAnim,
            child: widget.child,
          ),
          if (_showMenu) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeMenu,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: ScaleTransition(
                scale: _menuScale,
                alignment: Alignment.topLeft,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 180),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: tokens.surface,
                    borderRadius: BorderRadius.circular(tokens.radiusMd),
                    boxShadow: tokens.shadowLg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.items.map((item) {
                      return _ContextMenuRow(
                        item: item,
                        onTap: () {
                          _closeMenu();
                          item.onTap();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContextMenuRow extends StatefulWidget {
  const _ContextMenuRow({required this.item, required this.onTap});

  final SilkContextMenuItem item;
  final VoidCallback onTap;

  @override
  State<_ContextMenuRow> createState() => _ContextMenuRowState();
}

class _ContextMenuRowState extends State<_ContextMenuRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final fg = widget.item.isDestructive ? tokens.danger : tokens.onSurface;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Haptics.light();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: MotionTokens.micro,
        color: _pressed ? tokens.surfaceMuted : Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spaceMd,
          vertical: tokens.spaceMd,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.item.icon != null) ...[
              AnimatedScale(
                scale: _pressed ? 0.88 : 1.0,
                duration: MotionTokens.micro,
                child: Icon(widget.item.icon, color: fg, size: 18),
              ),
              SizedBox(width: tokens.spaceSm),
            ],
            AnimatedDefaultTextStyle(
              style: tokens.bodyStyle.copyWith(
                color: fg,
                fontWeight: _pressed ? FontWeight.w600 : FontWeight.w400,
              ),
              duration: MotionTokens.micro,
              child: Text(widget.item.label),
            ),
          ],
        ),
      ),
    );
  }
}
