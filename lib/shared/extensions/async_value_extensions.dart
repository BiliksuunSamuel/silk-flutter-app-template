import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/shared/widgets/silk_shimmer.dart';

extension AsyncValueX<T> on AsyncValue<T> {
  /// Like [when], but on reload keeps showing previous data with a shimmer
  /// overlay instead of flashing a spinner. Spinners only appear on first load.
  Widget whenSmooth({
    required Widget Function(T data) data,
    required Widget Function(Object error, StackTrace stackTrace) error,
    Widget Function()? loading,
  }) {
    if (this is AsyncData<T>) {
      return data((this as AsyncData<T>).value);
    }
    if (this is AsyncError<T>) {
      final e = this as AsyncError<T>;
      return error(e.error, e.stackTrace);
    }
    // AsyncLoading — show previous data with shimmer if available
    final previousValue = value;
    if (previousValue != null) {
      return Stack(
        fit: StackFit.passthrough,
        children: [
          data(previousValue),
          const Positioned.fill(child: _ShimmerOverlay()),
        ],
      );
    }
    return loading?.call() ?? const Center(child: CircularProgressIndicator());
  }
}

class _ShimmerOverlay extends StatelessWidget {
  const _ShimmerOverlay();

  @override
  Widget build(BuildContext context) {
    return SilkShimmer.overlay();
  }
}
