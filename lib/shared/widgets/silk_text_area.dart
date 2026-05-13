import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Multi-line text input. Pairs with [SilkTextField] for single-line inputs.
///
/// Usage:
/// ```dart
/// SilkTextArea(
///   label: 'Description',
///   hint: 'Tell us more…',
///   controller: _ctrl,
///   maxLength: 500,
/// )
/// ```
class SilkTextArea extends StatelessWidget {
  const SilkTextArea({
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.minLines = 3,
    this.maxLines = 6,
    this.maxLength,
    this.onChanged,
    this.readOnly = false,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

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
        TextField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          onChanged: onChanged,
          style: tokens.bodyStyle,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
            errorText: errorText,
            errorStyle: tokens.captionStyle.copyWith(color: tokens.danger),
            filled: true,
            fillColor: tokens.surfaceMuted,
            counterStyle:
                tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
            contentPadding: EdgeInsets.all(tokens.spaceMd),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              borderSide: BorderSide(color: tokens.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              borderSide: BorderSide(color: tokens.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              borderSide: BorderSide(color: tokens.accent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              borderSide: BorderSide(color: tokens.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              borderSide: BorderSide(color: tokens.danger, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
