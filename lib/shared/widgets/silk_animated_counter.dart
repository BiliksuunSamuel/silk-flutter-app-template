import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Smoothly animates a numeric value change using an [AnimationController].
///
/// Usage:
/// ```dart
/// SilkAnimatedCounter(
///   value: balance,
///   prefix: '₵ ',
///   formatter: (v) => v.toStringAsFixed(2),
/// )
/// ```
class SilkAnimatedCounter extends StatefulWidget {
  const SilkAnimatedCounter({
    required this.value,
    this.style,
    this.prefix,
    this.suffix,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeOutCubic,
    this.formatter,
    super.key,
  });

  final double value;

  /// Defaults to [AppTokens.displayStyle].
  final TextStyle? style;

  /// Prepended before the formatted value (e.g. '₵ ').
  final String? prefix;

  /// Appended after the formatted value (e.g. '%').
  final String? suffix;

  final Duration duration;
  final Curve curve;

  /// Formats the animated value. Defaults to no decimal places.
  final String Function(double)? formatter;

  @override
  State<SilkAnimatedCounter> createState() => _SilkAnimatedCounterState();
}

class _SilkAnimatedCounterState extends State<SilkAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(SilkAnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      final from = _anim.value;
      _ctrl.duration = widget.duration;
      _anim = Tween<double>(begin: from, end: widget.value)
          .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
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
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final v = _anim.value;
        final formatted =
            widget.formatter != null ? widget.formatter!(v) : v.toStringAsFixed(0);
        return Text(
          '${widget.prefix ?? ''}$formatted${widget.suffix ?? ''}',
          style: widget.style ?? tokens.displayStyle,
        );
      },
    );
  }
}
