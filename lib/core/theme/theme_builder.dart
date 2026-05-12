import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silk/core/theme/tokens.dart';

abstract final class ThemeBuilder {
  static ThemeData buildTheme(AppTokens tokens) {
    final isLight = tokens.surface.computeLuminance() > 0.5;
    final brightness = isLight ? Brightness.light : Brightness.dark;

    // Apply Inter across ALL Material text styles not covered by our custom
    // scale — ensures any widget using Theme.of(context).textTheme gets Inter.
    final baseTextTheme = GoogleFonts.interTextTheme(
      brightness == Brightness.light
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme,
    );

    final textTheme = baseTextTheme.copyWith(
      displayLarge: tokens.displayStyle,
      displayMedium: tokens.headlineStyle,
      headlineLarge: tokens.headlineStyle,
      headlineMedium: tokens.titleStyle,
      titleLarge: tokens.titleStyle,
      titleMedium: tokens.titleSmStyle,
      titleSmall: tokens.titleSmStyle,
      bodyLarge: tokens.bodyStyle,
      bodyMedium: tokens.bodySmStyle,
      bodySmall: tokens.captionStyle,
      labelLarge: tokens.labelStyle,
      labelMedium: tokens.labelStyle,
      labelSmall: tokens.captionStyle,
    );

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
      textTheme: textTheme,
      dividerColor: tokens.divider,
      dividerTheme: DividerThemeData(
        color: tokens.divider,
        thickness: 0.5,
        space: 0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surface,
        foregroundColor: tokens.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: tokens.titleSmStyle,
      ),
      extensions: [tokens],
    );
  }
}
