import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Primary', type: SilkButton)
Widget primaryButton(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: SilkButton(label: 'Continue', onPressed: null),
    ),
  );
}

@UseCase(name: 'Secondary', type: SilkButton)
Widget secondaryButton(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: SilkButton(
        label: 'Cancel',
        onPressed: null,
        variant: SilkButtonVariant.secondary,
      ),
    ),
  );
}

@UseCase(name: 'Ghost', type: SilkButton)
Widget ghostButton(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: SilkButton(
        label: 'Learn more',
        onPressed: null,
        variant: SilkButtonVariant.ghost,
      ),
    ),
  );
}

@UseCase(name: 'Destructive', type: SilkButton)
Widget destructiveButton(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: SilkButton(
        label: 'Delete account',
        onPressed: null,
        variant: SilkButtonVariant.destructive,
      ),
    ),
  );
}

@UseCase(name: 'Loading', type: SilkButton)
Widget loadingButton(BuildContext context) {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: SilkButton(
        label: 'Continue',
        onPressed: null,
        isLoading: true,
      ),
    ),
  );
}
