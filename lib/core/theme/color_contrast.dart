import 'package:flutter/painting.dart';

/// WCAG contrast helpers used to derive accent-dependent colors.
///
/// Solid UI rule: every accent must be checked against its backgrounds.
///  - [onAccent] picks white or black text, whichever reaches ≥ 4.5:1.
///  - [accentInk] darkens (light mode) or lightens (dark mode) the accent
///    until it reaches ≥ 4.5:1 as *text* on [background].
abstract final class ColorContrast {
  static const double minTextRatio = 4.5;

  /// WCAG contrast ratio between two opaque colors (1.0 – 21.0).
  static double ratio(Color a, Color b) {
    final la = a.computeLuminance();
    final lb = b.computeLuminance();
    final hi = la > lb ? la : lb;
    final lo = la > lb ? lb : la;
    return (hi + 0.05) / (lo + 0.05);
  }

  /// White or black — whichever gives the better contrast on [accent].
  static Color onAccent(Color accent) {
    const white = Color(0xFFFFFFFF);
    const black = Color(0xFF000000);
    if (ratio(accent, white) >= minTextRatio) return white;
    return ratio(accent, black) > ratio(accent, white) ? black : white;
  }

  /// [accent] adjusted in HSL lightness until it reads at ≥ 4.5:1 on
  /// [background]. Returns [accent] untouched when it already passes.
  static Color accentInk(Color accent, {required Color background}) {
    if (ratio(accent, background) >= minTextRatio) return accent;
    final hsl = HSLColor.fromColor(accent);
    final darken = background.computeLuminance() > 0.5;
    var l = hsl.lightness;
    for (var i = 0; i < 100; i++) {
      l = (darken ? l - 0.01 : l + 0.01).clamp(0.0, 1.0);
      final candidate = hsl.withLightness(l).toColor();
      if (ratio(candidate, background) >= minTextRatio) return candidate;
    }
    return hsl.withLightness(darken ? 0 : 1).toColor();
  }
}
