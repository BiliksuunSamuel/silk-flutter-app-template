import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkBiometricType { fingerprint, faceId }

enum SilkBiometricState { idle, authenticating, success, failure }

/// Animated biometric authentication button.
/// Manages its own visual state — pass [state] to drive it externally.
///
/// Usage:
/// ```dart
/// SilkBiometricButton(
///   type: SilkBiometricType.fingerprint,
///   state: _bioState,
///   onPressed: _authenticate,
/// )
/// ```
class SilkBiometricButton extends StatefulWidget {
  const SilkBiometricButton({
    required this.onPressed,
    this.type = SilkBiometricType.fingerprint,
    this.state = SilkBiometricState.idle,
    this.size = 72.0,
    super.key,
  });

  final VoidCallback? onPressed;
  final SilkBiometricType type;
  final SilkBiometricState state;
  final double size;

  @override
  State<SilkBiometricButton> createState() => _SilkBiometricButtonState();
}

class _SilkBiometricButtonState extends State<SilkBiometricButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulse = Tween<double>(begin: 1, end: 1.12).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 6, end: -4), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -4, end: 4), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 4, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));

    _syncAnimation();
  }

  @override
  void didUpdateWidget(SilkBiometricButton old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state) _syncAnimation();
  }

  void _syncAnimation() {
    switch (widget.state) {
      case SilkBiometricState.authenticating:
        _ctrl.repeat(reverse: true);
      case SilkBiometricState.failure:
        _ctrl
          ..reset()
          ..forward();
      case SilkBiometricState.idle:
      case SilkBiometricState.success:
        _ctrl.stop();
        _ctrl.reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (bg, fg, icon) = switch (widget.state) {
      SilkBiometricState.idle => (
          tokens.surfaceMuted,
          tokens.accent,
          _typeIcon(widget.type),
        ),
      SilkBiometricState.authenticating => (
          tokens.accent.withValues(alpha: 0.1),
          tokens.accent,
          _typeIcon(widget.type),
        ),
      SilkBiometricState.success => (
          tokens.success.withValues(alpha: 0.12),
          tokens.success,
          Icons.check_rounded,
        ),
      SilkBiometricState.failure => (
          tokens.danger.withValues(alpha: 0.1),
          tokens.danger,
          Icons.close_rounded,
        ),
    };

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final isShaking =
            widget.state == SilkBiometricState.failure;
        final isPulsing =
            widget.state == SilkBiometricState.authenticating;

        return Transform.translate(
          offset: isShaking ? Offset(_shake.value, 0) : Offset.zero,
          child: Transform.scale(
            scale: isPulsing ? _pulse.value : 1.0,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.state == SilkBiometricState.authenticating
            ? null
            : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.state == SilkBiometricState.idle
                  ? tokens.divider
                  : fg.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: widget.state == SilkBiometricState.authenticating
                ? [
                    BoxShadow(
                      color: tokens.accent.withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              icon,
              key: ValueKey(widget.state),
              color: fg,
              size: widget.size * 0.42,
            ),
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(SilkBiometricType type) => switch (type) {
        SilkBiometricType.fingerprint => Icons.fingerprint_rounded,
        SilkBiometricType.faceId => Icons.face_retouching_natural_rounded,
      };
}
