import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

abstract final class MotionTokens {
  // Durations
  static const Duration micro = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 240);
  static const Duration emphasized = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);

  // Curves — Material 3 emphasized set
  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve emphasizedDecel = Cubic(0.05, 0.7, 0.1, 1.0);
  static const Curve emphasizedAccel = Cubic(0.3, 0.0, 0.8, 0.15);
  static const Curve sharp = Cubic(0.4, 0.0, 0.6, 1.0);

  // Springs for sheets / FAB
  static const SpringDescription bouncy =
      SpringDescription(mass: 1, stiffness: 420, damping: 28);
  static const SpringDescription gentle =
      SpringDescription(mass: 1, stiffness: 280, damping: 24);
}
