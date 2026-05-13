import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkLineSeries {
  const SilkLineSeries({
    required this.data,
    required this.color,
    this.label,
    this.filled = true,
  });

  final List<double> data;
  final Color color;
  final String? label;

  /// Whether to fill the area under the curve.
  final bool filled;
}

/// A line chart with labelled axes and optional touch interaction.
/// Supports multiple series. Uses smooth bezier curves.
///
/// Usage:
/// ```dart
/// SilkLineChart(
///   series: [
///     SilkLineSeries(
///       label: 'Portfolio',
///       data: [9800, 10200, 11000, 12480],
///       color: tokens.accent,
///     ),
///   ],
///   xLabels: ['Jan', 'Feb', 'Mar', 'Apr'],
///   height: 200,
/// )
/// ```
class SilkLineChart extends StatefulWidget {
  const SilkLineChart({
    required this.series,
    this.xLabels = const [],
    this.height = 200,
    this.showDots = true,
    this.showGrid = true,
    this.yMin,
    this.yMax,
    this.gridLines = 4,
    super.key,
  });

  final List<SilkLineSeries> series;
  final List<String> xLabels;
  final double height;
  final bool showDots;
  final bool showGrid;
  final double? yMin;
  final double? yMax;
  final int gridLines;

  @override
  State<SilkLineChart> createState() => _SilkLineChartState();
}

class _SilkLineChartState extends State<SilkLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;
  int? _touchIndex;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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

    if (widget.series.isEmpty) return SizedBox(height: widget.height);

    final allValues = widget.series.expand((s) => s.data).toList();
    final yMin = widget.yMin ?? allValues.reduce(math.min);
    final yMax = widget.yMax ?? allValues.reduce(math.max);
    final maxPoints = widget.series.map((s) => s.data.length).reduce(math.max);
    final xLabels = widget.xLabels;

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, __) => GestureDetector(
          onTapUp: (d) {
            final frac = d.localPosition.dx / context.size!.width;
            final idx = (frac * (maxPoints - 1)).round().clamp(0, maxPoints - 1);
            setState(() => _touchIndex = idx);
          },
          onTapDown: (_) => setState(() => _touchIndex = null),
          child: CustomPaint(
            painter: _LineChartPainter(
              series: widget.series,
              xLabels: xLabels,
              yMin: yMin,
              yMax: yMax,
              maxPoints: maxPoints,
              progress: _progress.value,
              showDots: widget.showDots,
              showGrid: widget.showGrid,
              gridLines: widget.gridLines,
              gridColor: tokens.divider,
              labelColor: tokens.onSurfaceMuted,
              touchIndex: _touchIndex,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.series,
    required this.xLabels,
    required this.yMin,
    required this.yMax,
    required this.maxPoints,
    required this.progress,
    required this.showDots,
    required this.showGrid,
    required this.gridLines,
    required this.gridColor,
    required this.labelColor,
    this.touchIndex,
  });

  final List<SilkLineSeries> series;
  final List<String> xLabels;
  final double yMin;
  final double yMax;
  final int maxPoints;
  final double progress;
  final bool showDots;
  final bool showGrid;
  final int gridLines;
  final Color gridColor;
  final Color labelColor;
  final int? touchIndex;

  static const _labelHeight = 20.0;
  static const _leftPad = 40.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartH = size.height - _labelHeight;
    final chartW = size.width - _leftPad;
    final yRange = (yMax - yMin).abs() == 0 ? 1.0 : (yMax - yMin).abs();

    double xOf(int i) => _leftPad + (i / (maxPoints - 1)) * chartW;
    double yOf(double v) => chartH - ((v - yMin) / yRange) * chartH;

    final labelPaint = TextPainter(textDirection: ui.TextDirection.ltr);
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // Y-axis grid lines + labels
    if (showGrid) {
      for (var g = 0; g <= gridLines; g++) {
        final v = yMin + (yRange * g / gridLines);
        final y = yOf(v);
        canvas.drawLine(
          Offset(_leftPad, y),
          Offset(size.width, y),
          gridPaint,
        );
        labelPaint
          ..text = TextSpan(
            text: _formatY(v),
            style: TextStyle(
              color: labelColor,
              fontSize: 9,
            ),
          )
          ..layout()
          ..paint(canvas, Offset(0, y - labelPaint.height / 2));
      }
    }

    // X-axis labels
    for (var i = 0; i < xLabels.length && i < maxPoints; i++) {
      labelPaint
        ..text = TextSpan(
          text: xLabels[i],
          style: TextStyle(color: labelColor, fontSize: 9),
        )
        ..layout()
        ..paint(canvas, Offset(xOf(i) - labelPaint.width / 2, chartH + 4));
    }

    // Touch index vertical line
    if (touchIndex != null) {
      final x = xOf(touchIndex!);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, chartH),
        Paint()
          ..color = gridColor
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke,
      );
    }

    // Series
    for (final s in series) {
      if (s.data.isEmpty) continue;
      final pts = s.data.length;
      final clipPts = (pts * progress).ceil().clamp(2, pts);

      final path = Path()
        ..moveTo(xOf(0), yOf(s.data[0]));
      for (var i = 1; i < clipPts; i++) {
        final x0 = xOf(i - 1);
        final y0 = yOf(s.data[i - 1]);
        final x1 = xOf(i);
        final y1 = yOf(s.data[i]);
        final cpX = (x0 + x1) / 2;
        path.cubicTo(cpX, y0, cpX, y1, x1, y1);
      }

      if (s.filled) {
        final lastX = xOf(clipPts - 1);
        final fillPath = Path.from(path)
          ..lineTo(lastX, chartH)
          ..lineTo(xOf(0), chartH)
          ..close();

        final gradient = ui.Gradient.linear(
          Offset.zero,
          Offset(0, chartH),
          [s.color.withValues(alpha: 0.2), s.color.withValues(alpha: 0)],
        );
        canvas.drawPath(fillPath, Paint()..shader = gradient);
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = s.color
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      if (showDots) {
        for (var i = 0; i < clipPts; i++) {
          final x = xOf(i);
          final y = yOf(s.data[i]);
          final isTouch = touchIndex == i;
          canvas.drawCircle(
            Offset(x, y),
            isTouch ? 5 : 3.5,
            Paint()..color = s.color,
          );
          if (isTouch) {
            canvas.drawCircle(
              Offset(x, y),
              8,
              Paint()
                ..color = s.color.withValues(alpha: 0.2)
                ..style = PaintingStyle.fill,
            );
          }
        }
      }
    }
  }

  String _formatY(double v) {
    if (v.abs() >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) =>
      old.progress != progress || old.touchIndex != touchIndex;
}
