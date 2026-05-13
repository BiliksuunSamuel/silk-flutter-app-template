import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkNumericStepper extends StatelessWidget {
  const SilkNumericStepper({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.formatter,
    super.key,
  });

  final int value;
  final void Function(int value) onChanged;
  final int min;
  final int max;
  final int step;

  /// Converts [value] to a display string. Defaults to plain integer.
  final String Function(int)? formatter;

  String _display(int v) => formatter != null ? formatter!(v) : '$v';

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final canDecrement = value > min;
    final canIncrement = value < max;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(tokens.radiusPill),
        border: Border.all(color: tokens.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove_rounded,
            enabled: canDecrement,
            onTap: canDecrement ? () => onChanged(value - step) : null,
          ),
          SizedBox(
            width: 40,
            child: AnimatedSwitcher(
              duration: MotionTokens.fast,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Text(
                _display(value),
                key: ValueKey(value),
                textAlign: TextAlign.center,
                style: tokens.bodySmStyle.copyWith(
                  color: tokens.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            enabled: canIncrement,
            onTap: canIncrement ? () => onChanged(value + step) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: MotionTokens.fast,
        opacity: enabled ? 1.0 : 0.35,
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceSm),
          child: Icon(icon, size: 18, color: tokens.onSurface),
        ),
      ),
    );
  }
}
