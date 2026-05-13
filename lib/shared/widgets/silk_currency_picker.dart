import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkCurrency {
  const SilkCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });

  final String code;
  final String name;
  final String symbol;
  final String flag;
}

/// Searchable currency picker that opens a bottom sheet.
///
/// Usage:
/// ```dart
/// SilkCurrencyPicker(
///   label: 'Currency',
///   selected: _currency,
///   onChanged: (c) => setState(() => _currency = c),
/// )
/// ```
class SilkCurrencyPicker extends StatelessWidget {
  const SilkCurrencyPicker({
    required this.onChanged,
    this.label,
    this.selected,
    this.hint = 'Select currency',
    this.currencies = defaultCurrencies,
    super.key,
  });

  final String? label;
  final SilkCurrency? selected;
  final String hint;
  final void Function(SilkCurrency) onChanged;
  final List<SilkCurrency> currencies;

  static const defaultCurrencies = [
    SilkCurrency(code: 'GHS', name: 'Ghanaian Cedi', symbol: '₵', flag: '🇬🇭'),
    SilkCurrency(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', flag: '🇳🇬'),
    SilkCurrency(code: 'KES', name: 'Kenyan Shilling', symbol: 'KSh', flag: '🇰🇪'),
    SilkCurrency(code: 'USD', name: 'US Dollar', symbol: r'$', flag: '🇺🇸'),
    SilkCurrency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
    SilkCurrency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧'),
    SilkCurrency(code: 'ZAR', name: 'South African Rand', symbol: 'R', flag: '🇿🇦'),
    SilkCurrency(code: 'CAD', name: 'Canadian Dollar', symbol: r'C$', flag: '🇨🇦'),
    SilkCurrency(code: 'AUD', name: 'Australian Dollar', symbol: r'A$', flag: '🇦🇺'),
    SilkCurrency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵'),
    SilkCurrency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳'),
    SilkCurrency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', flag: '🇦🇪'),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: tokens.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      selected!.code,
                      style: tokens.captionStyle.copyWith(
                        color: tokens.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
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
    final result = await showModalBottomSheet<SilkCurrency>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CurrencySheet(currencies: currencies),
    );
    if (result != null) onChanged(result);
  }
}

class _CurrencySheet extends StatefulWidget {
  const _CurrencySheet({required this.currencies});
  final List<SilkCurrency> currencies;

  @override
  State<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<_CurrencySheet> {
  String _query = '';

  List<SilkCurrency> get _filtered => widget.currencies
      .where((c) =>
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.code.toLowerCase().contains(_query.toLowerCase()) ||
          c.symbol.contains(_query))
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
                  hintText: 'Search currencies…',
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
                  final currency = _filtered[i];
                  return ListTile(
                    leading: Text(
                      currency.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(currency.name, style: tokens.bodyStyle),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currency.symbol,
                          style: tokens.bodyStyle.copyWith(
                            color: tokens.onSurfaceMuted,
                          ),
                        ),
                        SizedBox(width: tokens.spaceXs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: tokens.surfaceMuted,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            currency.code,
                            style: tokens.captionStyle.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pop(currency),
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
