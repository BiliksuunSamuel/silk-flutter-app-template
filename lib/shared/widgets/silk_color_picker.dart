import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A grid of colour swatches. Tapping a swatch calls [onChanged].
///
/// Usage:
/// ```dart
/// SilkColorPicker(
///   colors: [Colors.red, Colors.blue, Colors.green],
///   selected: _color,
///   onChanged: (c) => setState(() => _color = c),
/// )
/// ```
class SilkColorPicker extends StatelessWidget {
  const SilkColorPicker({
    required this.colors,
    required this.onChanged,
    this.selected,
    this.swatchSize = 36.0,
    this.spacing = 8.0,
    this.label,
    super.key,
  });

  final List<Color> colors;
  final Color? selected;
  final void Function(Color) onChanged;
  final double swatchSize;
  final double spacing;
  final String? label;

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
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: colors.map((color) {
            final isSelected = color.toARGB32() == selected?.toARGB32();
            return GestureDetector(
              onTap: () => onChanged(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: swatchSize,
                height: swatchSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? tokens.onSurface
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.45),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: swatchSize * 0.45,
                        color: _contrastColor(color),
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _contrastColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.4 ? Colors.black : Colors.white;
  }
}
