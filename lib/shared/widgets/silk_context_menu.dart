import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: MotionTokens.standard,
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: MotionTokens.emphasizedDecel,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openMenu() {
    Haptics.medium();
    setState(() => _showMenu = true);
    _controller.forward();
  }

  void _closeMenu() {
    _controller.reverse().then((_) {
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
          widget.child,
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
                scale: _scaleAnim,
                alignment: Alignment.topLeft,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 180),
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
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.6 : 1.0,
        duration: MotionTokens.micro,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceMd,
            vertical: tokens.spaceMd,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.item.icon != null) ...[
                Icon(widget.item.icon, color: fg, size: 18),
                SizedBox(width: tokens.spaceSm),
              ],
              Text(
                widget.item.label,
                style: tokens.bodyStyle.copyWith(color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
