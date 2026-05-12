import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkTimePicker extends StatelessWidget {
  const SilkTimePicker({
    required this.onChanged,
    this.selectedTime,
    this.hint = 'Select time',
    this.label,
    this.use24h = false,
    this.errorText,
    super.key,
  });

  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onChanged;
  final String hint;
  final String? label;
  final bool use24h;
  final String? errorText;

  String _formatTime(TimeOfDay time) {
    if (use24h) {
      final h = time.hour.toString().padLeft(2, '0');
      final m = time.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  Future<void> _show(BuildContext context) async {
    final tokens = context.tokens;
    final initial = selectedTime ?? TimeOfDay.now();
    var temp = DateTime(2000, 1, 1, initial.hour, initial.minute);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(tokens.radiusLg)),
      ),
      builder: (_) => _TimePickerSheet(
        initialDateTime: temp,
        use24h: use24h,
        onChanged: (d) => temp = d,
        onConfirm: () => onChanged(TimeOfDay(hour: temp.hour, minute: temp.minute)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasValue = selectedTime != null;

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
                    hasValue ? _formatTime(selectedTime!) : hint,
                    style: tokens.bodyStyle.copyWith(
                      color: hasValue ? tokens.onSurface : tokens.onSurfaceMuted,
                    ),
                  ),
                ),
                Icon(Icons.schedule_outlined, size: 18, color: tokens.onSurfaceMuted),
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

class _TimePickerSheet extends StatefulWidget {
  const _TimePickerSheet({
    required this.initialDateTime,
    required this.use24h,
    required this.onChanged,
    required this.onConfirm,
  });

  final DateTime initialDateTime;
  final bool use24h;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onConfirm;

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late DateTime _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialDateTime;
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
                Text('Select Time', style: tokens.titleStyle),
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
              mode: CupertinoDatePickerMode.time,
              use24hFormat: widget.use24h,
              initialDateTime: _current,
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
