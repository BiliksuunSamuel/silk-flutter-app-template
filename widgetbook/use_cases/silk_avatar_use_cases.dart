import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_avatar.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Initials', type: SilkAvatar)
Widget initialsAvatar(BuildContext context) {
  return const Center(
    child: SilkAvatar(size: 56, initials: 'John Doe'),
  );
}

@UseCase(name: 'Single Initial', type: SilkAvatar)
Widget singleInitialAvatar(BuildContext context) {
  return const Center(
    child: SilkAvatar(size: 56, initials: 'Alex'),
  );
}

@UseCase(name: 'Sizes', type: SilkAvatar)
Widget sizesAvatar(BuildContext context) {
  return const Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SilkAvatar(size: 32, initials: 'SM'),
        SizedBox(width: 16),
        SilkAvatar(size: 48, initials: 'MD'),
        SizedBox(width: 16),
        SilkAvatar(size: 64, initials: 'LG'),
        SizedBox(width: 16),
        SilkAvatar(size: 80, initials: 'XL'),
      ],
    ),
  );
}
