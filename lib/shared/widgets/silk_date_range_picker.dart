import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_button.dart';

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Immutable date range value.
@immutable
class SilkDateRange {
  const SilkDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  bool operator ==(Object other) =>
      other is SilkDateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// Tap-to-open date range selector backed by a custom range calendar sheet.
///
/// Usage:
/// ```dart
/// SilkDateRangePicker(
///   label: 'Transaction period',
///   value: _range,
///   onChanged: (r) => setState(() => _range = r),
/// )
/// ```
class SilkDateRangePicker extends StatelessWidget {
  const SilkDateRangePicker({
    required this.onChanged,
    this.value,
    this.label,
    this.hint = 'Select date range',
    this.firstDate,
    this.lastDate,
    this.errorText,
    super.key,
  });

  final SilkDateRange? value;
  final void Function(SilkDateRange?) onChanged;
  final String? label;
  final String hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorText;

  static const _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatRange(SilkDateRange r) {
    final now = DateTime.now();
    String fmt(DateTime d) {
      final m = _shortMonths[d.month - 1];
      return d.year != now.year ? '${d.day} $m ${d.year}' : '${d.day} $m';
    }

    return '${fmt(r.start)}  –  ${fmt(r.end)}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final range = value;
    final hasError = errorText != null;

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
          onTap: () => _showPicker(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceMd,
              vertical: tokens.spaceMd,
            ),
            decoration: BoxDecoration(
              color: tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(tokens.radiusMd),
              border: Border.all(
                color: hasError ? tokens.danger : tokens.divider,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range_outlined,
                  size: 18,
                  color: tokens.onSurfaceMuted,
                ),
                SizedBox(width: tokens.spaceSm),
                Expanded(
                  child: Text(
                    range != null ? _formatRange(range) : hint,
                    style: tokens.bodyStyle.copyWith(
                      color: range != null
                          ? tokens.onSurface
                          : tokens.onSurfaceMuted,
                    ),
                  ),
                ),
                if (range != null)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: tokens.onSurfaceMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: tokens.spaceXs),
          Text(
            errorText!,
            style: tokens.captionStyle.copyWith(color: tokens.danger),
          ),
        ],
      ],
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final result = await showModalBottomSheet<SilkDateRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RangePicker(
        initial: value,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2099),
      ),
    );
    if (result != null) onChanged(result);
  }
}

// ─── Bottom-sheet range picker ───────────────────────────────────────────────

