import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silk/core/motion/motion_tokens.dart';

// Default push transition — shared-axis horizontal.
class SharedAxisPage<T> extends CustomTransitionPage<T> {
  SharedAxisPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    SharedAxisTransitionType axisType = SharedAxisTransitionType.horizontal,
  }) : super(
          transitionDuration: MotionTokens.standard,
          reverseTransitionDuration: MotionTokens.standard,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: CurvedAnimation(
                parent: animation,
                curve: MotionTokens.emphasizedDecel,
                reverseCurve: MotionTokens.emphasizedAccel,
              ),
              secondaryAnimation: CurvedAnimation(
                parent: secondaryAnimation,
                curve: MotionTokens.emphasizedAccel,
                reverseCurve: MotionTokens.emphasizedDecel,
              ),
              transitionType: axisType,
              child: child,
            );
          },
        );
}
