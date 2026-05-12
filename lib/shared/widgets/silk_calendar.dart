import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

class SilkCalendar extends StatefulWidget {
  const SilkCalendar({
    required this.onDateSelected,
    this.selectedDate,
    this.focusedMonth,
    this.onMonthChanged,
    this.firstDate,
    this.lastDate,
    this.highlightedDates = const [],
    super.key,
  });

  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  /// The month currently displayed. Defaults to selectedDate or today.
  final DateTime? focusedMonth;
  final ValueChanged<DateTime>? onMonthChanged;

  final DateTime? firstDate;
  final DateTime? lastDate;

  /// Dates that get a subtle accent dot below the day number.
  final List<DateTime> highlightedDates;

  @override
  State<SilkCalendar> createState() => _SilkCalendarState();
}

class _SilkCalendarState extends State<SilkCalendar> {
  late DateTime _focusedMonth;

  static const _weekdayLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    final base = widget.focusedMonth ?? widget.selectedDate ?? DateTime.now();
    _focusedMonth = DateTime(base.year, base.month);
  }

  @override
  void didUpdateWidget(SilkCalendar old) {
    super.didUpdateWidget(old);
    if (widget.focusedMonth != null && widget.focusedMonth != old.focusedMonth) {
      _focusedMonth = DateTime(widget.focusedMonth!.year, widget.focusedMonth!.month);
    }
  }

  void _shiftMonth(int delta) {
    final next = DateTime(_focusedMonth.year, _focusedMonth.month + delta);
    setState(() => _focusedMonth = next);
    widget.onMonthChanged?.call(next);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    final sel = widget.selectedDate;
    if (sel == null) return false;
    return date.year == sel.year && date.month == sel.month && date.day == sel.day;
  }

  bool _isDisabled(DateTime date) {
    final first = widget.firstDate;
    final last = widget.lastDate;
    if (first != null && date.isBefore(first)) return true;
    if (last != null && date.isAfter(last)) return true;
    return false;
  }

  bool _isHighlighted(DateTime date) {
    return widget.highlightedDates.any(
      (h) => h.year == date.year && h.month == date.month && h.day == date.day,
    );
  }

  List<DateTime?> _buildDayCells() {
    final firstOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month);
    final daysInMonth = DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final startWeekday = firstOfMonth.weekday % 7; // Sunday = 0

    final cells = <DateTime?>[];
    for (var i = 0; i < startWeekday; i++) {
      cells.add(null);
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_focusedMonth.year, _focusedMonth.month, d));
    }
    // Pad to full rows
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return cells;
  }

  bool _canGoBack() {
    final first = widget.firstDate;
    if (first == null) return true;
    return _focusedMonth.isAfter(DateTime(first.year, first.month));
  }

  bool _canGoForward() {
    final last = widget.lastDate;
    if (last == null) return true;
    return _focusedMonth.isBefore(DateTime(last.year, last.month));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final cells = _buildDayCells();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Month header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: tokens.spaceXs),
          child: Row(
            children: [
              _NavArrow(
                icon: Icons.chevron_left,
                onTap: _canGoBack() ? () => _shiftMonth(-1) : null,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: MotionTokens.fast,
                  child: Text(
                    '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                    key: ValueKey('${_focusedMonth.year}-${_focusedMonth.month}'),
                    textAlign: TextAlign.center,
                    style: tokens.titleStyle,
                  ),
                ),
              ),
              _NavArrow(
                icon: Icons.chevron_right,
                onTap: _canGoForward() ? () => _shiftMonth(1) : null,
              ),
            ],
          ),
        ),
        SizedBox(height: tokens.spaceMd),
        // Weekday labels
        Row(
          children: _weekdayLabels
              .map(
                (d) => Expanded(
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: tokens.captionStyle.copyWith(
                      color: tokens.onSurfaceMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: tokens.spaceXs),
        // Day grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 0,
          ),
          itemCount: cells.length,
          itemBuilder: (_, i) {
            final date = cells[i];
            if (date == null) return const SizedBox.shrink();
            return _DayCell(
              date: date,
              isToday: _isToday(date),
              isSelected: _isSelected(date),
              isDisabled: _isDisabled(date),
              isHighlighted: _isHighlighted(date),
              onTap: _isDisabled(date) ? null : () => widget.onDateSelected(date),
            );
          },
        ),
      ],
    );
  }
}

class _NavArrow extends StatefulWidget {
  const _NavArrow({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<_NavArrow> createState() => _NavArrowState();
}

class _NavArrowState extends State<_NavArrow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final enabled = widget.onTap != null;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: enabled ? (_pressed ? 0.5 : 1.0) : 0.3,
        duration: MotionTokens.micro,
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceSm),
          child: Icon(widget.icon, size: 20, color: tokens.onSurface),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isToday,
    required this.isSelected,
    required this.isDisabled,
    required this.isHighlighted,
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isSelected;
  final bool isDisabled;
  final bool isHighlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final Color textColor;
    final Color bg;
    final BoxBorder? border;

    if (isSelected) {
      bg = tokens.accent;
      textColor = Colors.white;
      border = null;
    } else if (isToday) {
      bg = Colors.transparent;
      textColor = tokens.accent;
      border = Border.all(color: tokens.accent, width: 1.5);
    } else if (isDisabled) {
      bg = Colors.transparent;
      textColor = tokens.onSurfaceMuted.withValues(alpha: 0.4);
      border = null;
    } else {
      bg = Colors.transparent;
      textColor = tokens.onSurface;
      border = null;
    }

    final cell = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: MotionTokens.fast,
            curve: MotionTokens.standardCurve,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: border,
            ),
            alignment: Alignment.center,
            child: Text(
              '${date.day}',
              style: tokens.bodyStyle.copyWith(
                color: textColor,
                fontWeight:
                    isSelected || isToday ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (isHighlighted && !isSelected)
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: tokens.accent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return cell;

    return SilkReactionBurst(
      onTap: onTap,
      color: tokens.accent,
      particleCount: 8,
      spreadRadius: 26,
      child: cell,
    );
  }
}
