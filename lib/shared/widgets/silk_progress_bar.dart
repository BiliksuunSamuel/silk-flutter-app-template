import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkProgressBarVariant { accent, success, danger }

class SilkProgressBar extends StatelessWidget {
  const SilkProgressBar({
    required this.value,
    this.variant = SilkProgressBarVariant.accent,
    this.height = 6,
    this.label,
    super.key,
  }) : assert(value >= 0.0 && value <= 1.0, 'value must be between 0 and 1');

  final double value;
  final SilkProgressBarVariant variant;
  final double height;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final fillColor = switch (variant) {
      SilkProgressBarVariant.accent => tokens.accent,
      SilkProgressBarVariant.success => tokens.success,
      SilkProgressBarVariant.danger => tokens.danger,
    };

    final lbl = label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (lbl != null) ...[
          Text(lbl, style: tokens.captionStyle),
          SizedBox(height: tokens.spaceXs),
        ],
        LayoutBuilder(
          builder: (_, constraints) => Container(
            height: height,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(tokens.radiusPill),
            ),
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: MotionTokens.emphasized,
              curve: MotionTokens.emphasizedDecel,
              height: height,
              width: constraints.maxWidth * value,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(tokens.radiusPill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
