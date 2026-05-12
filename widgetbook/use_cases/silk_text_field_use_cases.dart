import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_text_field.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: SilkTextField)
Widget defaultTextField(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24),
    child: SilkTextField(hint: 'Enter your name'),
  );
}

@UseCase(name: 'With Error', type: SilkTextField)
Widget errorTextField(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24),
    child: SilkTextField(
      hint: 'Phone number',
      errorText: 'Invalid phone number',
    ),
  );
}

@UseCase(name: 'Disabled', type: SilkTextField)
Widget disabledTextField(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(24),
    child: SilkTextField(hint: 'Disabled field', enabled: false),
  );
}
