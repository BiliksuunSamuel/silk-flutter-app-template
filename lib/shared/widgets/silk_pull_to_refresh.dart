import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkPullToRefresh extends StatelessWidget {
  const SilkPullToRefresh({
    required this.onRefresh,
    required this.child,
    super.key,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: tokens.accent,
      backgroundColor: tokens.surface,
      strokeWidth: 2,
      displacement: 60,
      child: child,
    );
  }
}
