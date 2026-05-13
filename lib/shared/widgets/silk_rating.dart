import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';

/// Star rating widget. Interactive when [onChanged] is provided,
/// read-only otherwise. Supports half-star display for read-only ratings.
///
/// Usage:
/// ```dart
/// // Interactive
/// SilkRating(value: _rating, onChanged: (v) => setState(() => _rating = v))
///
/// // Read-only with half stars
/// SilkRating(value: 3.5)
/// ```
class SilkRating extends StatelessWidget {
  const SilkRating({
    required this.value,
    this.onChanged,
    this.count = 5,
    this.size = 24.0,
    this.color,
    super.key,
  });

  /// 0.0 to [count]. Half-star precision is shown when read-only.
  final double value;

  /// When null the widget is read-only.
  final void Function(double)? onChanged;

  final int count;
  final double size;

  /// Star colour. Defaults to amber-400.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    const starColor = Color(0xFFFACC15);
    final effectiveColor = color ?? starColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final fill = (value - i).clamp(0.0, 1.0);
        return GestureDetector(
          onTap: onChanged != null ? () => onChanged!(i + 1.0) : null,
          child: AnimatedContainer(
            duration: MotionTokens.fast,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _StarIcon(fill: fill, size: size, color: effectiveColor),
          ),
        );
      }),
    );
  }
}

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    required this.fill,
    required this.size,
    required this.color,
  });

  final double fill;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (fill >= 1.0) {
      return Icon(Icons.star_rounded, size: size, color: color);
    }
    if (fill >= 0.5) {
      return Icon(Icons.star_half_rounded, size: size, color: color);
    }
    return Icon(
      Icons.star_outline_rounded,
      size: size,
      color: color.withValues(alpha: 0.35),
    );
  }
}
