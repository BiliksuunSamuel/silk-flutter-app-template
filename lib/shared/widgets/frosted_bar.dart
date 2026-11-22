import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Frosted material for navigation bars, tab bars and composers: content
/// scrolls underneath and is blurred.
///
/// Falls back to an opaque canvas colour when [MediaQuery.highContrastOf] is
/// true (or [blur] is false — use for low-end Android).
///
/// [showHairline] draws the 0.5px edge hairline; pass `true` only once content
/// has scrolled under the bar so it is seamless at rest.
class FrostedBar extends StatelessWidget {
  const FrostedBar({
    required this.child,
    this.top = true,
    this.showHairline = true,
    this.blur = true,
    super.key,
  });

  final Widget child;

  /// True for top bars (hairline on the bottom edge), false for bottom bars.
  final bool top;
  final bool showHairline;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final useBlur = blur && !MediaQuery.highContrastOf(context);

    final border = showHairline
        ? Border(
            bottom: top
                ? BorderSide(color: t.hairline, width: 0.5)
                : BorderSide.none,
            top: top
                ? BorderSide.none
                : BorderSide(color: t.hairline, width: 0.5),
          )
        : null;

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: t.canvas.withValues(alpha: useBlur ? 0.78 : 1),
        border: border,
      ),
      child: child,
    );

    if (!useBlur) return bar;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: bar,
      ),
    );
  }
}
