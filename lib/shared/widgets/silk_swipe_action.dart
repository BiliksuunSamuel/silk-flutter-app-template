import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkSwipeItem {
  const SilkSwipeItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

enum SilkSwipeDirection { endToStart, startToEnd }

class SilkSwipeAction extends StatefulWidget {
  const SilkSwipeAction({
    required this.child,
    required this.actions,
    this.direction = SilkSwipeDirection.endToStart,
    super.key,
  }) : assert(actions.length <= 3, 'At most 3 swipe actions are supported');

  final Widget child;
  final List<SilkSwipeItem> actions;
  final SilkSwipeDirection direction;

  @override
  State<SilkSwipeAction> createState() => _SilkSwipeActionState();
}

class _SilkSwipeActionState extends State<SilkSwipeAction> {

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Dismissible(
      key: ValueKey(widget.child.hashCode),
      direction: widget.direction == SilkSwipeDirection.endToStart
          ? DismissDirection.endToStart
          : DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        // Never actually dismiss — we just expose the actions.
        return false;
      },
      background: widget.direction == SilkSwipeDirection.startToEnd
          ? _ActionBar(actions: widget.actions, direction: widget.direction)
          : const SizedBox.shrink(),
      secondaryBackground: widget.direction == SilkSwipeDirection.endToStart
          ? _ActionBar(actions: widget.actions, direction: widget.direction)
          : const SizedBox.shrink(),
      child: ColoredBox(
        color: tokens.surface,
        child: widget.child,
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.actions, required this.direction});

  final List<SilkSwipeItem> actions;
  final SilkSwipeDirection direction;

  @override
  Widget build(BuildContext context) {
    final items = direction == SilkSwipeDirection.endToStart
        ? actions
        : actions.reversed.toList();

    return Row(
      mainAxisAlignment: direction == SilkSwipeDirection.endToStart
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: items.map((action) => _ActionButton(item: action)).toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.item});

  final SilkSwipeItem item;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        width: 72,
        color: item.color,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: Colors.white, size: 22),
            SizedBox(height: tokens.spaceXs / 2),
            Text(
              item.label,
              style: tokens.captionStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
