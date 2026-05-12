import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silk/core/motion/motion_tokens.dart';

// Replace transition — fade-through (out fades, in fades).
class FadePage<T> extends CustomTransitionPage<T> {
  FadePage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: MotionTokens.fast,
          reverseTransitionDuration: MotionTokens.fast,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: MotionTokens.standardCurve,
              ),
              child: child,
            );
          },
        );
}
