import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkRadioOption<T> {
  const SilkRadioOption({
    required this.value,
    required this.label,
    this.description,
  });

  final T value;
  final String label;
  final String? description;
}

class SilkRadioGroup<T> extends StatelessWidget {
  const SilkRadioGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<SilkRadioOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options
          .map(
            (opt) => _RadioTile<T>(
              option: opt,
              isSelected: opt.value == selected,
              onTap: () => onSelected(opt.value),
            ),
          )
          .toList(),
    );
  }
}

class _RadioTile<T> extends StatelessWidget {
  const _RadioTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final SilkRadioOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: tokens.spaceSm),
        child: Row(
          children: [
            AnimatedContainer(
              duration: MotionTokens.fast,
              curve: MotionTokens.standardCurve,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? tokens.accent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? tokens.accent : tokens.onSurfaceMuted,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: tokens.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: tokens.bodyStyle.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (option.description != null)
                    Text(option.description!, style: tokens.captionStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
