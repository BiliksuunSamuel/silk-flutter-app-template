import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silk/core/theme/tokens.dart';

/// Builds the Material theme from [AppTokens] following the Solid UI rules:
///
///  - Material 3 surface tint and elevation colour are switched off — depth
///    comes from hairlines and the few floating shadows in [AppTokens].
///  - No ink ripples; pressables use `PressableScale` instead.
///  - Cupertino page transitions on both platforms (native push / swipe-back).
abstract final class ThemeBuilder {
  static ThemeData buildTheme(AppTokens tokens) {
    final isLight = tokens.surface.computeLuminance() > 0.5;
    final brightness = isLight ? Brightness.light : Brightness.dark;

    // Apply Inter across ALL Material text styles not covered by our custom
    // scale — ensures any widget using Theme.of(context).textTheme gets Inter.
    final baseTextTheme = GoogleFonts.interTextTheme(
      isLight ? ThemeData.light().textTheme : ThemeData.dark().textTheme,
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

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.accent,
      onPrimary: tokens.onAccent,
      secondary: tokens.accent,
      onSecondary: tokens.onAccent,
      error: tokens.danger,
      onError: Colors.white,
      surface: tokens.surface,
      onSurface: tokens.onSurface,
      surfaceTint: Colors.transparent, // ← no M3 tint
      surfaceContainerHighest: tokens.surfaceMuted,
      outline: tokens.hairlineStrong,
      outlineVariant: tokens.hairline,
    );

    const cupertinoTransitions = PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
      },
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.canvas,
      canvasColor: tokens.canvas,
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory, // press-scale instead of ripples
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      pageTransitionsTheme: cupertinoTransitions,
      dividerColor: tokens.hairline,
      dividerTheme: DividerThemeData(
        color: tokens.hairline,
        thickness: 0.5,
        space: 0.5,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: tokens.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: tokens.titleSmStyle,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: tokens.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          side: BorderSide(color: tokens.hairlineSoft),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: tokens.surface,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      extensions: [tokens],
    );
  }
}
