import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A text field with an animated floating label that rises above the border
/// when the field is focused or contains text.
class SilkFloatingLabelInput extends StatefulWidget {
  const SilkFloatingLabelInput({
    required this.label,
    this.controller,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.onChanged,
    this.prefix,
    this.suffix,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;

  @override
  State<SilkFloatingLabelInput> createState() => _SilkFloatingLabelInputState();
}

class _SilkFloatingLabelInputState extends State<SilkFloatingLabelInput> {
  late final FocusNode _focus;
  late final TextEditingController _effectiveController;
  bool _ownsController = false;
  bool _hasFocus = false;
  bool _hasText = false;

  bool get _isFloated => _hasFocus || _hasText;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(_onFocusChange);
    if (widget.controller == null) {
      _effectiveController = TextEditingController();
      _ownsController = true;
    } else {
      _effectiveController = widget.controller!;
    }
    _effectiveController.addListener(_onTextChange);
    _hasText = _effectiveController.text.isNotEmpty;
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focus.hasFocus);
  }

  void _onTextChange() {
    final hasText = _effectiveController.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocusChange)
      ..dispose();
    _effectiveController.removeListener(_onTextChange);
    if (_ownsController) _effectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasError = widget.errorText != null;

    final borderColor = hasError
        ? tokens.danger
        : _hasFocus
            ? tokens.accent
            : tokens.divider;

    final borderWidth = _hasFocus ? 2.0 : 1.0;

    const fieldHeight = 56.0;
    const floatedTop = -9.0;
    const inlineTop = (fieldHeight - 22.0) / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: fieldHeight + 10,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: fieldHeight,
                  decoration: BoxDecoration(
                    color: tokens.surfaceMuted,
                    borderRadius: BorderRadius.circular(tokens.radiusMd),
                    border: Border.all(color: borderColor, width: borderWidth),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefix != null)
                        Padding(
                          padding: EdgeInsets.only(left: tokens.spaceMd),
                          child: IconTheme(
                            data: IconThemeData(
                              color: tokens.onSurfaceMuted,
                              size: 20,
                            ),
                            child: widget.prefix!,
                          ),
                        ),
                      Expanded(
                        child: TextField(
                          controller: _effectiveController,
                          focusNode: _focus,
                          keyboardType: widget.keyboardType,
                          obscureText: widget.obscureText,
                          readOnly: widget.readOnly,
                          onChanged: widget.onChanged,
                          style: tokens.bodyStyle.copyWith(
                            color: tokens.onSurface,
                          ),
                          cursorColor: tokens.accent,
                          decoration: InputDecoration(
                            hintText: _hasFocus ? widget.hint : null,
                            hintStyle: tokens.bodyStyle.copyWith(
                              color: tokens.onSurfaceMuted,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(
                              widget.prefix != null
                                  ? tokens.spaceSm
                                  : tokens.spaceMd,
                              _isFloated ? tokens.spaceLg : tokens.spaceMd,
                              tokens.spaceMd,
                              tokens.spaceSm,
                            ),
                          ),
                        ),
                      ),
                      if (widget.suffix != null)
                        Padding(
                          padding: EdgeInsets.only(right: tokens.spaceMd),
                          child: IconTheme(
                            data: IconThemeData(
                              color: tokens.onSurfaceMuted,
                              size: 20,
                            ),
                            child: widget.suffix!,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                top: _isFloated ? floatedTop : inlineTop + 10,
                left: widget.prefix != null
                    ? tokens.spaceMd + 28
                    : tokens.spaceMd,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: _isFloated
                      ? tokens.captionStyle.copyWith(
                          color: hasError ? tokens.danger : tokens.accent,
                          fontWeight: FontWeight.w500,
                        )
                      : tokens.bodyStyle.copyWith(
                          color: tokens.onSurfaceMuted,
                        ),
                  child: Container(
                    color: _isFloated ? tokens.surfaceMuted : Colors.transparent,
                    padding: _isFloated
                        ? const EdgeInsets.symmetric(horizontal: 4)
                        : EdgeInsets.zero,
                    child: Text(widget.label),
                  ),
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
