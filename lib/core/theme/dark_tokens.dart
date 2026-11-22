import 'package:flutter/material.dart';
import 'package:silk/core/theme/app_typography.dart';
import 'package:silk/core/theme/color_contrast.dart';
import 'package:silk/core/theme/tokens.dart';

/// Brand accent — the single swappable slot. `onAccent`, `accentInk` and
/// `accentTint` are derived from it so any accent stays accessible.
const Color kDarkAccent = Color(0xFF7B8BFF);
const Color kDarkSurface = Color(0xFF1C1C1E);

AppTokens get darkTokens => AppTokens(
  // ── Colors ─────────────────────────────────────────────────────────────────
  accent: kDarkAccent,
  onAccent: ColorContrast.onAccent(kDarkAccent),
  accentInk: ColorContrast.accentInk(kDarkAccent, background: kDarkSurface),
  accentTint: kDarkAccent.withValues(alpha: 0.16),
  canvas: const Color(0xFF000000),
  surface: kDarkSurface,
  surfaceMuted: const Color(0xFF2C2C2E),
  onSurface: const Color(0xFFF5F5F7),
  body: const Color(0xFFD1D1D6),
  onSurfaceMuted: const Color(0xFF98989F),
  subtle: const Color(0xFF8E8E96),
  hairline: const Color(0x1AFFFFFF),
  hairlineSoft: const Color(0x14FFFFFF),
  hairlineStrong: const Color(0x29FFFFFF),
  divider: const Color(0x1AFFFFFF),
  success: const Color(0xFF34C77B),
  successTint: const Color(0x1A34C77B),
  warning: const Color(0xFFFFB340),
  warningTint: const Color(0x1AFFB340),
  danger: const Color(0xFFFF6B63),
  dangerTint: const Color(0x1AFF6B63),

  // ── Spacing — identical across modes ──────────────────────────────────────
  spaceXs: 4,
  spaceSm: 8,
  spaceMd: 16,
  spaceLg: 24,
  spaceXl: 32,
  spaceXxl: 56,

  // ── Radii — identical across modes ────────────────────────────────────────
  radiusSm: 6,
  radiusMd: 12,
  radiusLg: 20,
  radiusPill: 999,
  radiusSegment: 9,
  radiusMedia: 16,
  radiusSheet: 28,

  // ── Typography — Inter ─────────────────────────────────────────────────────
  displayStyle: AppTypography.display(color: const Color(0xFFF5F5F7)),
  headlineStyle: AppTypography.headline(color: const Color(0xFFF5F5F7)),
  titleStyle: AppTypography.title(color: const Color(0xFFF5F5F7)),
  title3Style: AppTypography.title3(color: const Color(0xFFF5F5F7)),
  titleSmStyle: AppTypography.titleSm(color: const Color(0xFFF5F5F7)),
  bodyStyle: AppTypography.body(color: const Color(0xFFD1D1D6)),
  calloutStyle: AppTypography.callout(color: const Color(0xFFD1D1D6)),
  bodySmStyle: AppTypography.bodySm(color: const Color(0xFFD1D1D6)),
  labelStyle: AppTypography.label(color: const Color(0xFF98989F)),
  captionStyle: AppTypography.caption(color: const Color(0xFF98989F)),
  overlineStyle: AppTypography.overline(color: const Color(0xFF98989F)),
  monoStyle: AppTypography.mono(color: const Color(0xFFF5F5F7)),

  // ── Elevation — floating things only ───────────────────────────────────────
  shadowSm: const [
    BoxShadow(color: Color(0x40000000), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 10,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ],
  shadowMd: const [
    BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 40,
      spreadRadius: -12,
      offset: Offset(0, 16),
    ),
  ],
  shadowLg: const [
    BoxShadow(color: Color(0x40000000), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 40,
      spreadRadius: -12,
      offset: Offset(0, 16),
    ),
  ],
);
