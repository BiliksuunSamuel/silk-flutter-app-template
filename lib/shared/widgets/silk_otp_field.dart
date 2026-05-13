import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkOTPField extends StatefulWidget {
  const SilkOTPField({
    required this.onCompleted,
    this.length = 6,
    this.obscure = false,
    this.onChanged,
    this.errorText,
    super.key,
  }) : assert(length >= 4 && length <= 8, 'length must be between 4 and 8');

  final int length;

  /// Called when all boxes are filled.
  final void Function(String otp) onCompleted;

  /// Called on every keystroke with the current partial value.
  final void Function(String value)? onChanged;

  /// Hides input — useful for PIN entry.
  final bool obscure;

  /// Inline error message shown below the boxes.
  final String? errorText;

  @override
  State<SilkOTPField> createState() => _SilkOTPFieldState();
}

class _SilkOTPFieldState extends State<SilkOTPField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste: distribute across boxes.
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < widget.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      final filled = digits.length >= widget.length;
      if (filled) {
        _nodes[widget.length - 1].requestFocus();
        widget.onCompleted(digits.substring(0, widget.length));
      } else {
        _nodes[digits.length.clamp(0, widget.length - 1)].requestFocus();
      }
      widget.onChanged?.call(_currentValue());
      return;
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }

    widget.onChanged?.call(_currentValue());

    final current = _currentValue();
    if (current.length == widget.length) {
      widget.onCompleted(current);
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey != LogicalKeyboardKey.backspace) return;
    if (_controllers[index].text.isNotEmpty) return;
    if (index > 0) {
      _controllers[index - 1].clear();
      _nodes[index - 1].requestFocus();
      widget.onChanged?.call(_currentValue());
    }
  }

  String _currentValue() =>
      _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasError = widget.errorText != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.length; i++) ...[
              _OTPBox(
                controller: _controllers[i],
                focusNode: _nodes[i],
                obscure: widget.obscure,
                hasError: hasError,
                onChanged: (v) => _onChanged(i, v),
                onKeyEvent: (e) => _onKeyEvent(i, e),
              ),
              if (i < widget.length - 1)
                SizedBox(width: tokens.spaceSm),
            ],
          ],
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

class _OTPBox extends StatefulWidget {
  const _OTPBox({
    required this.controller,
    required this.focusNode,
    required this.obscure,
    required this.hasError,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscure;
  final bool hasError;
  final void Function(String) onChanged;
  final void Function(KeyEvent) onKeyEvent;

  @override
  State<_OTPBox> createState() => _OTPBoxState();
}

class _OTPBoxState extends State<_OTPBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final filled = widget.controller.text.isNotEmpty;

    final borderColor = widget.hasError
        ? tokens.danger
        : _focused
            ? tokens.accent
            : filled
                ? tokens.accent.withValues(alpha: 0.5)
                : tokens.divider;

    return AnimatedContainer(
      duration: MotionTokens.fast,
      curve: MotionTokens.standardCurve,
      width: 44,
      height: 52,
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
        border: Border.all(color: borderColor, width: _focused ? 2 : 1.5),
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: widget.onKeyEvent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              // In obscure mode the text is invisible — we draw our own dot.
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              style: tokens.titleStyle.copyWith(
                color: widget.obscure ? Colors.transparent : tokens.onSurface,
              ),
              cursorColor: widget.obscure ? Colors.transparent : tokens.accent,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              onChanged: widget.onChanged,
            ),
            // Centered dot rendered outside TextField so it's truly centered.
            if (widget.obscure && filled)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tokens.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
