import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkDateTimePicker extends StatelessWidget {
  const SilkDateTimePicker({
    required this.onChanged,
    this.selectedDateTime,
    this.hint = 'Select date & time',
    this.label,
    this.firstDate,
    this.lastDate,
    this.use24h = false,
    this.errorText,
    super.key,
  });

  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onChanged;
  final String hint;
  final String? label;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool use24h;
  final String? errorText;

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final date = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    if (use24h) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$date  $h:$m';
    }
    final tod = TimeOfDay.fromDateTime(dt);
    final h = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final m = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$date  $h:$m $period';
  }

  Future<void> _show(BuildContext context) async {
    final tokens = context.tokens;
    var temp = selectedDateTime ?? DateTime.now();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(tokens.radiusLg)),
      ),
      builder: (_) => _DateTimePickerSheet(
        initialDateTime: temp,
        firstDate: firstDate,
        lastDate: lastDate,
        use24h: use24h,
        onChanged: (d) => temp = d,
        onConfirm: () => onChanged(temp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasValue = selectedDateTime != null;

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
                    hasValue ? _formatDateTime(selectedDateTime!) : hint,
                    style: tokens.bodyStyle.copyWith(
                      color: hasValue ? tokens.onSurface : tokens.onSurfaceMuted,
                    ),
                  ),
                ),
                Icon(Icons.event_outlined, size: 18, color: tokens.onSurfaceMuted),
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

class _DateTimePickerSheet extends StatefulWidget {
  const _DateTimePickerSheet({
    required this.initialDateTime,
    required this.use24h,
    required this.onChanged,
    required this.onConfirm,
    this.firstDate,
    this.lastDate,
  });

  final DateTime initialDateTime;
  final bool use24h;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onConfirm;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<_DateTimePickerSheet> createState() => _DateTimePickerSheetState();
}

class _DateTimePickerSheetState extends State<_DateTimePickerSheet> {
  late DateTime _current;
  int _step = 0; // 0 = date, 1 = time

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
                  onTap: () {
                    if (_step == 0) {
                      Navigator.of(context).pop();
                    } else {
                      setState(() => _step = 0);
                    }
                  },
                  child: Text(
                    _step == 0 ? 'Cancel' : 'Back',
                    style: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
                  ),
                ),
                Text(
                  _step == 0 ? 'Select Date' : 'Select Time',
                  style: tokens.titleStyle,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onChanged(_current);
                    if (_step == 0) {
                      setState(() => _step = 1);
                    } else {
                      widget.onConfirm();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    _step == 0 ? 'Next' : 'Done',
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
          AnimatedSwitcher(
            duration: MotionTokens.fast,
            child: SizedBox(
              key: ValueKey(_step),
              height: 216,
              child: _step == 0
                  ? CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _current,
                      minimumDate: widget.firstDate,
                      maximumDate: widget.lastDate,
                      onDateTimeChanged: (d) {
                        _current = DateTime(
                          d.year,
                          d.month,
                          d.day,
                          _current.hour,
                          _current.minute,
                        );
                        widget.onChanged(_current);
                      },
                    )
                  : CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: widget.use24h,
                      initialDateTime: _current,
                      onDateTimeChanged: (d) {
                        _current = DateTime(
                          _current.year,
                          _current.month,
                          _current.day,
                          d.hour,
                          d.minute,
                        );
                        widget.onChanged(_current);
                      },
                    ),
            ),
          ),
          SizedBox(height: tokens.spaceMd),
        ],
      ),
    );
  }
}
