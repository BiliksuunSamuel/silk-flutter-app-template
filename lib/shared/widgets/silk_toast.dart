import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkToastVariant { success, error, warning, info }

abstract final class SilkToast {
  static OverlayEntry? _current;

  static void show(
    BuildContext context,
    String message, {
    SilkToastVariant variant = SilkToastVariant.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _current?.remove();
    _current = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _SilkToastEntry(
        message: message,
        variant: variant,
        duration: duration,
        onDismiss: () {
          if (entry.mounted) entry.remove();
          if (identical(_current, entry)) _current = null;
        },
      ),
    );
    Overlay.of(context).insert(entry);
    _current = entry;
  }
}

class _SilkToastEntry extends StatefulWidget {
  const _SilkToastEntry({
    required this.message,
    required this.variant,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final SilkToastVariant variant;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_SilkToastEntry> createState() => _SilkToastEntryState();
}

class _SilkToastEntryState extends State<_SilkToastEntry>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final AnimationController _exitCtrl;

  late final Animation<double> _entryY;
  late final Animation<double> _entryScale;
  late final Animation<double> _entryOpacity;
  late final Animation<double> _exitY;
  late final Animation<double> _exitOpacity;

  bool _dismissing = false;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _exitCtrl = AnimationController(vsync: this, duration: MotionTokens.fast);

    _entryY = Tween<double>(begin: 64, end: 0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: MotionTokens.emphasizedDecel),
    );
    _entryScale =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.86, end: 1.04), weight: 60),
          TweenSequenceItem(tween: Tween(begin: 1.04, end: 1), weight: 40),
        ]).animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: MotionTokens.emphasizedDecel,
          ),
        );
    _entryOpacity = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0, 0.35, curve: Curves.easeOut),
    );

    _exitY = Tween<double>(
      begin: 0,
      end: 18,
    ).animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));
    _exitOpacity = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));

    _entryCtrl.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    setState(() => _dismissing = true);
    await _exitCtrl.forward();
    if (mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bottom = MediaQuery.of(context).viewPadding.bottom + 48;

    // Solid UI toast: an ink (inverted) capsule — the variant only tints the
    // leading icon, so status is never colour-only (icon + message).
    final bg = tokens.onSurface.withValues(alpha: 0.92);
    final fg = tokens.surface;
    final (iconColor, iconData) = switch (widget.variant) {
      SilkToastVariant.success => (tokens.success, Icons.check_circle_outline),
      SilkToastVariant.error => (tokens.danger, Icons.error_outline),
      SilkToastVariant.warning => (
        tokens.warning,
        Icons.warning_amber_outlined,
      ),
      SilkToastVariant.info => (fg, Icons.info_outline),
    };

    final listenable = Listenable.merge([_entryCtrl, _exitCtrl]);

    return Positioned(
      bottom: bottom,
      left: tokens.spaceMd,
      right: tokens.spaceMd,
      child: AnimatedBuilder(
        animation: listenable,
        builder: (_, child) {
          final translateY = _dismissing ? _exitY.value : _entryY.value;
          final opacity = _dismissing
              ? _exitOpacity.value
              : _entryOpacity.value;
          final scale = _dismissing ? 1.0 : _entryScale.value;

          return Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, translateY),
              child: Transform.scale(scale: scale, child: child),
            ),
          );
        },
        child: GestureDetector(
          onTap: _dismiss,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: tokens.shadowFloating,
              ),
              child: Row(
                children: [
                  SizedBox(width: tokens.spaceMd - 2),
                  Icon(iconData, color: iconColor, size: 20),
                  SizedBox(width: tokens.spaceSm + 2),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: tokens.spaceSm + tokens.spaceXs,
                      ),
                      child: Text(
                        widget.message,
                        style: tokens.bodySmStyle.copyWith(color: fg),
                      ),
                    ),
                  ),
                  SizedBox(width: tokens.spaceSm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
