import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkBottomSheet extends StatelessWidget {
  const SilkBottomSheet({
    required this.child,
    this.title,
    this.showHandle = true,
    super.key,
  });

  final Widget child;
  final String? title;
  final bool showHandle;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: MotionTokens.emphasized,
        reverseDuration: MotionTokens.emphasized,
      ),
      builder: (_) => SilkBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(tokens.radiusLg),
        ),
        boxShadow: tokens.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            SizedBox(height: tokens.spaceMd),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.divider,
                borderRadius: BorderRadius.circular(tokens.radiusPill),
              ),
            ),
          ],
          if (title != null) ...[
            SizedBox(height: tokens.spaceMd),
            Text(title!, style: tokens.titleStyle),
          ],
          SizedBox(height: tokens.spaceSm),
          child,
          SizedBox(height: bottomPadding + tokens.spaceMd),
        ],
      ),
    );
  }
}
