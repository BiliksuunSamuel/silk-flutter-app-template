import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silk/core/extensions/dimension_extensions.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkCountry {
  const SilkCountry({
    required this.name,
    required this.dialCode,
    required this.flag,
    required this.code,
  });

  final String name;
  final String dialCode;
  final String flag;
  final String code;
}

// Common countries — extend as needed.
const _kCountries = [
  SilkCountry(name: 'Ghana',          dialCode: '+233', flag: '🇬🇭', code: 'GH'),
  SilkCountry(name: 'Nigeria',        dialCode: '+234', flag: '🇳🇬', code: 'NG'),
  SilkCountry(name: 'Kenya',          dialCode: '+254', flag: '🇰🇪', code: 'KE'),
  SilkCountry(name: 'South Africa',   dialCode: '+27',  flag: '🇿🇦', code: 'ZA'),
  SilkCountry(name: 'United Kingdom', dialCode: '+44',  flag: '🇬🇧', code: 'GB'),
  SilkCountry(name: 'United States',  dialCode: '+1',   flag: '🇺🇸', code: 'US'),
  SilkCountry(name: 'Canada',         dialCode: '+1',   flag: '🇨🇦', code: 'CA'),
  SilkCountry(name: 'Germany',        dialCode: '+49',  flag: '🇩🇪', code: 'DE'),
  SilkCountry(name: 'France',         dialCode: '+33',  flag: '🇫🇷', code: 'FR'),
  SilkCountry(name: 'India',          dialCode: '+91',  flag: '🇮🇳', code: 'IN'),
  SilkCountry(name: 'China',          dialCode: '+86',  flag: '🇨🇳', code: 'CN'),
  SilkCountry(name: 'Brazil',         dialCode: '+55',  flag: '🇧🇷', code: 'BR'),
  SilkCountry(name: 'Australia',      dialCode: '+61',  flag: '🇦🇺', code: 'AU'),
  SilkCountry(name: 'UAE',            dialCode: '+971', flag: '🇦🇪', code: 'AE'),
  SilkCountry(name: 'Rwanda',         dialCode: '+250', flag: '🇷🇼', code: 'RW'),
  SilkCountry(name: 'Ethiopia',       dialCode: '+251', flag: '🇪🇹', code: 'ET'),
  SilkCountry(name: 'Tanzania',       dialCode: '+255', flag: '🇹🇿', code: 'TZ'),
  SilkCountry(name: 'Uganda',         dialCode: '+256', flag: '🇺🇬', code: 'UG'),
  SilkCountry(name: 'Senegal',        dialCode: '+221', flag: '🇸🇳', code: 'SN'),
  SilkCountry(name: 'Ivory Coast',    dialCode: '+225', flag: '🇨🇮', code: 'CI'),
];

class SilkPhoneInput extends StatefulWidget {
  const SilkPhoneInput({
    this.label,
    this.hint = 'Phone number',
    this.initialCountry,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  final String? label;
  final String hint;

  /// Defaults to the first country in the list if null.
  final SilkCountry? initialCountry;

  /// Called with (dialCode, localNumber) on every change.
  final void Function(String dialCode, String number)? onChanged;

  final String? errorText;
  final bool enabled;

  @override
  State<SilkPhoneInput> createState() => _SilkPhoneInputState();
}

class _SilkPhoneInputState extends State<SilkPhoneInput> {
  late SilkCountry _selected;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialCountry ?? _kCountries.first;
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _showPicker(BuildContext context) async {
    final tokens = context.tokens;
    final result = await showModalBottomSheet<SilkCountry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountryPickerSheet(
        countries: _kCountries,
        selected: _selected,
        tokens: tokens,
      ),
    );
    if (result != null) {
      setState(() => _selected = result);
      widget.onChanged?.call(result.dialCode, _controller.text);
    }
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
            color: tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(tokens.radiusMd),
            border: Border.all(color: borderColor, width: _focused ? 2 : 1.5),
          ),
          child: Row(
            children: [
              // Country picker trigger
              GestureDetector(
                onTap: widget.enabled ? () => _showPicker(context) : null,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: tokens.spaceMd, vertical: tokens.spaceMd),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_selected.flag, style: const TextStyle(fontSize: 20)),
                      SizedBox(width: tokens.spaceXs),
                      Text(
                        _selected.dialCode,
                        style: tokens.bodySmStyle.copyWith(color: tokens.onSurface),
                      ),
                      SizedBox(width: tokens.spaceXs / 2),
                      Icon(Icons.expand_more_rounded, size: 16, color: tokens.onSurfaceMuted),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 24, color: tokens.divider),
              // Number input
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: tokens.bodyStyle.copyWith(color: tokens.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: tokens.bodyStyle.copyWith(
                      color: tokens.onSurfaceMuted.withValues(alpha: 0.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: tokens.spaceMd,
                      vertical: tokens.spaceMd,
                    ),
                    isDense: true,
                  ),
                  onChanged: (v) =>
                      widget.onChanged?.call(_selected.dialCode, v),
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

// ── Country picker bottom sheet ───────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({
    required this.countries,
    required this.selected,
    required this.tokens,
  });

  final List<SilkCountry> countries;
  final SilkCountry selected;
  final dynamic tokens;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late List<SilkCountry> _filtered;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.countries;
    _search.addListener(_onSearch);
  }

  @override
  void dispose() {
    _search
      ..removeListener(_onSearch)
      ..dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.countries
          : widget.countries
              .where((c) =>
                  c.name.toLowerCase().contains(q) ||
                  c.dialCode.contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      margin: EdgeInsets.only(top: context.statusBarHeight + 48),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: tokens.spaceMd),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(tokens.spaceMd),
            child: TextField(
              controller: _search,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search country…',
                hintStyle: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
                prefixIcon: Icon(Icons.search, color: tokens.onSurfaceMuted),
                filled: true,
                fillColor: tokens.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(tokens.radiusMd),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: tokens.spaceSm),
              ),
              style: tokens.bodyStyle.copyWith(color: tokens.onSurface),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final c = _filtered[i];
                final isSelected = c.code == widget.selected.code;
                return ListTile(
                  leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
                  title: Text(c.name, style: tokens.bodyStyle.copyWith(color: tokens.onSurface)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.dialCode, style: tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted)),
                      if (isSelected) ...[
                        SizedBox(width: tokens.spaceXs),
                        Icon(Icons.check_rounded, color: tokens.accent, size: 18),
                      ],
                    ],
                  ),
                  onTap: () => Navigator.of(context).pop(c),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
        ],
      ),
    );
  }
}
