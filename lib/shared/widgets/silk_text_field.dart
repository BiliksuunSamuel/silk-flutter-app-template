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
            ? tokens.accent
            : tokens.divider;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: MotionTokens.fast,
          curve: MotionTokens.standardCurve,
          decoration: BoxDecoration(
            color: widget.enabled ? tokens.surfaceMuted : tokens.divider,
            borderRadius: BorderRadius.circular(tokens.radiusMd),
            border: Border.all(
              color: borderColor,
              width: _hasFocus ? 1.5 : 1.0,
            ),
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
              hintStyle: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
              prefixIcon: widget.prefixIcon != null
                  ? IconTheme(
                      data: IconThemeData(color: tokens.onSurfaceMuted, size: 20),
                      child: widget.prefixIcon!,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? IconTheme(
                      data: IconThemeData(color: tokens.onSurfaceMuted, size: 20),
                      child: widget.suffixIcon!,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: tokens.spaceMd,
                vertical: tokens.spaceMd,
              ),
              counterText: '',
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: tokens.spaceXs),
          Text(
            displayError,
            style: tokens.captionStyle.copyWith(color: tokens.danger),
          ),
        ],
      ],
    );
  }
}
