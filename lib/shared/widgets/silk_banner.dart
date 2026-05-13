import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum SilkBannerVariant { info, success, warning, danger, promo }

/// Full-width top-of-screen banner with a coloured left edge.
/// Distinct from [SilkAlert] which sits inline inside a scroll view.
///
/// Usage:
/// ```dart
/// SilkBanner(
///   variant: SilkBannerVariant.warning,
///   title: 'KYC required',
///   body: 'Complete identity verification to unlock full features.',
///   actionLabel: 'Verify now',
///   onAction: () => context.push('/kyc'),
/// )
/// ```
class SilkBanner extends StatelessWidget {
  const SilkBanner({
    required this.body,
    this.title,
    this.variant = SilkBannerVariant.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    super.key,
  });

  final String body;
  final String? title;
  final SilkBannerVariant variant;

  /// Overrides the default variant icon.
  final IconData? icon;

  final String? actionLabel;
  final VoidCallback? onAction;

  /// When set, a close button is shown on the trailing edge.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final (bg, fg, defaultIcon) = switch (variant) {
      SilkBannerVariant.info => (
          tokens.accent.withValues(alpha: 0.08),
          tokens.accent,
          Icons.info_outline_rounded,
        ),
      SilkBannerVariant.success => (
          tokens.success.withValues(alpha: 0.08),
          tokens.success,
          Icons.check_circle_outline_rounded,
        ),
      SilkBannerVariant.warning => (
          const Color(0xFFFEF3C7),
          const Color(0xFFF59E0B),
          Icons.warning_amber_rounded,
        ),
      SilkBannerVariant.danger => (
          tokens.danger.withValues(alpha: 0.08),
          tokens.danger,
          Icons.error_outline_rounded,
        ),
      SilkBannerVariant.promo => (
          tokens.accent.withValues(alpha: 0.08),
          tokens.accent,
          Icons.auto_awesome_rounded,
        ),
    };

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(left: BorderSide(color: fg, width: 3)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spaceMd,
        vertical: tokens.spaceMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon ?? defaultIcon, size: 18, color: fg),
          ),
          SizedBox(width: tokens.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: tokens.bodySmStyle.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (title != null) const SizedBox(height: 2),
                Text(
                  body,
                  style: tokens.captionStyle
                      .copyWith(color: tokens.onSurface),
                ),
                if (actionLabel != null) ...[
                  SizedBox(height: tokens.spaceXs),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: tokens.captionStyle.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: fg,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            SizedBox(width: tokens.spaceXs),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, size: 16, color: tokens.onSurfaceMuted),
            ),
          ],
        ],
      ),
    );
  }
}
