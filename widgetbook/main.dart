import 'package:flutter/material.dart';
import 'package:silk/core/theme/dark_tokens.dart';
import 'package:silk/core/theme/light_tokens.dart';
import 'package:silk/core/theme/theme_builder.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' show App;

import 'main.directories.g.dart';

void main() => runApp(const WidgetbookApp());

@App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.android.samsungGalaxyS20,
          ],
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeBuilder.buildTheme(lightTokens),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeBuilder.buildTheme(darkTokens),
            ),
          ],
        ),
        TextScaleAddon(),
      ],
    );
  }
}
