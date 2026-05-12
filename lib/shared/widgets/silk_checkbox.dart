import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

class SilkCheckbox extends StatelessWidget {
  const SilkCheckbox({
    required this.value,
    required this.onChanged,
    this.label,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final enabled = onChanged != null;

    final box = AnimatedContainer(
      duration: MotionTokens.fast,
      curve: MotionTokens.standardCurve,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: value ? tokens.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radiusSm),
        border: value ? null : Border.all(color: tokens.onSurfaceMuted, width: 1.5),
      ),
      child: AnimatedOpacity(
        opacity: value ? 1.0 : 0.0,
        duration: MotionTokens.fast,
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      ),
    );

    final lbl = label;
    final content = lbl != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              box,
              SizedBox(width: tokens.spaceSm),
              Text(lbl, style: tokens.bodyStyle),
            ],
          )
        : box as Widget;

    if (!enabled) {
      return Opacity(opacity: 0.4, child: content);
    }

    return SilkReactionBurst(
      onTap: () => onChanged!(!value),
      color: tokens.accent,
      particleCount: 6,
      spreadRadius: 22,
      child: content,
    );
  }
}
