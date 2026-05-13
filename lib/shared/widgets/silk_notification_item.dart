import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Pre-styled notification list tile with read / unread state.
///
/// Usage:
/// ```dart
/// SilkNotificationItem(
///   title: 'Payment received',
///   body: r'You received $500 from James.',
///   timestamp: '2 min ago',
///   icon: Icons.payments_outlined,
///   isRead: false,
///   onTap: _markRead,
/// )
/// ```
class SilkNotificationItem extends StatelessWidget {
  const SilkNotificationItem({
    required this.title,
    this.body,
    this.timestamp,
    this.icon,
    this.iconColor,
    this.isRead = true,
    this.onTap,
    this.showDivider = true,
    super.key,
  });

  final String title;
  final String? body;
  final String? timestamp;
  final IconData? icon;
  final Color? iconColor;
  final bool isRead;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final effectiveIconColor = iconColor ?? tokens.accent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: isRead
                ? Colors.transparent
                : tokens.accent.withValues(alpha: 0.04),
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceLg,
              vertical: tokens.spaceMd,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ?? Icons.notifications_outlined,
                    size: 20,
                    color: effectiveIconColor,
                  ),
                ),
                SizedBox(width: tokens.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: tokens.bodySmStyle.copyWith(
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!isRead) ...[
                            SizedBox(width: tokens.spaceXs),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: tokens.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (body != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          body!,
                          style: tokens.captionStyle
                              .copyWith(color: tokens.onSurfaceMuted),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (timestamp != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          timestamp!,
                          style: tokens.captionStyle.copyWith(
                            color: tokens.onSurfaceMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            color: tokens.divider,
            height: 1,
            indent: tokens.spaceLg + 40 + tokens.spaceMd,
          ),
      ],
    );
  }
}
