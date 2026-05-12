import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_dropdown.dart';
import 'package:silk/shared/widgets/silk_multi_value_select_input.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

final _countries = [
  const SilkSelectItem(value: 'us', label: 'United States'),
  const SilkSelectItem(value: 'gb', label: 'United Kingdom'),
  const SilkSelectItem(value: 'de', label: 'Germany'),
  const SilkSelectItem(value: 'fr', label: 'France'),
  const SilkSelectItem(value: 'jp', label: 'Japan'),
  const SilkSelectItem(value: 'ng', label: 'Nigeria'),
];

@UseCase(name: 'Empty', type: SilkDropdown)
Widget dropdownEmpty(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDropdown<String>(
        items: _countries,
        label: 'Country',
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'With value', type: SilkDropdown)
Widget dropdownWithValue(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDropdown<String>(
        items: _countries,
        label: 'Country',
        value: 'ng',
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'Error', type: SilkDropdown)
Widget dropdownError(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkDropdown<String>(
        items: _countries,
        label: 'Country',
        onChanged: (_) {},
        errorText: 'Please select a country',
      ),
    ),
  );
}

@UseCase(name: 'Empty', type: SilkMultiValueSelectInput)
Widget multiSelectEmpty(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkMultiValueSelectInput<String>(
        items: _countries,
        selectedValues: const [],
        label: 'Countries visited',
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'With values', type: SilkMultiValueSelectInput)
Widget multiSelectWithValues(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkMultiValueSelectInput<String>(
        items: _countries,
        selectedValues: const ['us', 'de', 'ng'],
        label: 'Countries visited',
        onChanged: (_) {},
      ),
    ),
  );
}

@UseCase(name: 'Max 3 selectable', type: SilkMultiValueSelectInput)
Widget multiSelectCapped(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: SilkMultiValueSelectInput<String>(
        items: _countries,
        selectedValues: const ['us', 'gb'],
        label: 'Favourite countries (max 3)',
        maxSelectable: 3,
        onChanged: (_) {},
      ),
    ),
  );
}
