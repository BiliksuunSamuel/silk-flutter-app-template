import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkDatePicker extends StatelessWidget {
  const SilkDatePicker({
    required this.onChanged,
    this.selectedDate,
    this.hint = 'Select date',
    this.label,
    this.firstDate,
    this.lastDate,
    this.errorText,
    super.key,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;
  final String hint;
  final String? label;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _show(BuildContext context) async {
    final tokens = context.tokens;
    var temp = selectedDate ?? DateTime.now();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(tokens.radiusLg)),
      ),
      builder: (_) => _DatePickerSheet(
        initialDate: temp,
        firstDate: firstDate,
        lastDate: lastDate,
        onChanged: (d) => temp = d,
        onConfirm: () => onChanged(temp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasValue = selectedDate != null;

    return GestureDetector(
      onTap: () => _show(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) ...[
            Text(label!, style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted)),
            SizedBox(height: tokens.spaceXs),
          ],
          AnimatedContainer(
            duration: MotionTokens.fast,
            curve: MotionTokens.standardCurve,
            height: 52,
            decoration: BoxDecoration(
              color: tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              border: Border.all(
                color: errorText != null ? tokens.danger : tokens.divider,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: tokens.spaceMd),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? _formatDate(selectedDate!) : hint,
                    style: tokens.bodyStyle.copyWith(
                      color: hasValue ? tokens.onSurface : tokens.onSurfaceMuted,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_outlined, size: 18, color: tokens.onSurfaceMuted),
              ],
            ),
          ),
          if (errorText != null) ...[
            SizedBox(height: tokens.spaceXs),
            Text(
              errorText!,
              style: tokens.captionStyle.copyWith(color: tokens.danger),
            ),
          ],
        ],
      ),
    );
  }
}

class _DatePickerSheet extends StatefulWidget {
  const _DatePickerSheet({
    required this.initialDate,
    required this.onChanged,
    required this.onConfirm,
    this.firstDate,
    this.lastDate,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onConfirm;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: tokens.spaceSm),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: tokens.divider,
              borderRadius: BorderRadius.circular(tokens.radiusPill),
            ),
          ),
          SizedBox(height: tokens.spaceMd),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spaceLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
                  ),
                ),
                Text('Select Date', style: tokens.titleStyle),
                GestureDetector(
                  onTap: () {
                    widget.onConfirm();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Done',
                    style: tokens.bodyStyle.copyWith(
                      color: tokens.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.spaceSm),
          SizedBox(
            height: 216,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _current,
              minimumDate: widget.firstDate,
              maximumDate: widget.lastDate,
              onDateTimeChanged: (d) {
                _current = d;
                widget.onChanged(d);
              },
            ),
          ),
          SizedBox(height: tokens.spaceMd),
        ],
      ),
    );
  }
}
