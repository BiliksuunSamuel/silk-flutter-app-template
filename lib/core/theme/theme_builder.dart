import 'package:flutter/material.dart';
import 'package:silk/core/theme/tokens.dart';

abstract final class ThemeBuilder {
  static ThemeData buildTheme(AppTokens tokens) {
    final isLight = tokens.surface.computeLuminance() > 0.5;
    final brightness = isLight ? Brightness.light : Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: tokens.surface,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: tokens.accent,
        onPrimary: Colors.white,
        secondary: tokens.accent,
        onSecondary: Colors.white,
        error: tokens.danger,
        onError: Colors.white,
        surface: tokens.surface,
        onSurface: tokens.onSurface,
        surfaceContainerHighest: tokens.surfaceMuted,
        outline: tokens.divider,
      ),
      dividerColor: tokens.divider,
      dividerTheme: DividerThemeData(
        color: tokens.divider,
        thickness: 0.5,
        space: 0,
      ),
      textTheme: TextTheme(
        displayLarge: tokens.displayStyle,
        titleLarge: tokens.titleStyle,
        titleMedium: tokens.titleStyle.copyWith(fontSize: 17),
        bodyLarge: tokens.bodyStyle,
        bodyMedium: tokens.bodyStyle.copyWith(fontSize: 14),
        bodySmall: tokens.captionStyle,
        labelSmall: tokens.captionStyle,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surface,
        foregroundColor: tokens.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: tokens.titleStyle,
      ),
      extensions: [tokens],
    );
  }
}
