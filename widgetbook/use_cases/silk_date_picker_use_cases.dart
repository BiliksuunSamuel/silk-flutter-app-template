import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_date_picker.dart';
import 'package:silk/shared/widgets/silk_date_time_picker.dart';
import 'package:silk/shared/widgets/silk_time_picker.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Empty', type: SilkDatePicker)
Widget datePicker(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDatePicker(
        label: 'Date of birth',
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'With value', type: SilkDatePicker)
Widget datePickerWithValue(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDatePicker(
        label: 'Date of birth',
        selectedDate: DateTime(1992, 7, 14),
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'Error', type: SilkDatePicker)
Widget datePickerError(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDatePicker(
        label: 'Date of birth',
        onChanged: (_) {},
        errorText: 'Date is required',
      ),
    ),
  );
}

@UseCase(name: 'Empty', type: SilkTimePicker)
Widget timePicker(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkTimePicker(
        label: 'Meeting time',
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'With value', type: SilkTimePicker)
Widget timePickerWithValue(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkTimePicker(
        label: 'Meeting time',
        selectedTime: const TimeOfDay(hour: 14, minute: 30),
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'Empty', type: SilkDateTimePicker)
Widget dateTimePicker(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDateTimePicker(
        label: 'Scheduled at',
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'With value', type: SilkDateTimePicker)
Widget dateTimePickerWithValue(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDateTimePicker(
        label: 'Scheduled at',
        selectedDateTime: DateTime(2025, 3, 18, 10, 0),
        onChanged: (_) {},
      ),
    ),
  );
}
