import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// An animated semicircular gauge chart suitable for KPI displays.
class SilkGaugeChart extends StatefulWidget {
  const SilkGaugeChart({
    required this.value,
    this.min = 0,
    this.max = 100,
    this.size = 200,
    this.strokeWidth = 20,
    this.label,
    this.valueFormatter,
    this.gradientColors,
    super.key,
  });

  final double value;
  final double min;
  final double max;
  final double size;
  final double strokeWidth;
  final String? label;
  final String Function(double)? valueFormatter;
  final List<Color>? gradientColors;

  @override
  State<SilkGaugeChart> createState() => _SilkGaugeChartState();
}

class _SilkGaugeChartState extends State<SilkGaugeChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final defaultGradient = [tokens.accent, const Color(0xFF7C3AED)];
    final gradientColors = widget.gradientColors ?? defaultGradient;

    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) {
        return SizedBox(
          width: widget.size,
          height: widget.size * 0.6,
          child: CustomPaint(
            painter: _GaugePainter(
              value: widget.value,
              min: widget.min,
              max: widget.max,
              strokeWidth: widget.strokeWidth,
              progress: _progress.value,
              gradientColors: gradientColors,
              trackColor: tokens.divider,
              valueLabelColor: tokens.onSurface,
              subtitleColor: tokens.onSurfaceMuted,
              label: widget.label,
              valueText: widget.valueFormatter != null
                  ? widget.valueFormatter!(widget.value)
                  : widget.value.toStringAsFixed(0),
              valueLabelStyle: tokens.titleStyle,
              subtitleStyle: tokens.captionStyle,
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.value,
    required this.min,
    required this.max,
    required this.strokeWidth,
    required this.progress,
    required this.gradientColors,
    required this.trackColor,
    required this.valueLabelColor,
    required this.subtitleColor,
    required this.label,
    required this.valueText,
    required this.valueLabelStyle,
    required this.subtitleStyle,
  });

  final double value;
  final double min;
  final double max;
  final double strokeWidth;
  final double progress;
  final List<Color> gradientColors;
  final Color trackColor;
  final Color valueLabelColor;
  final Color subtitleColor;
  final String? label;
  final String valueText;
  final TextStyle valueLabelStyle;
  final TextStyle subtitleStyle;

  static const double _startAngle = math.pi;
  static const double _sweepAngle = -math.pi;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, trackPaint);

    final fraction = max == min
        ? 0.0
        : ((value - min) / (max - min)).clamp(0.0, 1.0);
    final filledSweep = _sweepAngle * fraction * progress;

    if (fraction > 0 && progress > 0) {
      final gradient = ui.Gradient.sweep(
        center,
        gradientColors,
        null,
        TileMode.clamp,
        _startAngle,
        _startAngle + filledSweep,
      );

      final fillPaint = Paint()
        ..shader = gradient
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, _startAngle, filledSweep, false, fillPaint);

      final tipAngle = _startAngle + filledSweep;
      final tipX = center.dx + radius * math.cos(tipAngle);
      final tipY = center.dy + radius * math.sin(tipAngle);
      final tipOffset = Offset(tipX, tipY);
      final tipColor = gradientColors.last;

      canvas
        ..drawCircle(
          tipOffset,
          strokeWidth / 2 + 2,
          Paint()..color = tipColor,
        )
        ..drawCircle(
          tipOffset,
          strokeWidth / 4,
          Paint()..color = Colors.white,
        );
    }

    final valueTp = TextPainter(
      text: TextSpan(
        text: valueText,
        style: valueLabelStyle.copyWith(
          color: valueLabelColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final valueOffset = Offset(
      center.dx - valueTp.width / 2,
      size.height - valueTp.height - (label != null ? 18 : 4),
    );
    valueTp.paint(canvas, valueOffset);

    if (label != null) {
      final labelTp = TextPainter(
        text: TextSpan(
          text: label,
          style: subtitleStyle.copyWith(color: subtitleColor),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      labelTp.paint(
        canvas,
        Offset(center.dx - labelTp.width / 2, size.height - labelTp.height),
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress ||
      old.value != value ||
      old.gradientColors != gradientColors;
}
