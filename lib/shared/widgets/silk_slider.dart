import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkSlider extends StatelessWidget {
  const SilkSlider({
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.showValue = false,
    this.valueFormatter,
    super.key,
  });

  final double value;
  final void Function(double)? onChanged;
  final double min;
  final double max;
  final int? divisions;

  /// Static label shown above the track.
  final String? label;

  /// Whether to show the current value above the thumb.
  final bool showValue;

  /// Converts the value to a display string. Defaults to one decimal place.
  final String Function(double)? valueFormatter;

  String _display(double v) =>
      valueFormatter != null ? valueFormatter!(v) : v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValue)
          Padding(
            padding: EdgeInsets.only(bottom: tokens.spaceXs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted),
                  ),
                if (showValue)
                  Text(
                    _display(value),
                    style: tokens.bodySmStyle.copyWith(
                      color: tokens.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: tokens.accent,
            inactiveTrackColor: tokens.surfaceMuted,
            thumbColor: tokens.accent,
            overlayColor: tokens.accent.withValues(alpha: 0.12),
            valueIndicatorColor: tokens.accent,
            valueIndicatorTextStyle: tokens.captionStyle.copyWith(color: Colors.white),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            label: showValue ? _display(value) : null,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
