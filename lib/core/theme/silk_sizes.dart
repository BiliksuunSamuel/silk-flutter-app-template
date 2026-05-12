/// Icon size constants — use instead of raw numbers in [Icon] and [SvgPicture].
///
/// ```dart
/// Icon(Icons.star, size: SilkIconSize.md)
/// ```
abstract final class SilkIconSize {
  /// 14 px — inline micro icons, badges.
  static const double xs = 14;

  /// 18 px — compact list icons, trailing indicators.
  static const double sm = 18;

  /// 24 px — default Material icon size.
  static const double md = 24;

  /// 32 px — prominent icons, FAB icons.
  static const double lg = 32;

  /// 48 px — empty-state illustrations, onboarding icons.
  static const double xl = 48;

  /// 64 px — large hero icons.
  static const double xxl = 64;
}

/// Font size constants — mirrors the [AppTypography] scale as plain doubles
/// for cases where you need the number rather than a full [TextStyle].
///
/// Prefer [context.tokens.bodyStyle] etc. for actual text; use these for
/// size-only calculations (icon-to-text alignment, fixed heights, etc.).
abstract final class SilkFontSize {
  /// 11 px — overline, legal, very small labels.
  static const double xs = 11;

  /// 12 px — caption, timestamps, helper text.
  static const double sm = 12;

  /// 13 px — chips, badges, button labels.
  static const double label = 13;

  /// 14 px — dense body, secondary text.
  static const double bodySm = 14;

  /// 16 px — standard body text.
  static const double body = 16;

  /// 17 px — nav titles, prominent list items.
  static const double titleSm = 17;

  /// 20 px — section headings.
  static const double title = 20;

  /// 24 px — page titles.
  static const double headline = 24;

  /// 32 px — hero / display text.
  static const double display = 32;
}
