import 'package:flutter/material.dart';

@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.accent,
    required this.surface,
    required this.surfaceMuted,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.divider,
    required this.danger,
    required this.success,
    required this.spaceXs,
    required this.spaceSm,
    required this.spaceMd,
    required this.spaceLg,
    required this.spaceXl,
    required this.spaceXxl,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusPill,
    required this.displayStyle,
    required this.headlineStyle,
    required this.titleStyle,
    required this.titleSmStyle,
    required this.bodyStyle,
    required this.bodySmStyle,
    required this.labelStyle,
    required this.captionStyle,
    required this.overlineStyle,
    required this.monoStyle,
    required this.shadowSm,
    required this.shadowMd,
    required this.shadowLg,
  });

  // ── Colors ─────────────────────────────────────────────────────────────────

  final Color accent;
  final Color surface;
  final Color surfaceMuted;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color divider;
  final Color danger;
  final Color success;

  // ── Spacing ────────────────────────────────────────────────────────────────

  final double spaceXs;
  final double spaceSm;
  final double spaceMd;
  final double spaceLg;
  final double spaceXl;
  final double spaceXxl;

  // ── Radii ──────────────────────────────────────────────────────────────────

  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusPill;

  // ── Typography ─────────────────────────────────────────────────────────────
  //
  // Full Inter-based type scale. See AppTypography for size/weight reference.

  /// 32 / w700 — hero text.
  final TextStyle displayStyle;

  /// 24 / w600 — page titles.
  final TextStyle headlineStyle;

  /// 20 / w600 — section headings.
  final TextStyle titleStyle;

  /// 17 / w600 — nav titles, prominent list items.
  final TextStyle titleSmStyle;

  /// 16 / w400 — standard body text.
  final TextStyle bodyStyle;

  /// 14 / w400 — dense or secondary body text.
  final TextStyle bodySmStyle;

  /// 13 / w500 — chips, badges, button labels.
  final TextStyle labelStyle;

  /// 12 / w400 — helper text, timestamps.
  final TextStyle captionStyle;

  /// 11 / w600 / 1.0 tracking — section dividers (often uppercased).
  final TextStyle overlineStyle;

  /// 14 / w400 mono — code, OTP, numeric identifiers.
  final TextStyle monoStyle;

  // ── Elevation ──────────────────────────────────────────────────────────────

  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;

  // ── ThemeExtension ─────────────────────────────────────────────────────────

  @override
  AppTokens copyWith({
    Color? accent,
    Color? surface,
    Color? surfaceMuted,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? divider,
    Color? danger,
    Color? success,
    double? spaceXs,
    double? spaceSm,
    double? spaceMd,
    double? spaceLg,
    double? spaceXl,
    double? spaceXxl,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusPill,
    TextStyle? displayStyle,
    TextStyle? headlineStyle,
    TextStyle? titleStyle,
    TextStyle? titleSmStyle,
    TextStyle? bodyStyle,
    TextStyle? bodySmStyle,
    TextStyle? labelStyle,
    TextStyle? captionStyle,
    TextStyle? overlineStyle,
    TextStyle? monoStyle,
    List<BoxShadow>? shadowSm,
    List<BoxShadow>? shadowMd,
    List<BoxShadow>? shadowLg,
  }) {
    return AppTokens(
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      divider: divider ?? this.divider,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      spaceXs: spaceXs ?? this.spaceXs,
      spaceSm: spaceSm ?? this.spaceSm,
      spaceMd: spaceMd ?? this.spaceMd,
      spaceLg: spaceLg ?? this.spaceLg,
      spaceXl: spaceXl ?? this.spaceXl,
      spaceXxl: spaceXxl ?? this.spaceXxl,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusPill: radiusPill ?? this.radiusPill,
      displayStyle: displayStyle ?? this.displayStyle,
      headlineStyle: headlineStyle ?? this.headlineStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      titleSmStyle: titleSmStyle ?? this.titleSmStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      bodySmStyle: bodySmStyle ?? this.bodySmStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      captionStyle: captionStyle ?? this.captionStyle,
      overlineStyle: overlineStyle ?? this.overlineStyle,
      monoStyle: monoStyle ?? this.monoStyle,
      shadowSm: shadowSm ?? this.shadowSm,
      shadowMd: shadowMd ?? this.shadowMd,
      shadowLg: shadowLg ?? this.shadowLg,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    return AppTokens(
      accent: Color.lerp(accent, other.accent, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      success: Color.lerp(success, other.success, t)!,
      // Spacing and radii don't lerp — they're structural constants.
      spaceXs: spaceXs,
      spaceSm: spaceSm,
      spaceMd: spaceMd,
      spaceLg: spaceLg,
      spaceXl: spaceXl,
      spaceXxl: spaceXxl,
      radiusSm: radiusSm,
      radiusMd: radiusMd,
      radiusLg: radiusLg,
      radiusPill: radiusPill,
      displayStyle: TextStyle.lerp(displayStyle, other.displayStyle, t)!,
      headlineStyle: TextStyle.lerp(headlineStyle, other.headlineStyle, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      titleSmStyle: TextStyle.lerp(titleSmStyle, other.titleSmStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      bodySmStyle: TextStyle.lerp(bodySmStyle, other.bodySmStyle, t)!,
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t)!,
      captionStyle: TextStyle.lerp(captionStyle, other.captionStyle, t)!,
      overlineStyle: TextStyle.lerp(overlineStyle, other.overlineStyle, t)!,
      monoStyle: TextStyle.lerp(monoStyle, other.monoStyle, t)!,
      shadowSm: t < 0.5 ? shadowSm : other.shadowSm,
      shadowMd: t < 0.5 ? shadowMd : other.shadowMd,
      shadowLg: t < 0.5 ? shadowLg : other.shadowLg,
    );
  }
}
