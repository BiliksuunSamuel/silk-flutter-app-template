import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Which side of the conversation the bubble belongs to.
enum SilkChatSide { sender, receiver }

/// A single chat message bubble with optional avatar, timestamp, and status icon.
class SilkChatBubble extends StatelessWidget {
  const SilkChatBubble({
    required this.message,
    required this.side,
    this.timestamp,
    this.avatar,
    this.maxWidthFraction = 0.72,
    this.statusIcon,
    super.key,
  });

  final String message;
  final SilkChatSide side;
  final String? timestamp;
  final Widget? avatar;
  final double maxWidthFraction;
  final Widget? statusIcon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isSender = side == SilkChatSide.sender;

    final bubbleColor = isSender ? tokens.accent : tokens.surfaceMuted;
    final textColor = isSender ? tokens.onAccent : tokens.onSurface;

    final radius = BorderRadius.only(
      topLeft: Radius.circular(tokens.radiusLg),
      topRight: Radius.circular(tokens.radiusLg),
      bottomLeft: Radius.circular(
        isSender ? tokens.radiusLg : tokens.radiusSm,
      ),
      bottomRight: Radius.circular(
        isSender ? tokens.radiusSm : tokens.radiusLg,
      ),
    );

    final bubble = Container(
      padding: EdgeInsets.fromLTRB(
        tokens.spaceMd,
        tokens.spaceSm,
        tokens.spaceMd,
        tokens.spaceSm,
      ),
      decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: tokens.bodyStyle.copyWith(color: textColor),
          ),
          if (timestamp != null || statusIcon != null) ...[
            SizedBox(height: tokens.spaceXs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (timestamp != null)
                  Text(
                    timestamp!,
                    style: tokens.captionStyle.copyWith(
                      color: isSender
                          ? tokens.onAccent.withValues(alpha: 0.7)
                          : tokens.onSurfaceMuted,
                    ),
                  ),
                if (statusIcon != null) ...[
                  SizedBox(width: tokens.spaceXs),
                  IconTheme(
                    data: IconThemeData(
                      color: isSender
                          ? tokens.onAccent.withValues(alpha: 0.7)
                          : tokens.onSurfaceMuted,
                      size: 14,
                    ),
                    child: statusIcon!,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );

    final avatarWidget = avatar != null
        ? Padding(
            padding: EdgeInsets.only(
              left: isSender ? tokens.spaceSm : 0,
              right: isSender ? 0 : tokens.spaceSm,
            ),
            child: avatar,
          )
        : null;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * maxWidthFraction,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isSender && avatarWidget != null) avatarWidget,
                Flexible(child: bubble),
                if (isSender && avatarWidget != null) avatarWidget,
              ],
            ),
          );
        },
      ),
    );
  }
}
