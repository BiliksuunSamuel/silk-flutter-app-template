import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkAmountField extends StatefulWidget {
  const SilkAmountField({
    this.label,
    this.hint,
    this.currency = r'$',
    this.decimalPlaces = 2,
    this.initialValue,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  final String? label;
  final String? hint;

  /// Currency symbol shown as a prefix (e.g. '\$', '₦', 'GHS').
  final String currency;

  /// How many decimal places to allow. 0 = integers only.
  final int decimalPlaces;

  final double? initialValue;
  final void Function(double? value)? onChanged;
  final String? errorText;
  final bool enabled;

  @override
  State<SilkAmountField> createState() => _SilkAmountFieldState();
}

class _SilkAmountFieldState extends State<SilkAmountField> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initialValue;
    _controller = TextEditingController(
      text: init != null ? _format(init.toString()) : '',
    );
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _focused = _focusNode.hasFocus);
    if (!_focusNode.hasFocus) {
      // Reformat on blur
      final raw = _controller.text.replaceAll(',', '');
      final parsed = double.tryParse(raw);
      if (parsed != null) {
        _controller.text = _format(raw);
      }
    }
  }

  // Insert comma thousands separators, preserve decimal.
  String _format(String raw) {
    final clean = raw.replaceAll(',', '');
    final parts = clean.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : null;

    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    if (decPart != null) {
      buffer
        ..write('.')
        ..write(decPart);
    }
    return buffer.toString();
  }

  void _onChanged(String value) {
    final raw = value.replaceAll(',', '');
    final parsed = double.tryParse(raw);
    widget.onChanged?.call(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasError = widget.errorText != null;

    final borderColor = hasError
        ? tokens.danger
        : _focused
            ? tokens.accent
            : tokens.divider;

    final label = widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: tokens.bodySmStyle.copyWith(
              color: tokens.onSurfaceMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: tokens.spaceXs),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.enabled ? tokens.surfaceMuted : tokens.surfaceMuted.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(tokens.radiusMd),
            border: Border.all(color: borderColor, width: _focused ? 2 : 1.5),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceMd),
                child: Text(
                  widget.currency,
                  style: tokens.titleSmStyle.copyWith(color: tokens.onSurfaceMuted),
                ),
              ),
              Container(width: 1, height: 24, color: tokens.divider),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: widget.decimalPlaces > 0,
                  ),
                  inputFormatters: [
                    _AmountFormatter(decimalPlaces: widget.decimalPlaces),
                  ],
                  style: tokens.titleSmStyle.copyWith(color: tokens.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint ?? (widget.decimalPlaces > 0 ? '0.00' : '0'),
                    hintStyle: tokens.titleSmStyle.copyWith(
                      color: tokens.onSurfaceMuted.withValues(alpha: 0.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: tokens.spaceMd,
                      vertical: tokens.spaceMd,
                    ),
                    isDense: true,
                  ),
                  onChanged: _onChanged,
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          SizedBox(height: tokens.spaceXs),
          Text(
            widget.errorText!,
            style: tokens.captionStyle.copyWith(color: tokens.danger),
          ),
        ],
      ],
    );
  }
}

class _AmountFormatter extends TextInputFormatter {
  const _AmountFormatter({required this.decimalPlaces});

  final int decimalPlaces;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text;

    // Allow empty
    if (raw.isEmpty) return newValue;

    // Strip everything but digits and decimal point
    final cleaned = raw.replaceAll(RegExp(r'[^\d.]'), '');

    // At most one decimal point
    final dotCount = cleaned.split('').where((c) => c == '.').length;
    if (dotCount > 1) return oldValue;

    // Enforce decimal places
    if (decimalPlaces == 0 && cleaned.contains('.')) return oldValue;
    final parts = cleaned.split('.');
    if (parts.length > 1 && parts[1].length > decimalPlaces) return oldValue;

    // Format integer part with commas
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }

    final formatted = '$buffer$decPart';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
