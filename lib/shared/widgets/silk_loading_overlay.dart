import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/core/theme/tokens.dart';

/// Wraps [child] and dims it with a centered spinner when [isLoading] is true.
///
/// The overlay fills the exact bounds of [child] — no floating card.
/// For a full-screen block (e.g. during a network call), use the imperative
/// [SilkLoadingOverlay.show] / [SilkLoadingOverlay.hide] API instead.
class SilkLoadingOverlay extends StatelessWidget {
  const SilkLoadingOverlay({
    required this.child,
    required this.isLoading,
    this.label,
    super.key,
  });

  final Widget child;
  final bool isLoading;

  /// Optional status message shown below the spinner.
  final String? label;

  static OverlayEntry? _entry;

  /// Shows a floating full-screen loading card on top of the current route.
  static void show(BuildContext context, {String? label}) {
    if (_entry != null) return;
    final tokens = context.tokens;
    _entry = OverlayEntry(
      builder: (_) => _FloatingCard(label: label, tokens: tokens),
    );
    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final lbl = label;

    return Stack(
      children: [
        child,
        // Dims and blocks interaction — fills parent bounds, no nested card.
        AnimatedSwitcher(
          duration: MotionTokens.fast,
          child: isLoading
              ? Positioned.fill(
                  key: const ValueKey('overlay'),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.surface.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(tokens.radiusMd),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                tokens.accent,
                              ),
                            ),
                          ),
                          if (lbl != null) ...[
                            SizedBox(height: tokens.spaceSm),
                            Text(
                              lbl,
                              style: tokens.captionStyle.copyWith(
                                color: tokens.onSurfaceMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Full-screen floating card — used by show() / hide() ──────────────────────

class _FloatingCard extends StatelessWidget {
  const _FloatingCard({this.label, this.tokens});

  final String? label;
  final AppTokens? tokens;

  @override
  Widget build(BuildContext context) {
    final t = tokens ?? context.tokens;
    final lbl = label;

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.45),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(t.spaceLg),
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(t.radiusLg),
            boxShadow: t.shadowLg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(t.accent),
                ),
              ),
              if (lbl != null) ...[
                SizedBox(height: t.spaceMd),
                Text(
                  lbl,
                  style: t.bodySmStyle.copyWith(color: t.onSurfaceMuted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
