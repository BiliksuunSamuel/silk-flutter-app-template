import 'package:flutter/material.dart';
import 'package:silk/core/motion/haptics.dart';

/// Which haptic a [PressableScale] fires on tap.
enum PressHaptic { none, selection, light, medium }

/// Native-feeling press feedback: scales to 0.97 on press (120 ms, easeOut) and
/// springs back (220 ms, easeOutBack). Replaces ink ripples across Silk.
///
/// Respects reduced-motion: with animations disabled the scale is skipped.
class PressableScale extends StatefulWidget {
  const PressableScale({
    required this.child,
    required this.onTap,
    this.haptic = PressHaptic.selection,
    this.scale = 0.97,
    this.behavior = HitTestBehavior.opaque,
    super.key,
  });

  final Widget child;

  /// Null disables the press (no scale, no haptic).
  final VoidCallback? onTap;
  final PressHaptic haptic;
  final double scale;
  final HitTestBehavior behavior;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v && mounted) setState(() => _down = v);
  }

  void _handleTap() {
    switch (widget.haptic) {
      case PressHaptic.none:
        break;
      case PressHaptic.selection:
        Haptics.selection();
      case PressHaptic.light:
        Haptics.light();
      case PressHaptic.medium:
        Haptics.medium();
    }
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final reduce = MediaQuery.disableAnimationsOf(context);

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: enabled ? (_) => _set(true) : null,
      onTapCancel: enabled ? () => _set(false) : null,
      onTapUp: enabled ? (_) => _set(false) : null,
      onTap: enabled ? _handleTap : null,
      child: AnimatedScale(
        scale: enabled && _down && !reduce ? widget.scale : 1,
        duration: Duration(milliseconds: _down ? 120 : 220),
        curve: _down ? Curves.easeOut : Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}
