import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Tap-to-reveal tooltip popover. Wrap any widget — an info icon,
/// a label, a question mark — and a popover appears above it on tap.
/// Tapping anywhere else (or the trigger again) dismisses it.
///
/// Usage:
/// ```dart
/// SilkTooltip(
///   message: 'This fee is charged by the payment processor.',
///   child: Icon(Icons.info_outline, size: 16),
/// )
/// ```
class SilkTooltip extends StatefulWidget {
  const SilkTooltip({
    required this.message,
    required this.child,
    this.maxWidth = 220,
    super.key,
  });

  final String message;
  final Widget child;
  final double maxWidth;

  @override
  State<SilkTooltip> createState() => _SilkTooltipState();
}

class _SilkTooltipState extends State<SilkTooltip>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  late AnimationController _ctrl;
  late Animation<double> _fade;
  final _link = LayerLink();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _remove();
    _ctrl.dispose();
    super.dispose();
  }

  void _show() {
    if (_entry != null) {
      _remove();
      return;
    }
    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (_) => _TooltipOverlay(
        link: _link,
        fade: _fade,
        message: widget.message,
        maxWidth: widget.maxWidth,
        onDismiss: _remove,
      ),
    );
    overlay.insert(_entry!);
    _ctrl.forward(from: 0);
  }

  void _remove() {
    _ctrl.reverse().then((_) {
      _entry?.remove();
      _entry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: _show,
        behavior: HitTestBehavior.opaque,
        child: widget.child,
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.link,
    required this.fade,
    required this.message,
    required this.maxWidth,
    required this.onDismiss,
  });

  final LayerLink link;
  final Animation<double> fade;
  final String message;
  final double maxWidth;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Stack(
      children: [
        // Full-screen dismiss tap target
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        CompositedTransformFollower(
          link: link,
          showWhenUnlinked: false,
          offset: const Offset(0, -8),
          targetAnchor: Alignment.topCenter,
          followerAnchor: Alignment.bottomCenter,
          child: FadeTransition(
            opacity: fade,
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spaceMd,
                  vertical: tokens.spaceSm,
                ),
                decoration: BoxDecoration(
                  color: tokens.onSurface,
                  borderRadius:
                      BorderRadius.circular(tokens.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: tokens.captionStyle.copyWith(
                    color: tokens.surface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
