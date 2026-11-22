import 'package:flutter/material.dart';
import 'package:silk/core/theme/app_typography.dart';
import 'package:silk/core/theme/color_contrast.dart';
import 'package:silk/core/theme/tokens.dart';

/// Brand accent — the single swappable slot. `onAccent`, `accentInk` and
/// `accentTint` are derived from it so any accent stays accessible.
const Color kLightAccent = Color(0xFF5466F5);
const Color kLightSurface = Color(0xFFFFFFFF);

AppTokens get lightTokens => AppTokens(
  // ── Colors ─────────────────────────────────────────────────────────────────
  accent: kLightAccent,
  onAccent: ColorContrast.onAccent(kLightAccent),
  accentInk: ColorContrast.accentInk(kLightAccent, background: kLightSurface),
  accentTint: kLightAccent.withValues(alpha: 0.1),
  canvas: const Color(0xFFF7F7F8),
  surface: kLightSurface,
  surfaceMuted: const Color(0xFFF1F1F3),
  onSurface: const Color(0xFF111114),
  body: const Color(0xFF3C3C43),
  onSurfaceMuted: const Color(0xFF6B6B73),
  subtle: const Color(0xFF8A8A93),
  hairline: const Color(0x14000000),
  hairlineSoft: const Color(0x0F000000),
  hairlineStrong: const Color(0x1F000000),
  divider: const Color(0x14000000),
  success: const Color(0xFF1E9E5A),
  successTint: const Color(0xFFE7F5EC),
  warning: const Color(0xFFC27A00),
  warningTint: const Color(0xFFFFF4E0),
  danger: const Color(0xFFD92D20),
  dangerTint: const Color(0xFFFDECEA),

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
  displayStyle: AppTypography.display(color: const Color(0xFF111114)),
  headlineStyle: AppTypography.headline(color: const Color(0xFF111114)),
  titleStyle: AppTypography.title(color: const Color(0xFF111114)),
  title3Style: AppTypography.title3(color: const Color(0xFF111114)),
  titleSmStyle: AppTypography.titleSm(color: const Color(0xFF111114)),
  bodyStyle: AppTypography.body(color: const Color(0xFF3C3C43)),
  calloutStyle: AppTypography.callout(color: const Color(0xFF3C3C43)),
  bodySmStyle: AppTypography.bodySm(color: const Color(0xFF3C3C43)),
  labelStyle: AppTypography.label(color: const Color(0xFF6B6B73)),
  captionStyle: AppTypography.caption(color: const Color(0xFF6B6B73)),
  overlineStyle: AppTypography.overline(color: const Color(0xFF6B6B73)),
  monoStyle: AppTypography.mono(color: const Color(0xFF111114)),

  // ── Elevation — floating things only ───────────────────────────────────────
  shadowSm: const [
    BoxShadow(color: Color(0x1A000000), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 10,
      spreadRadius: -4,
      offset: Offset(0, 4),
    ),
  ],
  shadowMd: const [
    BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 40,
      spreadRadius: -12,
      offset: Offset(0, 16),
    ),
  ],
  shadowLg: const [
    BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 40,
      spreadRadius: -12,
      offset: Offset(0, 16),
    ),
  ],
);
