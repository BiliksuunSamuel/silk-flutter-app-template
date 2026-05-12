import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_shimmer.dart';

class SilkAvatar extends StatelessWidget {
  const SilkAvatar({
    required this.size,
    this.imageUrl,
    this.initials,
    this.color,
    super.key,
  });

  final double size;
  final String? imageUrl;

  /// Shown when [imageUrl] is null or fails to load.
  final String? initials;

  /// Background color for initials fallback. Defaults to accent.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final bg = color ?? tokens.accent;

    return ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                fadeInDuration: MotionTokens.fast,
                placeholder: (_, __) => SilkShimmer(
                  width: size,
                  height: size,
                  borderRadius: size,
                ),
                errorWidget: (_, __, ___) => _InitialsFallback(
                  initials: initials,
                  bg: bg,
                  size: size,
                  tokens: tokens,
                ),
              )
            : _InitialsFallback(
                initials: initials,
                bg: bg,
                size: size,
                tokens: tokens,
              ),
      ),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  const _InitialsFallback({
    required this.bg,
    required this.size,
    required this.tokens,
    this.initials,
  });

  final String? initials;
  final Color bg;
  final double size;
  final dynamic tokens;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: bg,
      child: Center(
        child: Text(
          _resolveInitials(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _resolveInitials() {
    if (initials == null || initials!.isEmpty) return '?';
    final parts = initials!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return initials![0].toUpperCase();
  }
}
