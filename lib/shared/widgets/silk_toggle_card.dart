import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A card-style radio option. Combine several in a [Column] managed by the
/// parent's state to build a plan selector, risk-profile picker, etc.
///
/// Usage:
/// ```dart
/// SilkToggleCard(
///   title: 'Pro',
///   description: r'$9/month · unlimited projects',
///   icon: Icons.rocket_launch_outlined,
///   selected: _plan == 'pro',
///   onTap: () => setState(() => _plan = 'pro'),
/// )
/// ```
class SilkToggleCard extends StatelessWidget {
  const SilkToggleCard({
    required this.title,
    required this.onTap,
    this.description,
    this.icon,
    this.trailing,
    this.selected = false,
    super.key,
  });

  final String title;
  final String? description;
  final IconData? icon;

  /// Arbitrary widget in the trailing slot (e.g. a price tag).
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(tokens.spaceMd),
        decoration: BoxDecoration(
          color: selected
              ? tokens.accent.withValues(alpha: 0.06)
              : tokens.surfaceMuted,
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          border: Border.all(
            color: selected ? tokens.accent : tokens.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected
                      ? tokens.accent.withValues(alpha: 0.12)
                      : tokens.surface,
                  borderRadius: BorderRadius.circular(tokens.radiusMd),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: selected ? tokens.accent : tokens.onSurfaceMuted,
                ),
              ),
              SizedBox(width: tokens.spaceMd),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tokens.bodyStyle.copyWith(
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                      color: selected ? tokens.accent : tokens.onSurface,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: tokens.captionStyle
                          .copyWith(color: tokens.onSurfaceMuted),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: tokens.spaceSm),
              trailing!,
            ] else ...[
              SizedBox(width: tokens.spaceSm),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? tokens.accent : Colors.transparent,
                  border: Border.all(
                    color: selected ? tokens.accent : tokens.divider,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: tokens.onAccent,
                      )
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
