import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkCountdownTimer extends StatefulWidget {
  const SilkCountdownTimer({
    required this.duration,
    required this.onComplete,
    this.style,
    this.format = SilkCountdownFormat.mmss,
    this.builder,
    super.key,
  });

  /// Total countdown duration.
  final Duration duration;

  /// Called once when the countdown reaches zero.
  final VoidCallback onComplete;

  /// Text style for the default display. Defaults to [AppTokens.monoStyle].
  final TextStyle? style;

  final SilkCountdownFormat format;

  /// Optional builder for a fully custom display.
  /// Receives remaining [Duration] and returns a widget.
  final Widget Function(BuildContext context, Duration remaining)? builder;

  @override
  State<SilkCountdownTimer> createState() => _SilkCountdownTimerState();
}

enum SilkCountdownFormat {
  /// MM:SS  (e.g. 01:30)
  mmss,

  /// Seconds only  (e.g. 90s)
  seconds,

  /// Human-readable  (e.g. 1m 30s)
  human,
}

class _SilkCountdownTimerState extends State<SilkCountdownTimer> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _start();
  }

  @override
  void didUpdateWidget(SilkCountdownTimer old) {
    super.didUpdateWidget(old);
    if (old.duration != widget.duration) {
      _timer?.cancel();
      _remaining = widget.duration;
      _start();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 1) {
        _timer?.cancel();
        setState(() => _remaining = Duration.zero);
        widget.onComplete();
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  String _format(Duration d) => switch (widget.format) {
        SilkCountdownFormat.mmss => _mmss(d),
        SilkCountdownFormat.seconds => '${d.inSeconds}s',
        SilkCountdownFormat.human => _human(d),
      };

  String _mmss(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _human(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final customBuilder = widget.builder;
    if (customBuilder != null) return customBuilder(context, _remaining);

    final tokens = context.tokens;
    final isDone = _remaining == Duration.zero;

    return AnimatedDefaultTextStyle(
      duration: MotionTokens.fast,
      style: (widget.style ?? tokens.monoStyle).copyWith(
        color: isDone ? tokens.onSurfaceMuted : tokens.onSurface,
      ),
      child: Text(_format(_remaining)),
    );
  }
}
