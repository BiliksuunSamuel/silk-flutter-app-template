import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkTimelineStatus { done, active, pending }

@immutable
class SilkTimelineItem {
  const SilkTimelineItem({
    required this.title,
    this.subtitle,
    this.timestamp,
    this.icon,
    this.status = SilkTimelineStatus.done,
  });

  final String title;
  final String? subtitle;
  final String? timestamp;
  final IconData? icon;
  final SilkTimelineStatus status;
}

/// Vertical timeline of labelled events with done / active / pending states.
///
/// Usage:
/// ```dart
/// SilkTimeline(
///   items: [
///     SilkTimelineItem(title: 'Order placed', timestamp: '09:41'),
///     SilkTimelineItem(title: 'Processing', status: SilkTimelineStatus.active),
///     SilkTimelineItem(title: 'Shipped', status: SilkTimelineStatus.pending),
///   ],
/// )
/// ```
class SilkTimeline extends StatelessWidget {
  const SilkTimeline({required this.items, super.key});

  final List<SilkTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        items.length,
        (i) => _TimelineRow(item: items[i], isLast: i == items.length - 1),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.isLast});

  final SilkTimelineItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                _Node(item: item),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: item.status == SilkTimelineStatus.done
                          ? tokens.accent.withValues(alpha: 0.3)
                          : tokens.divider,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: tokens.spaceMd),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : tokens.spaceLg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: tokens.bodyStyle.copyWith(
                            color:
                                item.status == SilkTimelineStatus.pending
                                    ? tokens.onSurfaceMuted
                                    : tokens.onSurface,
                            fontWeight:
                                item.status == SilkTimelineStatus.active
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle!,
                            style: tokens.captionStyle
                                .copyWith(color: tokens.onSurfaceMuted),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (item.timestamp != null)
                    Text(
                      item.timestamp!,
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({required this.item});

  final SilkTimelineItem item;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return switch (item.status) {
      SilkTimelineStatus.done => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: tokens.accent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.icon ?? Icons.check_rounded,
            size: 13,
            color: tokens.onAccent,
          ),
        ),
      SilkTimelineStatus.active => _ActiveNode(icon: item.icon),
      SilkTimelineStatus.pending => Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: tokens.divider, width: 2),
          ),
          child: item.icon != null
              ? Icon(item.icon, size: 12, color: tokens.onSurfaceMuted)
              : null,
        ),
    };
  }
}

class _ActiveNode extends StatefulWidget {
  const _ActiveNode({this.icon});

  final IconData? icon;

  @override
  State<_ActiveNode> createState() => _ActiveNodeState();
}

class _ActiveNodeState extends State<_ActiveNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.88, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: tokens.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: tokens.accent.withValues(alpha: 0.45),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          widget.icon ?? Icons.radio_button_checked_rounded,
          size: 12,
          color: tokens.onAccent,
        ),
      ),
    );
  }
}
