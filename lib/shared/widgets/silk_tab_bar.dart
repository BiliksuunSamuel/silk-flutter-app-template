import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkTab<T> {
  const SilkTab({required this.value, required this.label, this.badge});

  final T value;
  final String label;

  /// Optional badge count shown next to the label.
  final int? badge;
}

class SilkTabBar<T> extends StatefulWidget {
  const SilkTabBar({
    required this.tabs,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<SilkTab<T>> tabs;
  final T selected;
  final void Function(T value) onSelected;

  @override
  State<SilkTabBar<T>> createState() => _SilkTabBarState<T>();
}

class _SilkTabBarState<T> extends State<SilkTabBar<T>> {
  final _scrollController = ScrollController();
  final List<GlobalKey> _keys = [];

  @override
  void initState() {
    super.initState();
    _keys.addAll(List.generate(widget.tabs.length, (_) => GlobalKey()));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected(int index) {
    final key = _keys[index];
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      duration: MotionTokens.standard,
      curve: MotionTokens.standardCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < widget.tabs.length; i++)
                  _SilkTabItem<T>(
                    key: _keys[i],
                    tab: widget.tabs[i],
                    isSelected: widget.tabs[i].value == widget.selected,
                    onTap: () {
                      widget.onSelected(widget.tabs[i].value);
                      _scrollToSelected(i);
                    },
                  ),
              ],
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: tokens.divider),
      ],
    );
  }
}

class _SilkTabItem<T> extends StatelessWidget {
  const _SilkTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final SilkTab<T> tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final labelStyle = tokens.bodySmStyle.copyWith(
      color: isSelected ? tokens.accent : tokens.onSurfaceMuted,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
    );

    final badge = tab.badge;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceMd,
              vertical: tokens.spaceSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: MotionTokens.standard,
                  curve: MotionTokens.standardCurve,
                  style: labelStyle,
                  child: Text(tab.label),
                ),
                if (badge != null && badge > 0) ...[
                  SizedBox(width: tokens.spaceXs),
                  AnimatedContainer(
                    duration: MotionTokens.standard,
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? tokens.accent
                          : tokens.surfaceMuted,
                      borderRadius: BorderRadius.circular(tokens.radiusPill),
                    ),
                    child: Text(
                      '$badge',
                      style: tokens.captionStyle.copyWith(
                        color: isSelected ? tokens.onAccent : tokens.onSurfaceMuted,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Animated indicator line — animates height not width to avoid
          // infinite-width constraint inside SingleChildScrollView.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: MotionTokens.standard,
              curve: MotionTokens.standardCurve,
              height: isSelected ? 2.0 : 0.0,
              decoration: BoxDecoration(
                color: tokens.accent,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
