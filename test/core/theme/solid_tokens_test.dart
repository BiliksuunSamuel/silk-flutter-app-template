import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:silk/core/theme/color_contrast.dart';
import 'package:silk/core/theme/dark_tokens.dart';
import 'package:silk/core/theme/light_tokens.dart';

// Pure colour maths only — building full AppTokens pulls google_fonts, which
// needs network access, so these tests use the exported brand constants.
void main() {
  const modes = {
    'light': (kLightAccent, kLightSurface),
    'dark': (kDarkAccent, kDarkSurface),
  };

  group('Solid contrast rules (accent derived colours)', () {
    for (final MapEntry(key: mode, value: (accent, surface)) in modes.entries) {
      test('$mode: onAccent reaches 4.5:1 on accent', () {
        expect(
          ColorContrast.ratio(accent, ColorContrast.onAccent(accent)),
          greaterThanOrEqualTo(ColorContrast.minTextRatio),
        );
      });

      test('$mode: accentInk reaches 4.5:1 on surface', () {
        final ink = ColorContrast.accentInk(accent, background: surface);
        expect(
          ColorContrast.ratio(ink, surface),
          greaterThanOrEqualTo(ColorContrast.minTextRatio),
        );
      });
    }

    test('accentInk darkens a too-light accent on a light background', () {
      const pale = Color(0xFF9FA8FF);
      final ink = ColorContrast.accentInk(pale, background: Colors.white);
      expect(
        ColorContrast.ratio(ink, Colors.white),
        greaterThanOrEqualTo(ColorContrast.minTextRatio),
      );
    });

    test('accentInk lightens a too-dark accent on a dark background', () {
      const deep = Color(0xFF2A2F80);
      const bg = Color(0xFF1C1C1E);
      final ink = ColorContrast.accentInk(deep, background: bg);
      expect(
        ColorContrast.ratio(ink, bg),
        greaterThanOrEqualTo(ColorContrast.minTextRatio),
      );
    });

    test('onAccent picks black when white would fail', () {
      expect(
        ColorContrast.onAccent(const Color(0xFFFFD60A)),
        const Color(0xFF000000),
      );
    });
  });
}
