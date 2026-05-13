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

/// Animated vertical bar chart. Suitable for monthly returns,
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
    super.key,
  });

  final List<SilkBarEntry> entries;
  final double height;
  final double barRadius;

  /// When true, renders the value above each bar.
  final bool showValues;

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
    required this.defaultColor,
  });

  final SilkBarEntry entry;
  final double maxValue;
  final double progress;
  final double barRadius;
  final bool showValue;
  final double chartHeight;
  final Color defaultColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = entry.color ?? defaultColor;
    final fraction = maxValue == 0 ? 0.0 : entry.value / maxValue;
    const labelHeight = 20.0;
    final barAreaHeight =
        chartHeight - labelHeight - (showValue ? labelHeight : 0);
    final barHeight = fraction * barAreaHeight * progress;

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
          child: Container(
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(barRadius),
              ),
            ),
          ),
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