class _RangePicker extends StatefulWidget {
  const _RangePicker({
    required this.firstDate,
    required this.lastDate,
    this.initial,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final SilkDateRange? initial;

  @override
  State<_RangePicker> createState() => _RangePickerState();
}

class _RangePickerState extends State<_RangePicker> {
  late DateTime _displayed;
  DateTime? _start;
  DateTime? _end;

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const _shortMonths = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _start = widget.initial?.start;
    _end = widget.initial?.end;
    final now = DateTime.now();
    _displayed = DateTime(
      widget.initial?.start.year ?? now.year,
      widget.initial?.start.month ?? now.month,
    );
  }

  bool get _canApply => _start != null && _end != null;

  void _onDayTap(DateTime day) {
    setState(() {
      if (_start == null || _end != null) {
        _start = day;
        _end = null;
      } else if (!day.isBefore(_start!)) {
        _end = _isSameDay(day, _start!) ? null : day;
      } else {
        _start = day;
        _end = null;
      }
    });
  }

  String _hintText() {
    if (_start == null) return 'Select start date';
    if (_end == null) return 'Select end date';
    final s = _start!;
    final e = _end!;
    return '${s.day} ${_shortMonths[s.month - 1]} – ${e.day} ${_shortMonths[e.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final daysInMonth =
        DateTime(_displayed.year, _displayed.month + 1, 0).day;
    final firstWeekday =
        DateTime(_displayed.year, _displayed.month, 1).weekday;

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            tokens.spaceLg,
            tokens.spaceSm,
            tokens.spaceLg,
            tokens.spaceLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: EdgeInsets.only(bottom: tokens.spaceSm),
                  decoration: BoxDecoration(
                    color: tokens.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: tokens.onSurface),
                    onPressed: () => setState(() {
                      _displayed =
                          DateTime(_displayed.year, _displayed.month - 1);
                    }),
                  ),
                  Text(
                    '${_monthNames[_displayed.month - 1]} ${_displayed.year}',
                    style: tokens.titleStyle,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: tokens.onSurface),
                    onPressed: () => setState(() {
                      _displayed =
                          DateTime(_displayed.year, _displayed.month + 1);
                    }),
                  ),
                ],
              ),
              SizedBox(height: tokens.spaceXs),
              Row(
                children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                    .map(
                      (d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: tokens.captionStyle.copyWith(
                              color: tokens.onSurfaceMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: tokens.spaceXs),
              _buildGrid(daysInMonth, firstWeekday),
              SizedBox(height: tokens.spaceMd),
              Text(
                _hintText(),
                style: tokens.captionStyle
                    .copyWith(color: tokens.onSurfaceMuted),
              ),
              SizedBox(height: tokens.spaceMd),
              SilkButton(
                label: 'Apply',
                onPressed: _canApply
                    ? () => Navigator.of(context).pop(
                          SilkDateRange(start: _start!, end: _end!),
                        )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(int daysInMonth, int firstWeekday) {
    final weeks = <List<DateTime?>>[];
    var week = <DateTime?>[];

    for (var i = 1; i < firstWeekday; i++) {
      week.add(null);
    }
    for (var d = 1; d <= daysInMonth; d++) {
      week.add(DateTime(_displayed.year, _displayed.month, d));
      if (week.length == 7) {
        weeks.add(week);
        week = [];
      }
    }
    if (week.isNotEmpty) {
      while (week.length < 7) {
        week.add(null);
      }
      weeks.add(week);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: weeks
          .map(
            (weekDays) => _WeekRow(
              days: weekDays,
              start: _start,
              end: _end,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              onDayTap: _onDayTap,
            ),
          )
          .toList(),
    );
  }
}

// ─── Week row ─────────────────────────────────────────────────────────────────

class _WeekRow extends StatelessWidget {
  const _WeekRow({
    required this.days,
    required this.firstDate,
    required this.lastDate,
    required this.onDayTap,
    this.start,
    this.end,
  });

  final List<DateTime?> days;
  final DateTime? start;
  final DateTime? end;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime) onDayTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: days.map((day) {
        if (day == null) {
          return const Expanded(child: SizedBox.shrink());
        }
        final isStart = start != null && _isSameDay(day, start!);
        final isEnd = end != null && _isSameDay(day, end!);
        final isInRange = start != null &&
            end != null &&
            day.isAfter(start!) &&
            day.isBefore(end!);
        final isDisabled =
            day.isBefore(firstDate) || day.isAfter(lastDate);

        return Expanded(
          child: _DayCell(
            day: day,
            isStart: isStart,
            isEnd: isEnd,
            isInRange: isInRange,
            isDisabled: isDisabled,
            onTap: isDisabled ? null : () => onDayTap(day),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Day cell ─────────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.isDisabled,
    required this.onTap,
  });

  final DateTime day;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final rangeColor = tokens.accent.withValues(alpha: 0.12);
    final isSelected = isStart || isEnd;

    // Half-strip visibility:
    // left half filled when this cell is the end or is in-range (not start)
    // right half filled when this cell is the start or is in-range (not end)
    final showLeft = (isInRange || isEnd) && !isStart;
    final showRight = (isInRange || isStart) && !isEnd;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: showLeft ? rangeColor : Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: showRight ? rangeColor : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: MotionTokens.fast,
              opacity: isDisabled ? 0.3 : 1.0,
              child: isSelected
                  ? Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: tokens.accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: tokens.captionStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Text(
                      '${day.day}',
                      style: tokens.captionStyle.copyWith(
                        color: isInRange ? tokens.accent : tokens.onSurface,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
