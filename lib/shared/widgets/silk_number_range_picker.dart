import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Dual-handle range slider for selecting a min–max value.
///
/// Usage:
/// ```dart
/// SilkNumberRangePicker(
///   min: 0,
///   max: 10000,
///   start: _min,
///   end: _max,
///   label: 'Investment range',
///   valueFormatter: (v) => '₵${v.toStringAsFixed(0)}',
///   onChanged: (start, end) => setState(() { _min = start; _max = end; }),
/// )
/// ```
class SilkNumberRangePicker extends StatelessWidget {
  const SilkNumberRangePicker({
    required this.min,
    required this.max,
    required this.start,
    required this.end,
    required this.onChanged,
    this.label,
    this.divisions,
    this.valueFormatter,
    super.key,
  });

  final double min;
  final double max;
  final double start;
  final double end;
  final void Function(double start, double end) onChanged;
  final String? label;
  final int? divisions;
  final String Function(double)? valueFormatter;

  String _fmt(double v) =>
      valueFormatter != null ? valueFormatter!(v) : v.toStringAsFixed(0);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
          ),
          SizedBox(height: tokens.spaceXs),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fmt(start),
              style: tokens.bodySmStyle.copyWith(
                color: tokens.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _fmt(end),
              style: tokens.bodySmStyle.copyWith(
                color: tokens.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: tokens.accent,
            inactiveTrackColor: tokens.surfaceMuted,
            thumbColor: tokens.accent,
            overlayColor: tokens.accent.withValues(alpha: 0.12),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
            ),
            trackHeight: 4,
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
          ),
          child: RangeSlider(
            min: min,
            max: max,
            values: RangeValues(start, end),
            divisions: divisions,
            onChanged: (v) => onChanged(v.start, v.end),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fmt(min),
              style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
            ),
            Text(
              _fmt(max),
              style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
            ),
          ],
        ),
      ],
    );
  }
}
