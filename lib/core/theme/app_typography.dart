import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silk/core/extensions/dimension_extensions.dart';

/// The canonical type scale for Silk, built on Inter — the Solid UI scale.
///
/// All methods accept a [color] so light/dark tokens stay in control of
/// theming — the typography class owns nothing but shape.
///
/// Font sizes use [.sp] and letter spacing uses [.ls] — both delegate to
/// [SilkSizer] so they scale proportionally to the physical screen width.
/// Line-height ([height]) is a plain ratio (lineHeight / fontSize): it is
/// already relative to [fontSize], so scaling it again would bloat the text.
/// [SilkApp] updates [SilkSizer.screenWidth] before evaluating tokens, so no
/// [BuildContext] is needed here.
///
/// Scale reference (size / line height, weight, tracking):
/// ```text
/// display   34/40  w700  -0.6  largeTitle — top-level screen titles
/// headline  28/34  w700  -0.4  title1     — sheet titles, empty states
/// title     22/28  w700  -0.3  title2     — section titles
/// title3    20/25  w600  -0.2             — card titles, amounts
/// titleSm   17/22  w600  -0.2  headline   — row titles, buttons
/// body      17/24  w400  -0.2             — messages, paragraphs
/// callout   16/21  w400  -0.1             — secondary paragraphs
/// bodySm    15/20  w400   0    subhead    — row subtitles
/// label     13/18  w500   0    footnote   — metadata, helper text, chips
/// caption   12/16  w500   0               — timestamps, pill labels
/// overline  11/13  w600  +0.6  UPPERCASE  — rare: grouped-list headers
/// mono      14/21  w400   0               — code, OTP, identifiers
/// ```
///
/// Use [tabular] on any style that shows aligned figures (money, times,
/// counts).
abstract final class AppTypography {
  static TextStyle _inter({
    required double size,
    required double lineHeight,
    required FontWeight weight,
    required double tracking,
    required Color color,
  }) => GoogleFonts.inter(
    fontSize: size.sp,
    fontWeight: weight,
    height: lineHeight / size,
    letterSpacing: tracking.ls,
    color: color,
  );

  /// Same style with tabular (fixed-width) figures — for money, times, counts.
  static TextStyle tabular(TextStyle style) =>
      style.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  static TextStyle display({required Color color}) => _inter(
    size: 34,
    lineHeight: 40,
    weight: FontWeight.w700,
    tracking: -0.6,
    color: color,
  );

  static TextStyle headline({required Color color}) => _inter(
    size: 28,
    lineHeight: 34,
    weight: FontWeight.w700,
    tracking: -0.4,
    color: color,
  );

  static TextStyle title({required Color color}) => _inter(
    size: 22,
    lineHeight: 28,
    weight: FontWeight.w700,
    tracking: -0.3,
    color: color,
  );

  static TextStyle title3({required Color color}) => _inter(
    size: 20,
    lineHeight: 25,
    weight: FontWeight.w600,
    tracking: -0.2,
    color: color,
  );

  static TextStyle titleSm({required Color color}) => _inter(
    size: 17,
    lineHeight: 22,
    weight: FontWeight.w600,
    tracking: -0.2,
    color: color,
  );

  static TextStyle body({required Color color}) => _inter(
    size: 17,
    lineHeight: 24,
    weight: FontWeight.w400,
    tracking: -0.2,
    color: color,
  );

  static TextStyle callout({required Color color}) => _inter(
    size: 16,
    lineHeight: 21,
    weight: FontWeight.w400,
    tracking: -0.1,
    color: color,
  );

  static TextStyle bodySm({required Color color}) => _inter(
    size: 15,
    lineHeight: 20,
    weight: FontWeight.w400,
    tracking: 0,
    color: color,
  );

  static TextStyle label({required Color color}) => _inter(
    size: 13,
    lineHeight: 18,
    weight: FontWeight.w500,
    tracking: 0,
    color: color,
  );

  static TextStyle caption({required Color color}) => _inter(
    size: 12,
    lineHeight: 16,
    weight: FontWeight.w500,
    tracking: 0,
    color: color,
  );

  static TextStyle overline({required Color color}) => _inter(
    size: 11,
    lineHeight: 13,
    weight: FontWeight.w600,
    tracking: 0.6,
    color: color,
  );

  /// JetBrains Mono for code, OTP fields, numeric identifiers.
  static TextStyle mono({required Color color}) => GoogleFonts.jetBrainsMono(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );
}
