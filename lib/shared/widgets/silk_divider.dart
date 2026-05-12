import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkDivider extends StatelessWidget {
  const SilkDivider({this.label, this.indent = 0, super.key});

  final String? label;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final lbl = label;
    if (lbl == null) {
      return Divider(
        height: 1,
        thickness: 1,
        indent: indent,
        endIndent: indent,
        color: tokens.divider,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Divider(height: 1, thickness: 1, indent: indent, color: tokens.divider),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: tokens.spaceMd),
          child: Text(lbl, style: tokens.captionStyle),
        ),
        Expanded(
          child: Divider(height: 1, thickness: 1, endIndent: indent, color: tokens.divider),
        ),
      ],
    );
  }
}
