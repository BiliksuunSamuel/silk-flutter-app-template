import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

@immutable
class SilkPieSegment {
  const SilkPieSegment({
    required this.value,
    required this.color,
    this.label,
  });

  final double value;
  final Color color;
  final String? label;
}

class SilkPieChart extends StatefulWidget {
  const SilkPieChart({
    required this.segments,
    this.size = 200,
    this.depth = 14.0,
    this.tiltY = 0.60,
    this.selectedIndex,
    this.onSegmentTap,
    super.key,
  });

  final List<SilkPieSegment> segments;
  final double size;
  final double depth;
  final double tiltY;
  final int? selectedIndex;
  final void Function(int)? onSegmentTap;

  @override
  State<SilkPieChart> createState() => _SilkPieChartState();
}

class _SilkPieChartState extends State<SilkPieChart>
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

  int? _hitTest(Offset localPos) {
    final total =
        widget.segments.fold<double>(0, (s, seg) => s + seg.value);
    if (total == 0) return null;

    final w = widget.size;
    final h = widget.size * 0.85;
    final cx = w / 2;
    final cy = h / 2 - (widget.depth * widget.tiltY / 2);
    final radius = widget.size / 2;

    final dx = localPos.dx - cx;
    final dy = (localPos.dy - cy) / widget.tiltY;

    if (math.sqrt(dx * dx + dy * dy) > radius) return null;

    var angle = math.atan2(dy, dx);
    if (angle < -math.pi / 2) angle += 2 * math.pi;

    var startAngle = -math.pi / 2;
    for (var i = 0; i < widget.segments.length; i++) {
      final sweep =
          (widget.segments[i].value / total) * 2 * math.pi * _progress.value;
      final end = startAngle + sweep;
      var normalized = angle;
      if (normalized < startAngle) normalized += 2 * math.pi;
      if (normalized >= startAngle && normalized < end) return i;
      startAngle = end;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.size;
    final h = widget.size * 0.85;

    return GestureDetector(
      onTapUp: (details) {
        if (widget.onSegmentTap == null) return;
        final idx = _hitTest(details.localPosition);
        if (idx != null) widget.onSegmentTap!(idx);
      },
      child: SizedBox(
        width: w,
        height: h,
        child: AnimatedBuilder(
          animation: _progress,
          builder: (_, __) => CustomPaint(
            painter: _PiePainter(
              segments: widget.segments,
              progress: _progress.value,
              depth: widget.depth,
              tiltY: widget.tiltY,
              selectedIndex: widget.selectedIndex,
            ),
          ),
        ),
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter({
    required this.segments,
    required this.progress,
    required this.depth,
    required this.tiltY,
    required this.selectedIndex,
  });

  final List<SilkPieSegment> segments;
  final double progress;
  final double depth;
  final double tiltY;
  final int? selectedIndex;

  static const int _extrusionLayers = 8;
  static const double _explodeDist = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 - (depth * tiltY / 2);
    final radius = size.width / 2;

    final total = segments.fold<double>(0, (s, seg) => s + seg.value);
    if (total == 0) return;

    canvas
      ..save()
      ..translate(cx, cy)
      ..scale(1, tiltY);
    _drawDropShadow(canvas, radius);
    canvas.restore();

    _drawAllExtrusions(canvas, cx, cy, radius, total);
    _drawAllTopFaces(canvas, cx, cy, radius, total);

    canvas
      ..save()
      ..translate(cx, cy)
      ..scale(1, tiltY);
    _drawGloss(canvas, radius, total);
    canvas.restore();
  }

  Offset _explodeOffset(int index) {
    final total = segments.fold<double>(0, (s, seg) => s + seg.value);
    if (total == 0 || index != selectedIndex) return Offset.zero;

    var startAngle = -math.pi / 2;
    for (var i = 0; i < segments.length; i++) {
      final sweep = (segments[i].value / total) * 2 * math.pi * progress;
      if (i == index) {
        final midAngle = startAngle + sweep / 2;
        return Offset(
          _explodeDist * math.cos(midAngle),
          _explodeDist * math.sin(midAngle),
        );
      }
      startAngle += sweep;
    }
    return Offset.zero;
  }

  void _drawDropShadow(Canvas canvas, double radius) {
    final shadowPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
      ..color = Colors.black.withAlpha(90);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, depth * tiltY * 0.5),
        width: radius * 2,
        height: radius * 2 * tiltY * 0.4,
      ),
      shadowPaint,
    );
  }

  void _drawAllExtrusions(
    Canvas canvas,
    double cx,
    double cy,
    double radius,
    double total,
  ) {
    canvas.save();
    final clipBounds = canvas.getLocalClipBounds();
    canvas.clipRect(Rect.fromLTWH(
      clipBounds.left,
      cy,
      clipBounds.width,
      clipBounds.height,
    ));

    final paint = Paint()..style = PaintingStyle.fill;

    for (var layer = _extrusionLayers; layer >= 1; layer--) {
      final layerOffset = (layer / _extrusionLayers) * depth * tiltY;
      final dimFactor = 1.0 - (layer / _extrusionLayers) * 0.45;

      var startAngle = -math.pi / 2;
      for (var i = 0; i < segments.length; i++) {
        final seg = segments[i];
        final sweep = (seg.value / total) * 2 * math.pi * progress;
        final explode = _explodeOffset(i);

        canvas
          ..save()
          ..translate(
            cx + explode.dx,
            cy + explode.dy * tiltY + layerOffset,
          )
          ..scale(1, tiltY);

        final extrudeColor =
            Color.lerp(seg.color, Colors.black, 1.0 - dimFactor)!;
        paint.color = extrudeColor;

        final path = Path()
          ..moveTo(0, 0)
          ..arcTo(
            Rect.fromCircle(center: Offset.zero, radius: radius),
            startAngle,
            sweep,
            false,
          )
          ..close();

        canvas
          ..drawPath(path, paint)
          ..restore();

        startAngle += sweep;
      }
    }

    canvas.restore();
  }

  void _drawAllTopFaces(
    Canvas canvas,
    double cx,
    double cy,
    double radius,
    double total,
  ) {
    var startAngle = -math.pi / 2;
    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final sweep = (seg.value / total) * 2 * math.pi * progress;
      final explode = _explodeOffset(i);

      canvas
        ..save()
        ..translate(
          cx + explode.dx,
          cy + explode.dy * tiltY,
        )
        ..scale(1, tiltY);

      final gradientRect =
          Rect.fromCircle(center: Offset.zero, radius: radius);
      final gradient = ui.Gradient.linear(
        Offset(0, -gradientRect.height / 2),
        Offset(0, gradientRect.height / 2),
        [
          Color.lerp(seg.color, Colors.white, 0.35)!,
          seg.color,
          Color.lerp(seg.color, Colors.black, 0.30)!,
        ],
        [0, 0.5, 1],
      );

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..shader = gradient;

      final path = Path()
        ..moveTo(0, 0)
        ..arcTo(
          Rect.fromCircle(center: Offset.zero, radius: radius),
          startAngle,
          sweep,
          false,
        )
        ..close();

      canvas
        ..drawPath(path, paint)
        ..restore();

      startAngle += sweep;
    }
  }

  void _drawGloss(Canvas canvas, double radius, double total) {
    final glossPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withAlpha(35);

    var startAngle = -math.pi / 2;
    for (var i = 0; i < segments.length; i++) {
      final sweep = (segments[i].value / total) * 2 * math.pi * progress;
      final glossSweep = sweep * 0.65;
      final glossStart = startAngle + (sweep - glossSweep) / 2;
      final explode = _explodeOffset(i);

      canvas
        ..save()
        ..translate(explode.dx, explode.dy / tiltY);

      final path = Path()
        ..moveTo(0, 0)
        ..arcTo(
          Rect.fromCircle(center: Offset.zero, radius: radius * 0.6),
          glossStart,
          glossSweep,
          false,
        )
        ..close();

      canvas
        ..drawPath(path, glossPaint)
        ..restore();

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_PiePainter old) =>
      old.progress != progress ||
      old.segments != segments ||
      old.depth != depth ||
      old.tiltY != tiltY ||
      old.selectedIndex != selectedIndex;
}
