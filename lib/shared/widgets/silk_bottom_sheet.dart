import 'package:flutter/material.dart';
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
      barrierColor: Colors.black.withValues(alpha: 0.18),
      sheetAnimationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
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
          top: Radius.circular(tokens.radiusSheet),
        ),
        boxShadow: tokens.shadowFloating,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: tokens.onSurface.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
          if (title != null) ...[
            SizedBox(height: tokens.spaceMd),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title!, style: tokens.titleStyle),
              ),
            ),
          ],
          SizedBox(height: tokens.spaceSm),
          child,
          SizedBox(height: bottomPadding + tokens.spaceMd),
        ],
      ),
    );
  }
}
