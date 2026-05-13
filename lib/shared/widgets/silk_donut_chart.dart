import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

@immutable
class SilkDonutSegment {
  const SilkDonutSegment({
    required this.value,
    required this.color,
    this.label,
  });

  final double value;
  final Color color;
  final String? label;
}

class SilkDonutChart extends StatefulWidget {
  const SilkDonutChart({
    required this.segments,
    this.size = 140,
    this.strokeWidth = 20,
    this.gap = 2.0,
    this.depth = 14.0,
    this.tiltY = 0.60,
    this.child,
    super.key,
  });

  final List<SilkDonutSegment> segments;
  final double size;
  final double strokeWidth;
  final double gap;
  final double depth;
  final double tiltY;
  final Widget? child;

  @override
  State<SilkDonutChart> createState() => _SilkDonutChartState();
}

class _SilkDonutChartState extends State<SilkDonutChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
    final w = widget.size;
    final h = widget.size * 0.85;

    return SizedBox(
      width: w,
      height: h,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, __) => CustomPaint(
          painter: _DonutPainter(
            segments: widget.segments,
            strokeWidth: widget.strokeWidth,
            gapDeg: widget.gap,
            progress: _progress.value,
            depth: widget.depth,
            tiltY: widget.tiltY,
          ),
          child: widget.child != null ? Center(child: widget.child) : null,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.segments,
    required this.strokeWidth,
    required this.gapDeg,
    required this.progress,
    required this.depth,
    required this.tiltY,
  });

  final List<SilkDonutSegment> segments;
  final double strokeWidth;
  final double gapDeg;
  final double progress;
  final double depth;
  final double tiltY;

  static const int _extrusionLayers = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 - (depth * tiltY / 2);
    final radius = (size.width - strokeWidth) / 2;

    final total = segments.fold<double>(0, (s, seg) => s + seg.value);
    if (total == 0) return;

    final gapRad = gapDeg * math.pi / 180;
    final totalGap = gapRad * segments.length;
    final availableAngle = (2 * math.pi - totalGap) * progress;

    canvas
      ..save()
      ..translate(cx, cy)
      ..scale(1, tiltY);

    _drawDropShadow(canvas, radius);

    canvas.restore();

    _drawExtrusion(canvas, cx, cy, radius, total, gapRad, availableAngle);

    canvas
      ..save()
      ..translate(cx, cy)
      ..scale(1, tiltY);

    _drawTopFace(canvas, radius, total, gapRad, availableAngle);
    _drawGloss(canvas, radius, total, gapRad, availableAngle);
    _drawInnerRimShadow(canvas, radius);

    canvas.restore();
  }

  void _drawDropShadow(Canvas canvas, double radius) {
    final shadowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..color = Colors.black.withAlpha(80);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, depth * tiltY * 0.5),
        width: radius * 2 + strokeWidth,
        height: (radius * 2 + strokeWidth) * tiltY * 0.4,
      ),
      shadowPaint,
    );
  }

  void _drawExtrusion(
    Canvas canvas,
    double cx,
    double cy,
    double radius,
    double total,
    double gapRad,
    double availableAngle,
  ) {
    canvas
      ..save()
      ..clipRect(Rect.fromLTWH(0, cy, canvas.getLocalClipBounds().width,
          canvas.getLocalClipBounds().height));

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    for (var layer = _extrusionLayers; layer >= 1; layer--) {
      final layerOffset = (layer / _extrusionLayers) * depth * tiltY;
      final dimFactor = 1.0 - (layer / _extrusionLayers) * 0.45;

      canvas
        ..save()
        ..translate(cx, cy + layerOffset)
        ..scale(1, tiltY);

      var startAngle = -math.pi / 2;
      for (final seg in segments) {
        final sweep = (seg.value / total) * availableAngle;
        final extrudeColor = Color.lerp(seg.color, Colors.black, 1.0 - dimFactor)!;
        paint.color = extrudeColor;
        canvas.drawArc(
          Rect.fromCircle(center: Offset.zero, radius: radius),
          startAngle,
          sweep,
          false,
          paint,
        );
        startAngle += sweep + gapRad;
      }

      canvas.restore();
    }

    canvas.restore();
  }

  void _drawTopFace(
    Canvas canvas,
    double radius,
    double total,
    double gapRad,
    double availableAngle,
  ) {
    var startAngle = -math.pi / 2;

    for (final seg in segments) {
      final sweep = (seg.value / total) * availableAngle;
      final arcRect = Rect.fromCircle(center: Offset.zero, radius: radius);

      final gradientRect = Rect.fromCircle(center: Offset.zero, radius: radius + strokeWidth / 2);
      final gradient = ui.Gradient.linear(
        Offset(0, -gradientRect.height / 2),
        Offset(0, gradientRect.height / 2),
        [
          Color.lerp(seg.color, Colors.white, 0.35)!,
          seg.color,
          Color.lerp(seg.color, Colors.black, 0.30)!,
        ],
        [0.0, 0.5, 1.0],
      );

      final paint = Paint()
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..shader = gradient;

      canvas.drawArc(arcRect, startAngle, sweep, false, paint);
      startAngle += sweep + gapRad;
    }
  }

  void _drawGloss(
    Canvas canvas,
    double radius,
    double total,
    double gapRad,
    double availableAngle,
  ) {
    final glossPaint = Paint()
      ..strokeWidth = strokeWidth * 0.55
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..color = Colors.white.withAlpha(35);

    var startAngle = -math.pi / 2;
    for (final seg in segments) {
      final sweep = (seg.value / total) * availableAngle;
      final glossSweep = sweep * 0.65;
      final glossStart = startAngle + (sweep - glossSweep) / 2;
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        glossStart,
        glossSweep,
        false,
        glossPaint,
      );
      startAngle += sweep + gapRad;
    }
  }

  void _drawInnerRimShadow(Canvas canvas, double radius) {
    final innerRadius = radius - strokeWidth / 2;
    final rimPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..color = Colors.black.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(Offset.zero, innerRadius, rimPaint);
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progress != progress ||
      old.segments != segments ||
      old.depth != depth ||
      old.tiltY != tiltY;
}
