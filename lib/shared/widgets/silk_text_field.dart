import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/validators/validators.dart';

class SilkTextField extends StatefulWidget {
  const SilkTextField({
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.autofocus = false,
    this.enabled = true,
    this.maxLength,
    this.label,
    super.key,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Static error message. Takes priority over [validator].
  final String? errorText;

  /// Inline validator — runs on every change when provided. The first
  /// non-null return value is shown as the error message.
  final Validator? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final int? maxLength;

  /// Label shown above the field (footnote, 600). No floating Material label.
  final String? label;

  @override
  State<SilkTextField> createState() => _SilkTextFieldState();
}

class _SilkTextFieldState extends State<SilkTextField> {
  late final FocusNode _focus;
  bool _hasFocus = false;
  String? _validatorError;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focus.hasFocus);
  }

  void _handleChanged(String value) {
    if (widget.validator != null) {
      setState(() => _validatorError = widget.validator!(value));
    }
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final displayError = widget.errorText ?? _validatorError;
    final hasError = displayError != null;

    final borderColor = hasError
        ? tokens.danger
        : _hasFocus
        ? tokens.accentInk
        : tokens.hairlineStrong;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: tokens.labelStyle.copyWith(
              color: tokens.body,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: MotionTokens.fast,
          curve: MotionTokens.standardCurve,
          constraints: const BoxConstraints(minHeight: 48),
          decoration: BoxDecoration(
            color: widget.enabled ? tokens.surface : tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(tokens.radiusMd),
            border: Border.all(color: borderColor),
            // 4pt focus ring in accent @ 18%.
            boxShadow: _hasFocus && !hasError
                ? [
                    BoxShadow(
                      color: tokens.accent.withValues(alpha: 0.18),
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            onChanged: _handleChanged,
            onSubmitted: widget.onSubmitted,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            maxLength: widget.maxLength,
            style: tokens.bodyStyle,
            cursorColor: tokens.accent,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: tokens.bodyStyle.copyWith(color: tokens.subtle),
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: tokens.onSurfaceMuted,
                        size: 20,
                      ),
                      child: widget.prefixIcon!,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: tokens.onSurfaceMuted,
                        size: 20,
                      ),
                      child: widget.suffixIcon!,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: tokens.spaceMd,
                vertical: 12,
              ),
              counterText: '',
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: tokens.spaceXs),
          Text(
            displayError,
            style: tokens.labelStyle.copyWith(color: tokens.danger),
          ),
        ],
      ],
    );
  }
}
