import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_sparkline.dart';

/// KPI / metric card — a large value, optional delta, and optional sparkline.
///
/// Usage:
/// ```dart
/// SilkStatCard(
///   label: 'Total portfolio',
///   value: r'$12,480',
///   delta: 8.4,
///   deltaLabel: 'vs last month',
///   sparklineData: [9800, 10200, 11000, 12480],
/// )
/// ```
class SilkStatCard extends StatelessWidget {
  const SilkStatCard({
    required this.label,
    required this.value,
    this.delta,
    this.deltaLabel,
    this.icon,
    this.sparklineData,
    this.onTap,
    super.key,
  });

  final String label;
  final String value;

  /// Positive = green upward delta; negative = red downward delta.
  final double? delta;
  final String? deltaLabel;
  final IconData? icon;

  /// When provided, draws a small sparkline in the trailing corner.
  final List<double>? sparklineData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final isPositive = (delta ?? 0) >= 0;
    final deltaColor = isPositive ? tokens.success : tokens.danger;
    final deltaIcon =
        isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(tokens.spaceLg),
        decoration: BoxDecoration(
          color: tokens.surfaceMuted,
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          border: Border.all(color: tokens.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: tokens.onSurfaceMuted),
                  SizedBox(width: tokens.spaceXs),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: tokens.captionStyle
                        .copyWith(color: tokens.onSurfaceMuted),
                  ),
                ),
                if (sparklineData != null)
                  SilkSparkline(
                    data: sparklineData!,
                    width: 64,
                    height: 32,
                    color: delta == null || delta! >= 0
                        ? tokens.success
                        : tokens.danger,
                  ),
              ],
            ),
            SizedBox(height: tokens.spaceXs),
            Text(value, style: tokens.displayStyle),
            if (delta != null) ...[
              SizedBox(height: tokens.spaceXs),
              Row(
                children: [
                  Icon(deltaIcon, size: 13, color: deltaColor),
                  const SizedBox(width: 2),
                  Text(
                    '${delta!.abs().toStringAsFixed(1)}%',
                    style: tokens.captionStyle.copyWith(
                      color: deltaColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (deltaLabel != null) ...[
                    SizedBox(width: tokens.spaceXs),
                    Text(
                      deltaLabel!,
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
