import 'package:flutter/material.dart';
import 'package:silk/shared/widgets/silk_icon_button.dart';
import 'package:silk/shared/widgets/silk_svg_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

// Replace 'assets/icons/example.svg' with an actual asset path in your project.
const _placeholder = 'assets/icons/example.svg';

@UseCase(name: 'Ghost', type: SilkSvgButton)
Widget svgButtonGhost(BuildContext context) {
  return Center(
    child: SilkSvgButton(
      assetPath: _placeholder,
      onPressed: () {},
      variant: SilkIconButtonVariant.ghost,
    ),
  );
}

@UseCase(name: 'Primary', type: SilkSvgButton)
Widget svgButtonPrimary(BuildContext context) {
  return Center(
    child: SilkSvgButton(
      assetPath: _placeholder,
      onPressed: () {},
      variant: SilkIconButtonVariant.primary,
    ),
  );
}
