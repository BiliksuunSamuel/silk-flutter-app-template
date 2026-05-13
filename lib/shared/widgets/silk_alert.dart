import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkAlertVariant { info, success, warning, danger }

class SilkAlert extends StatelessWidget {
  const SilkAlert({
    required this.body,
    this.title,
    this.variant = SilkAlertVariant.info,
    this.onDismiss,
    super.key,
  });

  final String body;
  final String? title;
  final SilkAlertVariant variant;

  /// If provided, a dismiss (×) button is shown at the trailing edge.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (icon, fg, bg) = switch (variant) {
      SilkAlertVariant.info    => (Icons.info_outline_rounded,        tokens.accent,   tokens.accent.withValues(alpha: 0.1)),
      SilkAlertVariant.success => (Icons.check_circle_outline_rounded, tokens.success, tokens.success.withValues(alpha: 0.1)),
      SilkAlertVariant.warning => (Icons.warning_amber_rounded,        const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
      SilkAlertVariant.danger  => (Icons.error_outline_rounded,        tokens.danger,  tokens.danger.withValues(alpha: 0.1)),
    };

    final title = this.title;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      padding: EdgeInsets.all(tokens.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 18),
          SizedBox(width: tokens.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: tokens.bodySmStyle.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: tokens.spaceXs / 2),
                ],
                Text(
                  body,
                  style: tokens.bodySmStyle.copyWith(color: fg),
                ),
              ],
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: tokens.spaceXs),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close_rounded, color: fg, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
