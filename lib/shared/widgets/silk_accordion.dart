import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkAccordionItem {
  const SilkAccordionItem({
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;
}

/// Grouped expandables where only one item is open at a time.
///
/// Usage:
/// ```dart
/// SilkAccordion(
///   items: [
///     SilkAccordionItem(title: 'What is APY?', child: Text('...')),
///     SilkAccordionItem(title: 'When do I get paid?', child: Text('...')),
///   ],
/// )
/// ```
class SilkAccordion extends StatefulWidget {
  const SilkAccordion({
    required this.items,
    this.initialIndex,
    super.key,
  });

  final List<SilkAccordionItem> items;

  /// Index of the item open on first render. Null means all collapsed.
  final int? initialIndex;

  @override
  State<SilkAccordion> createState() => _SilkAccordionState();
}

class _SilkAccordionState extends State<SilkAccordion> {
  int? _openIndex;

  @override
  void initState() {
    super.initState();
    _openIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: tokens.divider),
        borderRadius: BorderRadius.circular(tokens.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.items.length; i++) ...[
            if (i > 0) Divider(color: tokens.divider, height: 1),
            _AccordionTile(
              item: widget.items[i],
              isOpen: _openIndex == i,
              onTap: () => setState(
                () => _openIndex = _openIndex == i ? null : i,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccordionTile extends StatelessWidget {
  const _AccordionTile({
    required this.item,
    required this.isOpen,
    required this.onTap,
  });

  final SilkAccordionItem item;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceLg,
              vertical: tokens.spaceMd,
            ),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 18,
                    color: isOpen ? tokens.accent : tokens.onSurfaceMuted,
                  ),
                  SizedBox(width: tokens.spaceSm),
                ],
                Expanded(
                  child: Text(
                    item.title,
                    style: tokens.bodyStyle.copyWith(
                      fontWeight:
                          isOpen ? FontWeight.w600 : FontWeight.normal,
                      color: isOpen ? tokens.accent : tokens.onSurface,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more_rounded,
                    color: tokens.onSurfaceMuted,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.fromLTRB(
              tokens.spaceLg,
              0,
              tokens.spaceLg,
              tokens.spaceMd,
            ),
            child: item.child,
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeOut,
        ),
      ],
    );
  }
}
