import 'package:flutter/material.dart';
import 'package:silk/core/theme/app_typography.dart';
import 'package:silk/core/theme/tokens.dart';

AppTokens get lightTokens => AppTokens(
  // ── Colors ─────────────────────────────────────────────────────────────────
  accent: const Color(0xFF5B6CF5),
  surface: const Color(0xFFFAFAFC),
  surfaceMuted: const Color(0xFFF0F0F5),
  onSurface: const Color(0xFF0D0D1A),
  onSurfaceMuted: const Color(0xFF6B6B82),
  divider: const Color(0xFFE8E8EF),
  danger: const Color(0xFFE53935),
  success: const Color(0xFF43A047),

  // ── Spacing ────────────────────────────────────────────────────────────────
  spaceXs: 4,
  spaceSm: 8,
  spaceMd: 16,
  spaceLg: 24,
  spaceXl: 32,
  spaceXxl: 48,

  // ── Radii ──────────────────────────────────────────────────────────────────
  radiusSm: 6,
  radiusMd: 12,
  radiusLg: 20,
  radiusPill: 100,

  // ── Typography — Inter ─────────────────────────────────────────────────────
  displayStyle: AppTypography.display(color: const Color(0xFF0D0D1A)),
  headlineStyle: AppTypography.headline(color: const Color(0xFF0D0D1A)),
  titleStyle: AppTypography.title(color: const Color(0xFF0D0D1A)),
  titleSmStyle: AppTypography.titleSm(color: const Color(0xFF0D0D1A)),
  bodyStyle: AppTypography.body(color: const Color(0xFF0D0D1A)),
  bodySmStyle: AppTypography.bodySm(color: const Color(0xFF0D0D1A)),
  labelStyle: AppTypography.label(color: const Color(0xFF0D0D1A)),
  captionStyle: AppTypography.caption(color: const Color(0xFF6B6B82)),
  overlineStyle: AppTypography.overline(color: const Color(0xFF6B6B82)),
  monoStyle: AppTypography.mono(color: const Color(0xFF0D0D1A)),

  // ── Elevation shadows ──────────────────────────────────────────────────────
  shadowSm: const [
    BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1)),
  ],
  shadowMd: const [
    BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
  ],
  shadowLg: const [
    BoxShadow(color: Color(0x18000000), blurRadius: 24, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
  ],
);
