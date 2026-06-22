import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/motion/scroll_physics.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkCarousel extends StatefulWidget {
  const SilkCarousel({
    required this.children,
    this.height = 200,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.viewportFraction = 1.0,
    this.showIndicator = true,
    this.onPageChanged,
    super.key,
  });

  final List<Widget> children;
  final double height;

  /// Automatically advance pages.
  final bool autoPlay;
  final Duration autoPlayInterval;

  /// 1.0 = full width, 0.85 = peek adjacent cards.
  final double viewportFraction;

  final bool showIndicator;
  final void Function(int index)? onPageChanged;

  @override
  State<SilkCarousel> createState() => _SilkCarouselState();
}

class _SilkCarouselState extends State<SilkCarousel> {
  late final PageController _ctrl;
  Timer? _autoPlayTimer;
  int _current = 0;
  int _autoStep = 1; // auto-play direction for ping-pong

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: widget.viewportFraction);
    if (widget.autoPlay && widget.children.length > 1) {
      // A cancellable periodic timer (cancelled in dispose) — avoids leaking a
      // pending timer when the widget is torn down.
      _autoPlayTimer = Timer.periodic(widget.autoPlayInterval, _advance);
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _advance(Timer _) {
    if (!mounted || !_ctrl.hasClients) return;
    final count = widget.children.length;
    if (count < 2) return;

    // Ping-pong (0→1→2→1→0…) so we never sweep all the way back across the
    // slides on wrap — each tick moves exactly one page.
    var next = _current + _autoStep;
    if (next >= count) {
      _autoStep = -1;
      next = _current - 1;
    } else if (next < 0) {
      _autoStep = 1;
      next = _current + 1;
    }
    _ctrl.animateToPage(
      next,
      duration: MotionTokens.emphasized,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _ctrl,
            // Firm page-snap: no overscroll bounce, no settle overshoot.
            physics: const FirmPageScrollPhysics(parent: ClampingScrollPhysics()),
            itemCount: widget.children.length,
            onPageChanged: (i) {
              setState(() => _current = i);
              widget.onPageChanged?.call(i);
            },
            itemBuilder: (_, i) => Padding(
              padding: widget.viewportFraction < 1
                  ? EdgeInsets.symmetric(horizontal: tokens.spaceSm)
                  : EdgeInsets.zero,
              child: widget.children[i],
            ),
          ),
        ),
        if (widget.showIndicator && widget.children.length > 1) ...[
          SizedBox(height: tokens.spaceXs),
          _DotIndicator(
            count: widget.children.length,
            current: _current,
          ),
        ],
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: MotionTokens.standard,
          curve: MotionTokens.emphasizedDecel,
          margin: EdgeInsets.symmetric(horizontal: tokens.spaceXs / 2),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? tokens.accent : tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(tokens.radiusPill),
          ),
        );
      }),
    );
  }
}
