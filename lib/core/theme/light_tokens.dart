import 'package:flutter/material.dart';
import 'package:silk/core/theme/tokens.dart';

const AppTokens lightTokens = AppTokens(
  // Colors
  accent: Color(0xFF5B6CF5),
  surface: Color(0xFFFAFAFC),
  surfaceMuted: Color(0xFFF0F0F5),
  onSurface: Color(0xFF0D0D1A),
  onSurfaceMuted: Color(0xFF6B6B82),
  divider: Color(0xFFE8E8EF),
  danger: Color(0xFFE53935),
  success: Color(0xFF43A047),

  // Spacing
  spaceXs: 4,
  spaceSm: 8,
  spaceMd: 16,
  spaceLg: 24,
  spaceXl: 32,
  spaceXxl: 48,

  // Radii
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
    color: Color(0xFF0D0D1A),
  ),
  titleStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
    color: Color(0xFF0D0D1A),
  ),
  bodyStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Color(0xFF0D0D1A),
  ),
  captionStyle: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.1,
    color: Color(0xFF6B6B82),
  ),
  monoStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'monospace',
    height: 1.5,
    color: Color(0xFF0D0D1A),
  ),

  // Elevation shadows
  shadowSm: [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ],
  shadowMd: [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ],
  shadowLg: [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
);
