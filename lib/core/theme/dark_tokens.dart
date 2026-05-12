import 'package:flutter/material.dart';
import 'package:silk/core/theme/app_typography.dart';
import 'package:silk/core/theme/tokens.dart';

AppTokens get darkTokens => AppTokens(
  // ── Colors ─────────────────────────────────────────────────────────────────
  accent: const Color(0xFF7B8BFF),
  surface: const Color(0xFF0F0F17),
  surfaceMuted: const Color(0xFF1A1A26),
  onSurface: const Color(0xFFEEEEF5),
  onSurfaceMuted: const Color(0xFF8888A2),
  divider: const Color(0xFF2A2A3A),
  danger: const Color(0xFFEF5350),
  success: const Color(0xFF66BB6A),

  // ── Spacing — identical across modes ──────────────────────────────────────
  spaceXs: 4,
  spaceSm: 8,
  spaceMd: 16,
  spaceLg: 24,
  spaceXl: 32,
  spaceXxl: 48,

  // ── Radii — identical across modes ────────────────────────────────────────
  radiusSm: 6,
  radiusMd: 12,
  radiusLg: 20,
  radiusPill: 100,

  // ── Typography — Inter ─────────────────────────────────────────────────────
  displayStyle: AppTypography.display(color: const Color(0xFFEEEEF5)),
  headlineStyle: AppTypography.headline(color: const Color(0xFFEEEEF5)),
  titleStyle: AppTypography.title(color: const Color(0xFFEEEEF5)),
  titleSmStyle: AppTypography.titleSm(color: const Color(0xFFEEEEF5)),
  bodyStyle: AppTypography.body(color: const Color(0xFFEEEEF5)),
  bodySmStyle: AppTypography.bodySm(color: const Color(0xFFEEEEF5)),
  labelStyle: AppTypography.label(color: const Color(0xFFEEEEF5)),
  captionStyle: AppTypography.caption(color: const Color(0xFF8888A2)),
  overlineStyle: AppTypography.overline(color: const Color(0xFF8888A2)),
  monoStyle: AppTypography.mono(color: const Color(0xFFEEEEF5)),

  // ── Elevation shadows — darker base, more subtle ──────────────────────────
  shadowSm: const [
    BoxShadow(color: Color(0x22000000), blurRadius: 4, offset: Offset(0, 1)),
  ],
  shadowMd: const [
    BoxShadow(color: Color(0x33000000), blurRadius: 12, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 1)),
  ],
  shadowLg: const [
    BoxShadow(color: Color(0x44000000), blurRadius: 24, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 2)),
  ],
);
