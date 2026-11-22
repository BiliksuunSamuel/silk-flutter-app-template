import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkSearchBar extends StatefulWidget {
  const SilkSearchBar({
    this.placeholder = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.autofocus = false,
    super.key,
  });

  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final bool autofocus;

  @override
  State<SilkSearchBar> createState() => _SilkSearchBarState();
}

class _SilkSearchBarState extends State<SilkSearchBar> {
  late final TextEditingController _ctrl;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _ctrl.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onTextChange);
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  void _onTextChange() {
    final has = _ctrl.text.isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  void _clear() {
    _ctrl.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    // Inset 36pt field, radius 10, sunken fill.
    final radius = BorderRadius.circular(10);
    final noBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide.none,
    );

    return TextField(
      controller: _ctrl,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      style: tokens.bodySmStyle.copyWith(color: tokens.onSurface),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted),
        isDense: true,
        filled: true,
        fillColor: tokens.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        prefixIcon: Icon(Icons.search, color: tokens.onSurfaceMuted, size: 18),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 38,
          minHeight: 38,
        ),
        suffixIcon: _hasText
            ? GestureDetector(
                onTap: _clear,
                child: Icon(
                  Icons.cancel,
                  color: tokens.onSurfaceMuted,
                  size: 16,
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 34,
          minHeight: 34,
        ),
        border: noBorder,
        enabledBorder: noBorder,
        focusedBorder: noBorder,
      ),
    );
  }
}
