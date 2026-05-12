import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

class SilkCheckbox extends StatefulWidget {
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
  State<SilkCheckbox> createState() => _SilkCheckboxState();
}

class _SilkCheckboxState extends State<SilkCheckbox> {
  final _boxKey = GlobalKey();

  void _handleTap() {
    final boxCtx = _boxKey.currentContext;
    if (boxCtx != null) {
      SilkReactionBurst.trigger(
        context: boxCtx,
        color: context.tokens.accent,
        particleCount: 6,
        spreadRadius: 22,
      );
    }
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final enabled = widget.onChanged != null;

    final box = AnimatedContainer(
      key: _boxKey,
      duration: MotionTokens.fast,
      curve: MotionTokens.standardCurve,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: widget.value ? tokens.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radiusSm),
        border: widget.value
            ? null
            : Border.all(color: tokens.onSurfaceMuted, width: 1.5),
      ),
      child: AnimatedOpacity(
        opacity: widget.value ? 1.0 : 0.0,
        duration: MotionTokens.fast,
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      ),
    );

    final lbl = widget.label;
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

    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.4,
      duration: MotionTokens.micro,
      child: GestureDetector(
        onTap: enabled ? _handleTap : null,
        child: content,
      ),
    );
  }
}
