import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A minimal inline line chart for showing value trends.
/// No axes, no labels — purely visual signal.
///
/// Usage:
/// ```dart
/// SilkSparkline(
///   data: [120, 135, 128, 160, 155, 172, 190],
///   width: 120,
///   height: 40,
/// )
/// ```
class SilkSparkline extends StatelessWidget {
  const SilkSparkline({
    required this.data,
    this.width = 120,
    this.height = 40,
    this.color,
    this.strokeWidth = 2.0,
    this.filled = true,
    super.key,
  });

  final List<double> data;
  final double width;
  final double height;

  /// Defaults to [AppTokens.accent].
  final Color? color;
  final double strokeWidth;

  /// When true, fills the area under the curve with a gradient.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final effectiveColor = color ?? tokens.accent;

    if (data.length < 2) {
      return SizedBox(width: width, height: height);
    }

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(
          data: data,
          color: effectiveColor,
          strokeWidth: strokeWidth,
          filled: filled,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
    required this.filled,
  });

  final List<double> data;
  final Color color;
  final double strokeWidth;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal).abs();
    final effectiveRange = range == 0 ? 1.0 : range;

    double xOf(int i) => i / (data.length - 1) * size.width;
    double yOf(double v) =>
        size.height - ((v - minVal) / effectiveRange) * size.height;

    final path = Path()..moveTo(xOf(0), yOf(data[0]));
    for (var i = 1; i < data.length; i++) {
      final x0 = xOf(i - 1);
      final y0 = yOf(data[i - 1]);
      final x1 = xOf(i);
      final y1 = yOf(data[i]);
      final cpX = (x0 + x1) / 2;
      path.cubicTo(cpX, y0, cpX, y1, x1, y1);
    }

    if (filled) {
      final fillPath = Path.from(path)
        ..lineTo(xOf(data.length - 1), size.height)
        ..lineTo(0, size.height)
        ..close();

      final gradient = ui.Gradient.linear(
        Offset.zero,
        Offset(0, size.height),
        [color.withValues(alpha: 0.25), color.withValues(alpha: 0)],
      );
      canvas.drawPath(
        fillPath,
        Paint()..shader = gradient,
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.data != data ||
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.filled != filled;
}
