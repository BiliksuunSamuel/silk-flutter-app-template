import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_avatar.dart';

@immutable
class SilkAvatarItem {
  const SilkAvatarItem({required this.initials, this.color, this.imageUrl});

  final String initials;
  final Color? color;
  final String? imageUrl;
}

/// A row of overlapping [SilkAvatar] widgets with an overflow count badge.
///
/// Usage:
/// ```dart
/// SilkAvatarGroup(
///   items: const [
///     SilkAvatarItem(initials: 'AS'),
///     SilkAvatarItem(initials: 'BH'),
///     SilkAvatarItem(initials: 'CK'),
///   ],
///   max: 4,
/// )
/// ```
class SilkAvatarGroup extends StatelessWidget {
  const SilkAvatarGroup({
    required this.items,
    this.max = 5,
    this.size = 36.0,
    this.overlap = 10.0,
    super.key,
  });

  final List<SilkAvatarItem> items;

  /// Maximum avatars to display before showing an overflow count.
  final int max;

  final double size;

  /// How many pixels each avatar overlaps the previous one.
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final visible = items.take(max).toList();
    final overflow = items.length - visible.length;
    final totalCount = visible.length + (overflow > 0 ? 1 : 0);
    final totalWidth =
        size + (totalCount - 1) * (size - overlap);

    return SizedBox(
      width: totalWidth,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: _BorderedAvatar(
                item: visible[i],
                size: size,
                borderColor: tokens.surface,
              ),
            ),
          if (overflow > 0)
            Positioned(
              left: visible.length * (size - overlap),
              child: _OverflowAvatar(
                count: overflow,
                size: size,
                borderColor: tokens.surface,
              ),
            ),
        ],
      ),
    );
  }
}

class _BorderedAvatar extends StatelessWidget {
  const _BorderedAvatar({
    required this.item,
    required this.size,
    required this.borderColor,
  });

  final SilkAvatarItem item;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: SilkAvatar(
        size: size - 4,
        initials: item.initials,
        color: item.color,
      ),
    );
  }
}

class _OverflowAvatar extends StatelessWidget {
  const _OverflowAvatar({
    required this.count,
    required this.size,
    required this.borderColor,
  });

  final int count;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tokens.surfaceMuted,
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '+$count',
        style: tokens.captionStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: tokens.onSurface,
          fontSize: size * 0.28,
        ),
      ),
    );
  }
}
