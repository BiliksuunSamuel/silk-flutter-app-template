import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkReceiptLine {
  const SilkReceiptLine({
    required this.label,
    required this.value,
    this.muted = false,
    this.isTotal = false,
  });

  final String label;
  final String value;

  /// Renders label in muted colour — for secondary rows like fees.
  final bool muted;

  /// Renders both label and value bold — use for the final total row.
  final bool isTotal;
}

/// A styled receipt / summary card with label–value rows and an optional total.
///
/// Usage:
/// ```dart
/// SilkReceiptCard(
///   title: 'Payment summary',
///   lines: [
///     SilkReceiptLine(label: 'Amount', value: r'$500.00'),
///     SilkReceiptLine(label: 'Fee', value: r'$1.25', muted: true),
///     SilkReceiptLine(label: 'Total', value: r'$501.25', isTotal: true),
///   ],
/// )
/// ```
class SilkReceiptCard extends StatelessWidget {
  const SilkReceiptCard({
    required this.lines,
    this.title,
    this.icon,
    super.key,
  });

  final List<SilkReceiptLine> lines;
  final String? title;

  /// Optional leading icon shown above the title.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final regularLines = lines.where((l) => !l.isTotal).toList();
    final totalLine = lines.where((l) => l.isTotal).firstOrNull;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(tokens.radiusLg),
        border: Border.all(color: tokens.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || icon != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                tokens.spaceLg,
                tokens.spaceLg,
                tokens.spaceLg,
                tokens.spaceMd,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: tokens.accent),
                    SizedBox(width: tokens.spaceSm),
                  ],
                  if (title != null)
                    Text(
                      title!,
                      style: tokens.bodyStyle
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
            child: Column(
              children: [
                for (var i = 0; i < regularLines.length; i++) ...[
                  _ReceiptRow(line: regularLines[i]),
                  if (i < regularLines.length - 1)
                    SizedBox(height: tokens.spaceSm),
                ],
              ],
            ),
          ),
          if (totalLine != null) ...[
            SizedBox(height: tokens.spaceMd),
            Divider(color: tokens.divider, height: 1),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tokens.spaceLg,
                vertical: tokens.spaceMd,
              ),
              child: _ReceiptRow(line: totalLine),
            ),
          ] else
            SizedBox(height: tokens.spaceLg),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.line});

  final SilkReceiptLine line;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final labelColor =
        line.muted ? tokens.onSurfaceMuted : tokens.onSurface;
    final style = line.isTotal
        ? tokens.bodyStyle.copyWith(fontWeight: FontWeight.w700)
        : tokens.bodySmStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(line.label, style: style.copyWith(color: labelColor)),
        Text(
          line.value,
          style: style.copyWith(
            color: line.isTotal ? tokens.onSurface : labelColor,
          ),
        ),
      ],
    );
  }
}
