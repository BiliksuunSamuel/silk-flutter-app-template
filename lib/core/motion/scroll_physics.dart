import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class SilkScrollPhysics extends BouncingScrollPhysics {
  const SilkScrollPhysics({super.parent});

  @override
  SilkScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SilkScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 50;

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 0.5,
        stiffness: 120,
        damping: 1.1,
      );

  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}
