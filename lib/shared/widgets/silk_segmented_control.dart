import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkSegment<T> {
  const SilkSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// iOS-style segmented control: a sunken track with a raised thumb that slides
/// between segments (250 ms, easeOutCubic).
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
    final count = segments.length;
    final index = segments.indexWhere((s) => s.value == selected);
    final reduce = MediaQuery.disableAnimationsOf(context);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
      ),
      child: SizedBox(
        height: 36,
        child: Stack(
          children: [
            if (index >= 0 && count > 0)
              AnimatedAlign(
                duration: reduce
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: count == 1
                    ? Alignment.center
                    : Alignment(-1 + 2 * index / (count - 1), 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / count,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.surface,
                      borderRadius: BorderRadius.circular(tokens.radiusSegment),
                      boxShadow: tokens.shadowSegment,
                    ),
                  ),
                ),
              ),
            Row(
              children: segments.map((seg) {
                final isSelected = seg.value == selected;
                final fg = isSelected
                    ? tokens.onSurface
                    : tokens.onSurfaceMuted;
                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: isSelected,
                    label: seg.label,
                    excludeSemantics: true,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (isSelected) return;
                        Haptics.selection();
                        onSelected(seg.value);
                      },
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (seg.icon != null) ...[
                              Icon(seg.icon, size: 14, color: fg),
                              SizedBox(width: tokens.spaceXs),
                            ],
                            Flexible(
                              child: Text(
                                seg.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tokens.bodySmStyle.copyWith(
                                  color: fg,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
