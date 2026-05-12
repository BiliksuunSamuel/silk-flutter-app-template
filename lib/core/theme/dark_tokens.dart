import 'package:flutter/material.dart';
import 'package:silk/core/theme/tokens.dart';

const AppTokens darkTokens = AppTokens(
  // Colors
  accent: Color(0xFF7B8BFF),
  surface: Color(0xFF0F0F17),
  surfaceMuted: Color(0xFF1A1A26),
  onSurface: Color(0xFFEEEEF5),
  onSurfaceMuted: Color(0xFF8888A2),
  divider: Color(0xFF2A2A3A),
  danger: Color(0xFFEF5350),
  success: Color(0xFF66BB6A),

  // Spacing — identical across modes
  spaceXs: 4,
  spaceSm: 8,
  spaceMd: 16,
  spaceLg: 24,
  spaceXl: 32,
  spaceXxl: 48,

  // Radii — identical across modes
  radiusSm: 6,
  radiusMd: 12,
  radiusLg: 20,
  radiusPill: 100,

  // Typography
  displayStyle: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
    color: Color(0xFFEEEEF5),
  ),
  titleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
    color: Color(0xFFEEEEF5),
  ),
  bodyStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFFEEEEF5),
  ),
  captionStyle: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.1,
    color: Color(0xFF8888A2),
  ),
  monoStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'monospace',
    height: 1.5,
    color: Color(0xFFEEEEF5),
  ),

  // Elevation shadows (darker base — more subtle)
  shadowSm: [
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ],
  shadowMd: [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ],
  shadowLg: [
    BoxShadow(
      color: Color(0x44000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x22000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
);
