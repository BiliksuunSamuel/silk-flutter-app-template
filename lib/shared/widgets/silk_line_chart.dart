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

/// A 3D-ribbon line chart with labelled axes and optional touch interaction.
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
    this.lineDepth = 5,
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

  /// Depth of the 3D ribbon in pixels. Set to 0 to disable.
  final int lineDepth;

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
    final maxPoints =
        widget.series.map((s) => s.data.length).reduce(math.max);

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, __) => GestureDetector(
          onTapUp: (d) {
            final frac = d.localPosition.dx / context.size!.width;
            final idx =
                (frac * (maxPoints - 1)).round().clamp(0, maxPoints - 1);
            setState(() => _touchIndex = idx);
          },
          onTapDown: (_) => setState(() => _touchIndex = null),
          child: CustomPaint(
            painter: _LineChartPainter(
              series: widget.series,
              xLabels: widget.xLabels,
              yMin: yMin,
              yMax: yMax,
              maxPoints: maxPoints,
              progress: _progress.value,
              showDots: widget.showDots,
              showGrid: widget.showGrid,
              gridLines: widget.gridLines,
              gridColor: tokens.divider,
              labelColor: tokens.onSurfaceMuted,
              lineDepth: widget.lineDepth,
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
    required this.lineDepth,
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
  final int lineDepth;
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

    // Builds the bezier path for a series at an optional y-offset for depth layers.
    Path buildPath(List<double> data, int clipPts, double yOffset) {
      final path = Path()..moveTo(xOf(0), yOf(data[0]) + yOffset);
      for (var i = 1; i < clipPts; i++) {
        final cpX = (xOf(i - 1) + xOf(i)) / 2;
        path.cubicTo(
          cpX, yOf(data[i - 1]) + yOffset,
          cpX, yOf(data[i]) + yOffset,
          xOf(i), yOf(data[i]) + yOffset,
        );
      }
      return path;
    }

    final labelPaint = TextPainter(textDirection: ui.TextDirection.ltr);
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // Y-axis grid lines + labels
    if (showGrid) {
      for (var g = 0; g <= gridLines; g++) {
        final v = yMin + (yRange * g / gridLines);
        final y = yOf(v);
        canvas.drawLine(Offset(_leftPad, y), Offset(size.width, y), gridPaint);
        labelPaint
          ..text = TextSpan(
            text: _formatY(v),
            style: TextStyle(color: labelColor, fontSize: 9),
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

    // Touch scrubber line
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
      final mainPath = buildPath(s.data, clipPts, 0);

      // Area fill
      if (s.filled) {
        final lastX = xOf(clipPts - 1);
        final fillPath = Path.from(mainPath)
          ..lineTo(lastX, chartH)
          ..lineTo(xOf(0), chartH)
          ..close();
        canvas.drawPath(
          fillPath,
          Paint()
            ..shader = ui.Gradient.linear(
              Offset.zero,
              Offset(0, chartH),
              [s.color.withValues(alpha: 0.22), s.color.withValues(alpha: 0)],
            ),
        );
      }

      // 3D ribbon: depth layers drawn bottom-to-top
      if (lineDepth > 0) {
        for (var d = lineDepth; d >= 1; d--) {
          final t = d / lineDepth;
          canvas.drawPath(
            buildPath(s.data, clipPts, d.toDouble()),
            Paint()
              ..color = Color.lerp(s.color, Colors.black, t * 0.55)!
              ..strokeWidth = 3
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round,
          );
        }
      }

      // Main ribbon face: vertical gradient (lighter at top → base color)
      canvas
        ..drawPath(
          mainPath,
          Paint()
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..shader = ui.Gradient.linear(
              Offset.zero,
              Offset(0, chartH),
              [Color.lerp(s.color, Colors.white, 0.35)!, s.color],
            ),
        )

        // Top-edge highlight gloss
        ..drawPath(
          mainPath,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.28)
            ..strokeWidth = 1
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );

      // Dots
      if (showDots) {
        for (var i = 0; i < clipPts; i++) {
          final x = xOf(i);
          final y = yOf(s.data[i]);
          final isTouch = touchIndex == i;
          final dotR = isTouch ? 5.0 : 3.5;

          // Drop shadow
          canvas.drawCircle(
            Offset(x + 1.5, y + 2),
            dotR,
            Paint()..color = s.color.withValues(alpha: 0.30),
          );

          if (isTouch) {
            canvas.drawCircle(
              Offset(x, y),
              8,
              Paint()
                ..color = s.color.withValues(alpha: 0.18)
                ..style = PaintingStyle.fill,
            );
          }

          // Solid dot + specular highlight
          canvas
            ..drawCircle(Offset(x, y), dotR, Paint()..color = s.color)
            ..drawCircle(
              Offset(x - dotR * 0.30, y - dotR * 0.35),
              dotR * 0.38,
              Paint()..color = Colors.white.withValues(alpha: 0.55),
            );
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
      old.progress != progress ||
      old.touchIndex != touchIndex ||
      old.lineDepth != lineDepth;
}
