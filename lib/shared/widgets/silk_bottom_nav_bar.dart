import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/frosted_bar.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

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

    // Frosted bottom bar: content scrolls beneath it, blurred. Hairline on top.
    return FrostedBar(
      top: false,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spaceSm - 2),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == currentIndex;

              return Expanded(
                child: SilkReactionBurst(
                  onTap: () {
                    if (i != currentIndex) Haptics.selection();
                    onTap(i);
                  },
                  color: tokens.accent,
                  particleCount: 8,
                  spreadRadius: 32,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 24pt line icon; no pill indicator, no elevation.
                        Icon(
                          item.icon,
                          size: 24,
                          color: selected
                              ? tokens.accent
                              : tokens.onSurfaceMuted,
                        ),
                        SizedBox(height: tokens.spaceXs),
                        AnimatedDefaultTextStyle(
                          style: tokens.captionStyle.copyWith(
                            color: selected
                                ? tokens.accent
                                : tokens.onSurfaceMuted,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          duration: MotionTokens.fast,
                          child: Text(item.label),
                        ),
                      ],
                    ),
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
