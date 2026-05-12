import 'dart:math' as math;

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

  static const _trackW = 56.0;
  static const _trackH = 30.0;
  static const _thumbD = 24.0;
  static const _thumbPad = 3.0;
  static const _maxStretch = 10.0;

  // Thumb center x-coordinates at each extreme.
  static const _centerLeft = _thumbPad + _thumbD / 2;
  static const _centerRight = _trackW - _thumbPad - _thumbD / 2;
  static const _centerTravel = _centerRight - _centerLeft;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
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
      stiffness: 500,
      ratio: 0.68,
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
            // Clamp position to track bounds; spring overshoot is absorbed.
            final t = _ctrl.value.clamp(0.0, 1.0);

            // Thumb stretches into a pill at mid-travel, snaps back to circle.
            final stretch = _maxStretch * math.sin(math.pi * t);
            final thumbW = _thumbD + stretch;

            final centerX = _centerLeft + _centerTravel * t;
            final thumbLeft = centerX - thumbW / 2;

            final trackColor = Color.lerp(
              tokens.onSurface.withValues(alpha: 0.13),
              tokens.accent,
              t,
            )!;

            return SizedBox(
              width: _trackW,
              height: _trackH,
              child: Stack(
                clipBehavior: Clip.antiAlias,
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
                    left: thumbLeft,
                    top: _thumbPad,
                    child: Container(
                      width: thumbW,
                      height: _thumbD,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(_thumbD / 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 8,
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
