import 'package:flutter/material.dart';

/// Solid UI design tokens — one `ThemeExtension` holding every visual value.
///
/// Access via `context.tokens`. Light and dark sets live in `light_tokens.dart`
/// and `dark_tokens.dart`. Elevation is *earned*: only floating things (sheets,
/// dialogs, menus, toasts, FAB, active segment, primary button) get shadows.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.accent,
    required this.onAccent,
    required this.accentInk,
    required this.accentTint,
    required this.canvas,
    required this.surface,
    required this.surfaceMuted,
    required this.onSurface,
    required this.body,
    required this.onSurfaceMuted,
    required this.subtle,
    required this.hairline,
    required this.hairlineSoft,
    required this.hairlineStrong,
    required this.divider,
    required this.success,
    required this.successTint,
    required this.warning,
    required this.warningTint,
    required this.danger,
    required this.dangerTint,
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
    required this.radiusSegment,
    required this.radiusMedia,
    required this.radiusSheet,
    required this.displayStyle,
    required this.headlineStyle,
    required this.titleStyle,
    required this.title3Style,
    required this.titleSmStyle,
    required this.bodyStyle,
    required this.calloutStyle,
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

  /// Brand color: primary button fill, selection, links, unread indicators. Scarce.
  final Color accent;

  /// Text/icons on [accent] — white or black, whichever reaches ≥ 4.5:1.
  final Color onAccent;

  /// Accent-coloured *text* on [surface]/[canvas] (≥ 4.5:1). Use for links and text buttons.
  final Color accentInk;

  /// Accent at ~10% — selected rows, active chips, highlights.
  final Color accentTint;

  /// Scaffold background (page behind cards).
  final Color canvas;

  /// Cards, grouped lists, sheets, inputs — sits on [canvas].
  final Color surface;

  /// Sunken fills: inset groups, segmented track, inactive chips, skeletons.
  final Color surfaceMuted;

  /// Ink — titles and primary text.
  final Color onSurface;

  /// Body text (slightly softer than [onSurface]).
  final Color body;

  /// Muted — secondary text, inactive icons.
  final Color onSurfaceMuted;

  /// Timestamps and metadata. Not for anything actionable.
  final Color subtle;

  /// Dividers and row separators.
  final Color hairline;

  /// Card borders.
  final Color hairlineSoft;

  /// Input borders, secondary-button borders.
  final Color hairlineStrong;

  /// Alias of [hairline] (kept for older call sites).
  final Color divider;

  /// Online, completed, paid.
  final Color success;

  /// Background for success pills.
  final Color successTint;

  /// Pending, expiring.
  final Color warning;

  /// Background for warning pills.
  final Color warningTint;

  /// Errors, decline, destructive.
  final Color danger;

  /// Background for danger pills.
  final Color dangerTint;

  // ── Spacing (4 · 8 · 16 · 24 · 32 · 56; 12 and 20 via literals) ────────────

  final double spaceXs;
  final double spaceSm;
  final double spaceMd;
  final double spaceLg;
  final double spaceXl;
  final double spaceXxl;

  // ── Radii ──────────────────────────────────────────────────────────────────
  //
  // Inner corners are always smaller than outer ones.

  /// Small chips, tags.
  final double radiusSm;

  /// Controls — buttons, inputs, segmented track (12).
  final double radiusMd;

  /// Cards and grouped-list containers (20).
  final double radiusLg;

  /// Status pills, avatar badges.
  final double radiusPill;

  /// Active segment, small chips (9).
  final double radiusSegment;

  /// Images inside cards, chat media (16).
  final double radiusMedia;

  /// Top corners of bottom sheets and full-screen modals (28).
  final double radiusSheet;

  // ── Typography — Inter (see AppTypography for the full scale) ──────────────

  /// 34/40 w700 — large screen titles.
  final TextStyle displayStyle;

  /// 28/34 w700 — sheet titles, empty states.
  final TextStyle headlineStyle;

  /// 22/28 w700 — section titles.
  final TextStyle titleStyle;

  /// 20/25 w600 — card titles, amounts.
  final TextStyle title3Style;

  /// 17/22 w600 — row titles, buttons, nav titles.
  final TextStyle titleSmStyle;

  /// 17/24 w400 — messages, paragraphs.
  final TextStyle bodyStyle;

  /// 16/21 w400 — secondary paragraphs.
  final TextStyle calloutStyle;

  /// 15/20 w400 — row subtitles, dense body.
  final TextStyle bodySmStyle;

  /// 13/18 w500 — metadata, helper text, chips.
  final TextStyle labelStyle;

  /// 12/16 w500 — timestamps, pill labels.
  final TextStyle captionStyle;

  /// 11/13 w600 +0.6 — rare, grouped-list section headers (uppercase).
  final TextStyle overlineStyle;

  /// 14 mono — code, OTP, identifiers.
  final TextStyle monoStyle;

  // ── Elevation ──────────────────────────────────────────────────────────────
  //
  // Content (rows, cards, bubbles, inputs) never gets a shadow. Only floating
  // surfaces do.

  /// Active segment of a segmented control (and other small raised pieces).
  final List<BoxShadow> shadowSm;

  /// Floating surfaces: menus, toasts, FAB.
  final List<BoxShadow> shadowMd;

  /// Sheets and dialogs. Same recipe as [shadowMd] in light; dark steps surface lightness instead.
  final List<BoxShadow> shadowLg;

  /// Alias of [shadowSm].
  List<BoxShadow> get shadowSegment => shadowSm;

  /// Alias of [shadowLg].
  List<BoxShadow> get shadowFloating => shadowLg;

  /// Primary-button shadow: a tight contact shadow plus a soft accent glow.
  List<BoxShadow> get shadowPrimaryButton => [
    const BoxShadow(
      color: Color(0x24000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: accent.withValues(alpha: 0.45),
      blurRadius: 24,
      spreadRadius: -10,
      offset: const Offset(0, 10),
    ),
  ];

  // ── ThemeExtension ─────────────────────────────────────────────────────────

  @override
  AppTokens copyWith({
    Color? accent,
    Color? onAccent,
    Color? accentInk,
    Color? accentTint,
    Color? canvas,
    Color? surface,
    Color? surfaceMuted,
    Color? onSurface,
    Color? body,
    Color? onSurfaceMuted,
    Color? subtle,
    Color? hairline,
    Color? hairlineSoft,
    Color? hairlineStrong,
    Color? divider,
    Color? success,
    Color? successTint,
    Color? warning,
    Color? warningTint,
    Color? danger,
    Color? dangerTint,
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
    double? radiusSegment,
    double? radiusMedia,
    double? radiusSheet,
    TextStyle? displayStyle,
    TextStyle? headlineStyle,
    TextStyle? titleStyle,
    TextStyle? title3Style,
    TextStyle? titleSmStyle,
    TextStyle? bodyStyle,
    TextStyle? calloutStyle,
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
      onAccent: onAccent ?? this.onAccent,
      accentInk: accentInk ?? this.accentInk,
      accentTint: accentTint ?? this.accentTint,
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      onSurface: onSurface ?? this.onSurface,
      body: body ?? this.body,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      subtle: subtle ?? this.subtle,
      hairline: hairline ?? this.hairline,
      hairlineSoft: hairlineSoft ?? this.hairlineSoft,
      hairlineStrong: hairlineStrong ?? this.hairlineStrong,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      successTint: successTint ?? this.successTint,
      warning: warning ?? this.warning,
      warningTint: warningTint ?? this.warningTint,
      danger: danger ?? this.danger,
      dangerTint: dangerTint ?? this.dangerTint,
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
      radiusSegment: radiusSegment ?? this.radiusSegment,
      radiusMedia: radiusMedia ?? this.radiusMedia,
      radiusSheet: radiusSheet ?? this.radiusSheet,
      displayStyle: displayStyle ?? this.displayStyle,
      headlineStyle: headlineStyle ?? this.headlineStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      title3Style: title3Style ?? this.title3Style,
      titleSmStyle: titleSmStyle ?? this.titleSmStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      calloutStyle: calloutStyle ?? this.calloutStyle,
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
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentInk: Color.lerp(accentInk, other.accentInk, t)!,
      accentTint: Color.lerp(accentTint, other.accentTint, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      body: Color.lerp(body, other.body, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
      subtle: Color.lerp(subtle, other.subtle, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      hairlineSoft: Color.lerp(hairlineSoft, other.hairlineSoft, t)!,
      hairlineStrong: Color.lerp(hairlineStrong, other.hairlineStrong, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      successTint: Color.lerp(successTint, other.successTint, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningTint: Color.lerp(warningTint, other.warningTint, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerTint: Color.lerp(dangerTint, other.dangerTint, t)!,
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
      radiusSegment: radiusSegment,
      radiusMedia: radiusMedia,
      radiusSheet: radiusSheet,
      displayStyle: TextStyle.lerp(displayStyle, other.displayStyle, t)!,
      headlineStyle: TextStyle.lerp(headlineStyle, other.headlineStyle, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
      title3Style: TextStyle.lerp(title3Style, other.title3Style, t)!,
      titleSmStyle: TextStyle.lerp(titleSmStyle, other.titleSmStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      calloutStyle: TextStyle.lerp(calloutStyle, other.calloutStyle, t)!,
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
