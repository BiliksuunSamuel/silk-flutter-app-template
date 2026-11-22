import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

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

class _RadioTile<T> extends StatefulWidget {
  const _RadioTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final SilkRadioOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_RadioTile<T>> createState() => _RadioTileState<T>();
}

class _RadioTileState<T> extends State<_RadioTile<T>> {
  final _dotKey = GlobalKey();

  void _handleTap() {
    final dotCtx = _dotKey.currentContext;
    if (dotCtx != null) {
      SilkReactionBurst.trigger(
        context: dotCtx,
        color: context.tokens.accent,
        particleCount: 6,
        spreadRadius: 24,
      );
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spaceSm),
          child: Row(
            children: [
              AnimatedContainer(
                key: _dotKey,
                duration: MotionTokens.fast,
                curve: MotionTokens.standardCurve,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected ? tokens.accent : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? tokens.accent
                        : tokens.onSurfaceMuted,
                    width: 1.5,
                  ),
                ),
                child: widget.isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: tokens.onAccent,
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
                      widget.option.label,
                      style: tokens.bodyStyle.copyWith(
                        fontWeight: widget.isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    if (widget.option.description != null)
                      Text(
                        widget.option.description!,
                        style: tokens.captionStyle,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
