import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Circular progress indicator drawn with [CustomPainter].
///
/// Usage:
/// ```dart
/// SilkProgressRing(
///   value: 0.72,
///   size: 80,
///   child: Text('72%'),
/// )
/// ```
class SilkProgressRing extends StatelessWidget {
  const SilkProgressRing({
    required this.value,
    this.size = 80.0,
    this.strokeWidth = 8.0,
    this.color,
    this.backgroundColor,
    this.child,
    super.key,
  });

  /// 0.0–1.0
  final double value;
  final double size;
  final double strokeWidth;

  /// Defaults to [AppTokens.accent].
  final Color? color;

  /// Defaults to [AppTokens.divider].
  final Color? backgroundColor;

  /// Optional widget displayed in the centre of the ring.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final fg = color ?? tokens.accent;
    final bg = backgroundColor ?? tokens.divider;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, v, innerChild) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(
            value: v,
            foreground: fg,
            background: bg,
            strokeWidth: strokeWidth,
          ),
          child: innerChild,
        ),
      ),
      child: child != null ? Center(child: child) : null,
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.foreground,
    required this.background,
    required this.strokeWidth,
  });

  final double value;
  final Color foreground;
  final Color background;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final fgPaint = Paint()
      ..color = foreground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * math.pi, false, bgPaint);

    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.foreground != foreground ||
      old.background != background ||
      old.strokeWidth != strokeWidth;
}
