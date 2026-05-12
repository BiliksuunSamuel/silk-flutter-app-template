import 'package:flutter/material.dart';
import 'package:silk/core/motion/scroll_physics.dart';

class SilkScrollBehavior extends ScrollBehavior {
  const SilkScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const SilkScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
