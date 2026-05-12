import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silk/core/extensions/dimension_extensions.dart';

/// The canonical type scale for Silk, built on Inter.
///
/// All methods accept a [color] so light/dark tokens stay in control of
/// theming — the typography class owns nothing but shape.
///
/// Font sizes use [.sp] and letter spacing uses [.ls] — both delegate to
/// [SilkSizer] so they scale proportionally to the physical screen width.
/// Line-height ([height]) is intentionally kept as a plain ratio: it is already
/// relative to [fontSize], so scaling it would produce a ratio² effect on the
/// actual line height in pixels, making text feel bloated. [SilkApp] updates
/// [SilkSizer.screenWidth] before evaluating tokens, so no [BuildContext] is
/// needed here.
///
/// Scale reference (size / weight / tracking):
/// ```text
/// display   32  w700  -0.5  hero text
/// headline  24  w600  -0.3  page titles
/// title     20  w600  -0.2  section headings
/// titleSm   17  w600   0    nav titles, prominent list items
/// body      16  w400   0    standard reading text
/// bodySm    14  w400   0    dense content, secondary body
/// label     13  w500   0.1  chips, badges, button labels
/// caption   12  w400   0.1  helper text, timestamps
/// overline  11  w600   1.0  section dividers (often uppercased)
/// mono      14  w400   0    code, OTP, numeric fields
/// ```
abstract final class AppTypography {
  static TextStyle display({required Color color}) => GoogleFonts.inter(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: (-0.5).ls,
        color: color,
      );

  static TextStyle headline({required Color color}) => GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: (-0.3).ls,
        color: color,
      );

  static TextStyle title({required Color color}) => GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: (-0.2).ls,
        color: color,
      );

  static TextStyle titleSm({required Color color}) => GoogleFonts.inter(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color,
      );

  static TextStyle body({required Color color}) => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodySm({required Color color}) => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle label({required Color color}) => GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1.ls,
        color: color,
      );

  static TextStyle caption({required Color color}) => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.1.ls,
        color: color,
      );

  static TextStyle overline({required Color color}) => GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 1.ls,
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
