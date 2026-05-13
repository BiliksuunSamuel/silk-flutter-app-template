import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A single day's data point for [SilkHeatmap].
@immutable
class SilkHeatmapDay {
  const SilkHeatmapDay({required this.date, required this.value});

  final DateTime date;
  final double value;
}

/// A GitHub-style contribution heatmap rendered as a grid of colored cells.
class SilkHeatmap extends StatelessWidget {
  const SilkHeatmap({
    required this.data,
    this.maxValue,
    this.weeks = 18,
    this.cellSize = 12.0,
    this.cellGap = 3.0,
    this.emptyColor,
    this.fillColor,
    this.showMonthLabels = true,
    this.showDayLabels = true,
    super.key,
  });

  final List<SilkHeatmapDay> data;
  final double? maxValue;
  final int weeks;
  final double cellSize;
  final double cellGap;
  final Color? emptyColor;
  final Color? fillColor;
  final bool showMonthLabels;
  final bool showDayLabels;

  static const List<String> _dayLabels = [
    'Mon',
    '',
    'Wed',
    '',
    'Fri',
    '',
    '',
  ];

  static const List<String> _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Maps [data] into a lookup keyed by normalized date (no time component).
  Map<DateTime, double> _buildLookup() {
    return {
      for (final d in data)
        DateTime(d.date.year, d.date.month, d.date.day): d.value,
    };
  }

  /// Returns the Monday that starts the week containing [date].
  DateTime _weekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final empty = emptyColor ?? tokens.divider;
    final fill = fillColor ?? tokens.accent;

    final effective = maxValue ??
        (data.isEmpty
            ? 1.0
            : data.map((d) => d.value).reduce((a, b) => a > b ? a : b));

    final lookup = _buildLookup();

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    final currentWeekStart = _weekStart(todayNorm);
    final gridStart = currentWeekStart.subtract(Duration(days: (weeks - 1) * 7));

    final columns = List.generate(weeks, (w) {
      final weekStart = gridStart.add(Duration(days: w * 7));
      return List.generate(7, (d) => weekStart.add(Duration(days: d)));
    });

    final monthLabels = <String>[];
    if (showMonthLabels) {
      int? lastLabelMonth;
      for (final col in columns) {
        final firstDay = col.first;
        if (lastLabelMonth != firstDay.month) {
          monthLabels.add(_monthNames[firstDay.month - 1]);
          lastLabelMonth = firstDay.month;
        } else {
          monthLabels.add('');
        }
      }
    }

    final dayLabelWidth = showDayLabels ? 28.0 : 0.0;
    final monthLabelHeight = showMonthLabels ? 16.0 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMonthLabels)
          Padding(
            padding: EdgeInsets.only(left: dayLabelWidth),
            child: Row(
              children: [
                for (var w = 0; w < weeks; w++) ...[
                  SizedBox(
                    width: cellSize,
                    height: monthLabelHeight,
                    child: monthLabels.isNotEmpty && monthLabels[w].isNotEmpty
                        ? Text(
                            monthLabels[w],
                            style: TextStyle(
                              fontSize: 9,
                              color: tokens.onSurfaceMuted,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: false,
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (w < weeks - 1) SizedBox(width: cellGap),
                ],
              ],
            ),
          ),
        for (var dayIndex = 0; dayIndex < 7; dayIndex++) ...[
          Row(
            children: [
              if (showDayLabels)
                SizedBox(
                  width: dayLabelWidth,
                  height: cellSize,
                  child: _dayLabels[dayIndex].isNotEmpty
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _dayLabels[dayIndex],
                            style: TextStyle(
                              fontSize: 9,
                              color: tokens.onSurfaceMuted,
                            ),
                          ),
                        )
                      : null,
                ),
              for (var w = 0; w < weeks; w++) ...[
                _HeatmapCell(
                  value: lookup[columns[w][dayIndex]],
                  maxValue: effective,
                  emptyColor: empty,
                  fillColor: fill,
                  cellSize: cellSize,
                  radius: tokens.radiusSm / 2,
                ),
                if (w < weeks - 1) SizedBox(width: cellGap),
              ],
            ],
          ),
          if (dayIndex < 6) SizedBox(height: cellGap),
        ],
      ],
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({
    required this.value,
    required this.maxValue,
    required this.emptyColor,
    required this.fillColor,
    required this.cellSize,
    required this.radius,
  });

  final double? value;
  final double maxValue;
  final Color emptyColor;
  final Color fillColor;
  final double cellSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final fraction =
        value == null ? 0.0 : (value! / maxValue).clamp(0.0, 1.0);
    final color = Color.lerp(emptyColor, fillColor, fraction)!;

    return Container(
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
