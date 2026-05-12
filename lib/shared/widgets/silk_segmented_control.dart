import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkSegment<T> {
  const SilkSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

class SilkSegmentedControl<T> extends StatelessWidget {
  const SilkSegmentedControl({
    required this.segments,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<SilkSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: segments.map((seg) {
          final isSelected = seg.value == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(seg.value),
              child: AnimatedContainer(
                duration: MotionTokens.fast,
                curve: MotionTokens.emphasizedDecel,
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spaceSm,
                  vertical: tokens.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? tokens.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(tokens.radiusSm + 1),
                  boxShadow: isSelected ? tokens.shadowSm : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (seg.icon != null) ...[
                      Icon(
                        seg.icon,
                        size: 14,
                        color: isSelected ? tokens.accent : tokens.onSurfaceMuted,
                      ),
                      SizedBox(width: tokens.spaceXs),
                    ],
                    Text(
                      seg.label,
                      style: tokens.captionStyle.copyWith(
                        color: isSelected ? tokens.onSurface : tokens.onSurfaceMuted,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
