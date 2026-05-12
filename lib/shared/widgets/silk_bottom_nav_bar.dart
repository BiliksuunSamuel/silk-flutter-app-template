import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkNavItem {
  const SilkNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class SilkBottomNavBar extends StatelessWidget {
  const SilkBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<SilkNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.surface,
        border: Border(top: BorderSide(color: tokens.divider)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spaceSm),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: MotionTokens.fast,
                        curve: MotionTokens.emphasizedDecel,
                        padding: EdgeInsets.symmetric(
                          horizontal: tokens.spaceMd,
                          vertical: tokens.spaceXs,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? tokens.accent.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(tokens.radiusPill),
                        ),
                        child: Icon(
                          item.icon,
                          size: 22,
                          color: selected ? tokens.accent : tokens.onSurfaceMuted,
                        ),
                      ),
                      SizedBox(height: tokens.spaceXs),
                      AnimatedDefaultTextStyle(
                        style: tokens.captionStyle.copyWith(
                          color: selected ? tokens.accent : tokens.onSurfaceMuted,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        duration: MotionTokens.fast,
                        child: Text(item.label),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
