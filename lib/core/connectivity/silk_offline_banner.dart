import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/connectivity/connectivity_service.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Drop this above any scaffold body to show a persistent "No connection"
/// strip when the device is offline.
///
/// ```dart
/// body: Column(
///   children: [
///     const SilkOfflineBanner(),
///     Expanded(child: myContent),
///   ],
/// ),
/// ```
class SilkOfflineBanner extends ConsumerWidget {
  const SilkOfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref
        .watch(connectivityStreamProvider)
        .valueOrNull ??
        true;

    return AnimatedSize(
      duration: MotionTokens.standard,
      curve: MotionTokens.emphasizedDecel,
      child: isOnline
          ? const SizedBox.shrink()
          : const _Banner(key: ValueKey('offline')),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return ColoredBox(
      color: tokens.danger,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.spaceMd,
              vertical: tokens.spaceXs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 14, color: Colors.white),
                SizedBox(width: tokens.spaceXs),
                Text(
                  'No internet connection',
                  style: tokens.captionStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
