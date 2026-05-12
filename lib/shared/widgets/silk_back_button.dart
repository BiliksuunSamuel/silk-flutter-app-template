import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkBackButton extends StatefulWidget {
  const SilkBackButton({this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  State<SilkBackButton> createState() => _SilkBackButtonState();
}

class _SilkBackButtonState extends State<SilkBackButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Haptics.light();
        if (widget.onPressed != null) {
          widget.onPressed!();
        } else if (context.canPop()) {
          context.pop();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: MotionTokens.micro,
        curve: MotionTokens.sharp,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(tokens.radiusPill),
          ),
          alignment: Alignment.center,
          child: Icon(
            isIOS ? Icons.chevron_left : Icons.arrow_back,
            color: tokens.onSurface,
            size: isIOS ? 22 : 20,
          ),
        ),
      ),
    );
  }
}
