import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SilkGestureBack extends StatelessWidget {
  const SilkGestureBack({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // iOS handles edge swipe natively via the navigation system.
    if (defaultTargetPlatform == TargetPlatform.iOS) return child;

    return _AndroidEdgeSwipe(child: child);
  }
}

class _AndroidEdgeSwipe extends StatefulWidget {
  const _AndroidEdgeSwipe({required this.child});

  final Widget child;

  @override
  State<_AndroidEdgeSwipe> createState() => _AndroidEdgeSwipeState();
}

class _AndroidEdgeSwipeState extends State<_AndroidEdgeSwipe> {
  static const _edgeThreshold = 22.0;

  Offset? _dragStart;
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) {
        _dragStart = e.localPosition;
        _active = e.localPosition.dx < _edgeThreshold;
      },
      onPointerMove: (e) {
        if (!_active || _dragStart == null) return;
        final dx = e.localPosition.dx - _dragStart!.dx;
        final dy = (e.localPosition.dy - _dragStart!.dy).abs();

        if (dx > 20 && dx > dy * 1.5) {
          _active = false;
          _dragStart = null;
          if (context.canPop()) context.pop();
        }
      },
      onPointerUp: (_) {
        _dragStart = null;
        _active = false;
      },
      onPointerCancel: (_) {
        _dragStart = null;
        _active = false;
      },
      child: widget.child,
    );
  }
}
