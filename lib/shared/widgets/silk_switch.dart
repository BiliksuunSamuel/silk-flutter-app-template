import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkSwitch extends StatefulWidget {
  const SilkSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<SilkSwitch> createState() => _SilkSwitchState();
}

class _SilkSwitchState extends State<SilkSwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  static const _trackW = 52.0;
  static const _trackH = 30.0;
  static const _thumbD = 24.0;
  static const _thumbPad = 3.0;
  static const _travel = _trackW - _thumbD - _thumbPad * 2;

  @override
  void initState() {
    super.initState();
    // Allow spring overshoot beyond 1.0
    _ctrl = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1.5,
      value: widget.value ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(SilkSwitch old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      _animateTo(widget.value ? 1.0 : 0.0);
    }
  }

  void _animateTo(double target) {
    final spring = SpringDescription.withDampingRatio(
      mass: 1,
      stiffness: 600,
      ratio: 0.72,
    );
    _ctrl.animateWith(SpringSimulation(spring, _ctrl.value, target, 0));
  }

  void _toggle() {
    if (widget.onChanged == null) return;
    Haptics.light();
    widget.onChanged!(!widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final enabled = widget.onChanged != null;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: MotionTokens.micro,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final t = _ctrl.value.clamp(0.0, 1.0);
            final trackColor = Color.lerp(
              tokens.onSurface.withValues(alpha: 0.12),
              tokens.accent,
              t,
            )!;
            final thumbX = _thumbPad + _travel * t;

            return SizedBox(
              width: _trackW,
              height: _trackH,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: trackColor,
                        borderRadius: BorderRadius.circular(tokens.radiusPill),
                      ),
                    ),
                  ),
                  Positioned(
                    left: thumbX,
                    top: _thumbPad,
                    child: Container(
                      width: _thumbD,
                      height: _thumbD,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
