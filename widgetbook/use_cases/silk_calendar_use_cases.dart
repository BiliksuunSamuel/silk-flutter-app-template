import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_calendar.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: SilkCalendar)
Widget calendarDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SilkCalendar(
      onDateSelected: (_) {},
    ),
  );
}

@UseCase(name: 'With selection', type: SilkCalendar)
Widget calendarWithSelection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SilkCalendar(
      selectedDate: DateTime.now(),
      onDateSelected: (_) {},
    ),
  );
}

@UseCase(name: 'With highlights', type: SilkCalendar)
Widget calendarWithHighlights(BuildContext context) {
  final now = DateTime.now();
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SilkCalendar(
      selectedDate: now,
      highlightedDates: [
        DateTime(now.year, now.month, 5),
        DateTime(now.year, now.month, 12),
        DateTime(now.year, now.month, 20),
      ],
      onDateSelected: (_) {},
    ),
  );
}

@UseCase(name: 'With range constraint', type: SilkCalendar)
Widget calendarWithRange(BuildContext context) {
  final now = DateTime.now();
  return Padding(
    padding: const EdgeInsets.all(24),
    child: SilkCalendar(
      firstDate: now,
      lastDate: DateTime(now.year, now.month + 2, now.day),
      onDateSelected: (_) {},
    ),
  );
}
