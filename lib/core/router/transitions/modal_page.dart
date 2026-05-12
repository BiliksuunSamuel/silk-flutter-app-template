import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silk/core/motion/motion_tokens.dart';

// Modal transition — slides up from bottom with dimmed backdrop.
class ModalPage<T> extends CustomTransitionPage<T> {
  ModalPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.fullscreenDialog = true,
  }) : super(
          transitionDuration: MotionTokens.emphasized,
          reverseTransitionDuration: MotionTokens.emphasized,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide = CurvedAnimation(
              parent: animation,
              curve: MotionTokens.emphasizedDecel,
              reverseCurve: MotionTokens.emphasizedAccel,
            );
            final fade = CurvedAnimation(
              parent: animation,
              curve: const Interval(0, 0.3),
            );
            return Stack(
              children: [
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 0.4).animate(fade),
                  child: const ModalBarrier(color: Colors.black),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(slide),
                  child: child,
                ),
              ],
            );
          },
        );
}
