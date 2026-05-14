import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkBarEntry {
  const SilkBarEntry({required this.label, required this.value, this.color});

  final String label;
  final double value;

  /// Defaults to [AppTokens.accent].
  final Color? color;
}

/// Animated 3D vertical bar chart. Suitable for monthly returns,
/// transaction volumes, or any discrete-category comparison.
///
/// Usage:
/// ```dart
/// SilkBarChart(
///   entries: [
///     SilkBarEntry(label: 'Jan', value: 4200),
///     SilkBarEntry(label: 'Feb', value: 3800),
///     SilkBarEntry(label: 'Mar', value: 5100),
///   ],
///   height: 160,
/// )
/// ```
class SilkBarChart extends StatefulWidget {
  const SilkBarChart({
    required this.entries,
    this.height = 160,
    this.barRadius = 4,
    this.showValues = false,
    this.depth = 5.0,
    super.key,
  });

  final List<SilkBarEntry> entries;
  final double height;
  final double barRadius;

  /// When true, renders the value above each bar.
  final bool showValues;

  /// Depth of the 3D cuboid effect in pixels. Set to 0 to disable.
  final double depth;

  @override
  State<SilkBarChart> createState() => _SilkBarChartState();
}

class _SilkBarChartState extends State<SilkBarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    final maxVal = widget.entries
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) {
        return SizedBox(
          height: widget.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < widget.entries.length; i++) ...[
                if (i > 0) SizedBox(width: tokens.spaceXs),
                Expanded(
                  child: _Bar(
                    entry: widget.entries[i],
                    maxValue: maxVal,
                    progress: _progress.value,
                    barRadius: widget.barRadius,
                    showValue: widget.showValues,
                    chartHeight: widget.height,
                    depth: widget.depth,
                    defaultColor: tokens.accent,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.entry,
    required this.maxValue,
    required this.progress,
    required this.barRadius,
    required this.showValue,
    required this.chartHeight,
    required this.depth,
    required this.defaultColor,
  });

  final SilkBarEntry entry;
  final double maxValue;
  final double progress;
  final double barRadius;
  final bool showValue;
  final double chartHeight;
  final double depth;
  final Color defaultColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = entry.color ?? defaultColor;
    final fraction = maxValue == 0 ? 0.0 : entry.value / maxValue;
    const labelHeight = 20.0;
    final depthY = depth / 2;
    final barAreaHeight =
        chartHeight - labelHeight - (showValue ? labelHeight : 0);
    final barHeight =
        math.max(0, fraction * (barAreaHeight - depthY) * progress);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showValue) ...[
          Text(
            entry.value.toStringAsFixed(0),
            style: tokens.captionStyle.copyWith(
              color: tokens.onSurfaceMuted,
              fontSize: 10,
            ),
          ),
        ],
        Align(
          alignment: Alignment.bottomCenter,
          child: barHeight > 0
              ? SizedBox(
                  height: barHeight + depthY,
                  child: CustomPaint(
                    painter: _Bar3DPainter(
                      color: color,
                      barRadius: barRadius,
                      depth: depth,
                    ),
                    child: const SizedBox.expand(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        SizedBox(height: tokens.spaceXs),
        Text(
          entry.label,
          style: tokens.captionStyle.copyWith(
            color: tokens.onSurfaceMuted,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Bar3DPainter extends CustomPainter {
  const _Bar3DPainter({
    required this.color,
    required this.barRadius,
    required this.depth,
  });

  final Color color;
  final double barRadius;
  final double depth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final depthX = depth;
    final depthY = depth / 2;

    // Front face – runs from (0, depthY) to (w-depthX, h)
    const double frontLeft = 0;
    final frontTop = depthY;
    final frontRight = w - depthX;
    final frontBottom = h;

    canvas
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          frontLeft,
          frontTop,
          frontRight,
          frontBottom,
          topLeft: Radius.circular(barRadius),
        ),
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(0, frontTop),
            Offset(0, frontBottom),
            [Color.lerp(color, Colors.white, 0.30)!, color],
          ),
      )

      // Top face – parallelogram connecting front-top edge to back-top edge
      ..drawPath(
        Path()
          ..moveTo(frontLeft, frontTop)
          ..lineTo(depthX, 0)
          ..lineTo(w, 0)
          ..lineTo(frontRight, frontTop)
          ..close(),
        Paint()..color = Color.lerp(color, Colors.white, 0.45)!,
      )

      // Right side face – darker quadrilateral
      ..drawPath(
        Path()
          ..moveTo(frontRight, frontTop)
          ..lineTo(w, 0)
          ..lineTo(w, h - depthY)
          ..lineTo(frontRight, frontBottom)
          ..close(),
        Paint()..color = Color.lerp(color, Colors.black, 0.30)!,
      )

      // Gloss highlight along the front-face top edge
      ..drawLine(
        Offset(frontLeft + barRadius, frontTop),
        Offset(frontRight, frontTop),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.35)
          ..strokeWidth = 1,
      );
  }

  @override
  bool shouldRepaint(_Bar3DPainter old) =>
      old.color != color || old.depth != depth || old.barRadius != barRadius;
}
