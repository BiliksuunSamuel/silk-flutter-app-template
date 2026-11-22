import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A tappable field that opens a month + year picker bottom sheet.
/// Returns a [DateTime] normalised to the first of the selected month.
///
/// Usage:
/// ```dart
/// SilkMonthPicker(
///   label: 'Report period',
///   value: _month,
///   onChanged: (m) => setState(() => _month = m),
/// )
/// ```
class SilkMonthPicker extends StatelessWidget {
  const SilkMonthPicker({
    required this.onChanged,
    this.label,
    this.value,
    this.hint = 'Select month',
    this.firstDate,
    this.lastDate,
    super.key,
  });

  final String? label;
  final DateTime? value;
  final String hint;
  final void Function(DateTime) onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _format(DateTime d) => '${_months[d.month - 1]} ${d.year}';

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
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: tokens.onSurfaceMuted,
                ),
                SizedBox(width: tokens.spaceSm),
                Expanded(
                  child: Text(
                    value != null ? _format(value!) : hint,
                    style: tokens.bodyStyle.copyWith(
                      color: value != null
                          ? tokens.onSurface
                          : tokens.onSurfaceMuted,
                    ),
                  ),
                ),
                Icon(
                  Icons.expand_more_rounded,
                  size: 20,
                  color: tokens.onSurfaceMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openSheet(BuildContext context) async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MonthSheet(
        selected: value,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
      ),
    );
    if (result != null) onChanged(result);
  }
}

class _MonthSheet extends StatefulWidget {
  const _MonthSheet({
    required this.firstDate,
    required this.lastDate,
    this.selected,
  });

  final DateTime? selected;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_MonthSheet> createState() => _MonthSheetState();
}

class _MonthSheetState extends State<_MonthSheet> {
  late int _year;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.selected?.year ?? DateTime.now().year;
  }

  bool _isSelectable(int month) {
    final d = DateTime(_year, month);
    return !d.isBefore(DateTime(widget.firstDate.year, widget.firstDate.month)) &&
        !d.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tokens.radiusLg),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        tokens.spaceLg,
        tokens.spaceMd,
        tokens.spaceLg,
        tokens.spaceXxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: tokens.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: tokens.spaceMd),
          // Year navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: _year > widget.firstDate.year
                    ? () => setState(() => _year--)
                    : null,
                color: tokens.onSurface,
              ),
              Text(
                '$_year',
                style: tokens.titleStyle,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: _year < widget.lastDate.year
                    ? () => setState(() => _year++)
                    : null,
                color: tokens.onSurface,
              ),
            ],
          ),
          SizedBox(height: tokens.spaceMd),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (_, i) {
              final month = i + 1;
              final isSelected = widget.selected?.year == _year &&
                  widget.selected?.month == month;
              final selectable = _isSelectable(month);

              return GestureDetector(
                onTap: selectable
                    ? () => Navigator.of(context)
                        .pop(DateTime(_year, month))
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tokens.accent
                        : tokens.surfaceMuted,
                    borderRadius:
                        BorderRadius.circular(tokens.radiusMd),
                  ),
                  child: Text(
                    _months[i].substring(0, 3),
                    style: tokens.bodySmStyle.copyWith(
                      color: isSelected
                          ? tokens.onAccent
                          : selectable
                              ? tokens.onSurface
                              : tokens.onSurfaceMuted,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
