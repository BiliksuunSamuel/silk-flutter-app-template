import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_icon_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Variants', type: SilkIconButton)
Widget iconButtonVariants(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 16,
      children: [
        SilkIconButton(icon: Icons.add, onPressed: () {}, variant: SilkIconButtonVariant.primary),
        SilkIconButton(icon: Icons.add, onPressed: () {}, variant: SilkIconButtonVariant.ghost),
        SilkIconButton(icon: Icons.add, onPressed: () {}, variant: SilkIconButtonVariant.subtle),
        SilkIconButton(icon: Icons.delete_outline, onPressed: () {}, variant: SilkIconButtonVariant.destructive),
      ],
    ),
  );
}

@UseCase(name: 'Sizes', type: SilkIconButton)
Widget iconButtonSizes(BuildContext context) {
  return Center(
    child: Wrap(
      spacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SilkIconButton(icon: Icons.star_outline, onPressed: () {}, size: SilkIconButtonSize.sm),
        SilkIconButton(icon: Icons.star_outline, onPressed: () {}, size: SilkIconButtonSize.md),
        SilkIconButton(icon: Icons.star_outline, onPressed: () {}, size: SilkIconButtonSize.lg),
      ],
    ),
  );
}

@UseCase(name: 'Disabled', type: SilkIconButton)
Widget iconButtonDisabled(BuildContext context) {
  return const Center(
    child: SilkIconButton(icon: Icons.send, onPressed: null),
  );
}
