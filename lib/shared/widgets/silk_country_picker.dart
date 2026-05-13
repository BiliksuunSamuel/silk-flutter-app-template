import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_phone_input.dart' show SilkCountry;

/// Searchable country picker that opens a bottom sheet.
/// Displays a flag emoji + country name field; tapping opens the sheet.
///
/// Usage:
/// ```dart
/// SilkCountryPicker(
///   label: 'Country',
///   selected: _country,
///   onChanged: (c) => setState(() => _country = c),
/// )
/// ```
class SilkCountryPicker extends StatelessWidget {
  const SilkCountryPicker({
    required this.onChanged,
    this.label,
    this.selected,
    this.hint = 'Select country',
    this.countries = defaultCountries,
    super.key,
  });

  final String? label;
  final SilkCountry? selected;
  final String hint;
  final void Function(SilkCountry) onChanged;
  final List<SilkCountry> countries;

  static const defaultCountries = [
    SilkCountry(code: 'GH', name: 'Ghana', flag: '🇬🇭', dialCode: '+233'),
    SilkCountry(code: 'NG', name: 'Nigeria', flag: '🇳🇬', dialCode: '+234'),
    SilkCountry(code: 'KE', name: 'Kenya', flag: '🇰🇪', dialCode: '+254'),
    SilkCountry(code: 'ZA', name: 'South Africa', flag: '🇿🇦', dialCode: '+27'),
    SilkCountry(code: 'US', name: 'United States', flag: '🇺🇸', dialCode: '+1'),
    SilkCountry(code: 'GB', name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
    SilkCountry(code: 'DE', name: 'Germany', flag: '🇩🇪', dialCode: '+49'),
    SilkCountry(code: 'FR', name: 'France', flag: '🇫🇷', dialCode: '+33'),
    SilkCountry(code: 'CA', name: 'Canada', flag: '🇨🇦', dialCode: '+1'),
    SilkCountry(code: 'AU', name: 'Australia', flag: '🇦🇺', dialCode: '+61'),
    SilkCountry(code: 'IN', name: 'India', flag: '🇮🇳', dialCode: '+91'),
    SilkCountry(code: 'JP', name: 'Japan', flag: '🇯🇵', dialCode: '+81'),
    SilkCountry(code: 'CN', name: 'China', flag: '🇨🇳', dialCode: '+86'),
    SilkCountry(code: 'BR', name: 'Brazil', flag: '🇧🇷', dialCode: '+55'),
    SilkCountry(code: 'AE', name: 'UAE', flag: '🇦🇪', dialCode: '+971'),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
          ),
          SizedBox(height: tokens.spaceXs),
        ],
        GestureDetector(
          onTap: () => _openSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceMd,
              vertical: tokens.spaceMd,
            ),
            decoration: BoxDecoration(
              color: tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              border: Border.all(color: tokens.divider),
            ),
            child: Row(
              children: [
                if (selected != null) ...[
                  Text(selected!.flag, style: const TextStyle(fontSize: 20)),
                  SizedBox(width: tokens.spaceSm),
                  Expanded(
                    child: Text(selected!.name, style: tokens.bodyStyle),
                  ),
                ] else
                  Expanded(
                    child: Text(
                      hint,
                      style: tokens.bodyStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                  ),
                Icon(
                  Icons.expand_more_rounded,
                  color: tokens.onSurfaceMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openSheet(BuildContext context) async {
    final result = await showModalBottomSheet<SilkCountry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CountrySheet(countries: countries),
    );
    if (result != null) onChanged(result);
  }
}

class _CountrySheet extends StatefulWidget {
  const _CountrySheet({required this.countries});
  final List<SilkCountry> countries;

  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String _query = '';

  List<SilkCountry> get _filtered => widget.countries
      .where((c) =>
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.code.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radiusLg),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: tokens.spaceSm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: tokens.spaceMd),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: tokens.spaceLg),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search countries…',
                  hintStyle: tokens.bodyStyle
                      .copyWith(color: tokens.onSurfaceMuted),
                  prefixIcon: Icon(
                    Icons.search,
                    color: tokens.onSurfaceMuted,
                  ),
                  filled: true,
                  fillColor: tokens.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(tokens.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                style: tokens.bodyStyle,
              ),
            ),
            SizedBox(height: tokens.spaceSm),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final country = _filtered[i];
                  return ListTile(
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(country.name, style: tokens.bodyStyle),
                    trailing: Text(
                      country.dialCode,
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                    onTap: () => Navigator.of(context).pop(country),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
