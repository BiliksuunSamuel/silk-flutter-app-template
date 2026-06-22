import 'package:flutter/widgets.dart';

/// Page physics that snap firmly with NO overscroll bounce or settle overshoot.
/// Use for carousels/onboarding where the springy default feels destructive.
class FirmPageScrollPhysics extends PageScrollPhysics {
  const FirmPageScrollPhysics({super.parent});

  @override
  FirmPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FirmPageScrollPhysics(parent: buildParent(ancestor));
  }

  // Critically damped (damping ≈ 2·√(mass·stiffness)) → quick, no bounce.
  @override
  SpringDescription get spring => const SpringDescription(
        mass: 1,
        stiffness: 300,
        damping: 35,
      );
}

class SilkScrollPhysics extends BouncingScrollPhysics {
  const SilkScrollPhysics({super.parent});

  @override
  SilkScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SilkScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 50;

  // `damping` on SpringDescription is the raw coefficient, NOT the ratio —
  // a raw 1.1 here (critical ≈ 2·√(0.5·120) ≈ 15.5) is ~93% under-damped and
  // wobbles at the end of a fling. Use a damping *ratio* just over 1 so the
  // scroll settles cleanly while keeping the iOS edge bounce.
  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 120,
        ratio: 1.1,
      );

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}
