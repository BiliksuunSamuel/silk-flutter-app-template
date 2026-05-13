import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
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
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController(viewportFraction: widget.viewportFraction);
    if (widget.autoPlay) _scheduleAutoPlay();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _scheduleAutoPlay() async {
    while (mounted) {
      await Future<void>.delayed(widget.autoPlayInterval);
      if (!mounted) break;
      final next = (_current + 1) % widget.children.length;
      await _ctrl.animateToPage(
        next,
        duration: MotionTokens.emphasized,
        curve: MotionTokens.emphasizedDecel,
      );
    }
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
          SizedBox(height: tokens.spaceMd),
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
