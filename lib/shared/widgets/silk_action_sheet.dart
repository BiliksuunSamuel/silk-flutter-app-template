import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkActionItem {
  const SilkActionItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
}

/// iOS-style bottom action sheet with a separate cancel button.
///
/// Usage:
/// ```dart
/// SilkActionSheet.show(
///   context: context,
///   title: 'Transfer options',
///   actions: [
///     SilkActionItem(label: 'Send money', icon: Icons.send_outlined, onTap: ...),
///     SilkActionItem(label: 'Delete', isDestructive: true, onTap: ...),
///   ],
/// );
/// ```
abstract class SilkActionSheet {
  static Future<void> show({
    required BuildContext context,
    required List<SilkActionItem> actions,
    String? title,
    String? message,
    String cancelLabel = 'Cancel',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ActionSheetView(
        actions: actions,
        title: title,
        message: message,
        cancelLabel: cancelLabel,
      ),
    );
  }
}

class _ActionSheetView extends StatelessWidget {
  const _ActionSheetView({
    required this.actions,
    required this.cancelLabel,
    this.title,
    this.message,
  });

  final List<SilkActionItem> actions;
  final String? title;
  final String? message;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final hasHeader = title != null || message != null;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasHeader) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spaceLg,
                  vertical: tokens.spaceMd,
                ),
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(tokens.radiusLg),
                ),
                child: Column(
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: tokens.bodyStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: tokens.onSurfaceMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    if (title != null && message != null)
                      SizedBox(height: tokens.spaceXs),
                    if (message != null)
                      Text(
                        message!,
                        style: tokens.captionStyle
                            .copyWith(color: tokens.onSurfaceMuted),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
              SizedBox(height: tokens.spaceSm),
            ],
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(tokens.radiusLg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < actions.length; i++)
                    _ActionTile(
                      item: actions[i],
                      isFirst: i == 0,
                      isLast: i == actions.length - 1,
                    ),
                ],
              ),
            ),
            SizedBox(height: tokens.spaceSm),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: tokens.spaceMd + 2,
                ),
                decoration: BoxDecoration(
                  color: tokens.surface,
                  borderRadius: BorderRadius.circular(tokens.radiusLg),
                ),
                alignment: Alignment.center,
                child: Text(
                  cancelLabel,
                  style: tokens.bodyStyle.copyWith(
                    color: tokens.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.item,
    required this.isFirst,
    required this.isLast,
  });

  final SilkActionItem item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final radius = BorderRadius.vertical(
      top: isFirst ? Radius.circular(tokens.radiusLg) : Radius.zero,
      bottom: isLast ? Radius.circular(tokens.radiusLg) : Radius.zero,
    );

    return ClipRRect(
      borderRadius: radius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                item.onTap();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spaceLg,
                  vertical: tokens.spaceMd + 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 20,
                        color: item.isDestructive
                            ? tokens.danger
                            : tokens.onSurface,
                      ),
                      SizedBox(width: tokens.spaceSm),
                    ],
                    Text(
                      item.label,
                      style: tokens.bodyStyle.copyWith(
                        color: item.isDestructive
                            ? tokens.danger
                            : tokens.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isLast) Divider(color: tokens.divider, height: 1),
        ],
      ),
    );
  }
}
