import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_button.dart';

class SilkEmptyState extends StatelessWidget {
  const SilkEmptyState({
    required this.title,
    this.icon,
    this.body,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData? icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final lbl = actionLabel;
    final action = onAction;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 56,
                color: tokens.onSurfaceMuted.withValues(alpha: 0.45),
              ),
            if (icon != null) SizedBox(height: tokens.spaceMd),
            Text(title, style: tokens.titleStyle, textAlign: TextAlign.center),
            if (body != null) ...[
              SizedBox(height: tokens.spaceSm),
              Text(
                body!,
                style: tokens.bodyStyle.copyWith(color: tokens.onSurfaceMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (lbl != null && action != null) ...[
              SizedBox(height: tokens.spaceLg),
              SilkButton(label: lbl, onPressed: action),
            ],
          ],
        ),
      ),
    );
  }
}
