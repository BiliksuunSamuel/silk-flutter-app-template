import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A row of PIN-entry dots that pairs naturally with [SilkKeypad].
/// Triggers a horizontal shake animation when [hasError] becomes true.
///
/// Usage:
/// ```dart
/// SilkPinDots(
///   length: 4,
///   filled: _pin.length,
///   hasError: _pinError,
/// )
/// ```
class SilkPinDots extends StatefulWidget {
  const SilkPinDots({
    required this.length,
    required this.filled,
    this.hasError = false,
    this.size = 14.0,
    this.spacing,
    super.key,
  });

  /// Total number of PIN positions.
  final int length;

  /// Number currently filled (0–[length]).
  final int filled;

  /// When flipped to true, dots turn danger colour and the row shakes once.
  final bool hasError;

  final double size;

  /// Space between dots. Defaults to [AppTokens.spaceMd].
  final double? spacing;

  @override
  State<SilkPinDots> createState() => _SilkPinDotsState();
}

class _SilkPinDotsState extends State<SilkPinDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shake;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 8, end: -5), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: -5, end: 5), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 5, end: 0), weight: 1),
    ]).animate(_ctrl);
  }

  @override
  void didUpdateWidget(SilkPinDots old) {
    super.didUpdateWidget(old);
    if (!old.hasError && widget.hasError) {
      _ctrl
        ..reset()
        ..forward();
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
    final gap = widget.spacing ?? tokens.spaceMd;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shake.value, 0),
        child: child,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.length, (i) {
          final isFilled = i < widget.filled;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: gap / 2),
            child: AnimatedContainer(
              duration: MotionTokens.fast,
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.hasError
                    ? (isFilled ? tokens.danger : Colors.transparent)
                    : (isFilled ? tokens.accent : Colors.transparent),
                border: Border.all(
                  color: widget.hasError
                      ? tokens.danger
                      : (isFilled ? tokens.accent : tokens.divider),
                  width: 2,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
