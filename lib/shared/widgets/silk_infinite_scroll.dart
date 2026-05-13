import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Drop this as the last item in a [ListView] (or similar) to trigger
/// automatic loading of the next page when the user scrolls near the bottom.
///
/// Usage:
/// ```dart
/// ListView.builder(
///   itemCount: items.length + 1,
///   itemBuilder: (context, i) {
///     if (i == items.length) {
///       return SilkInfiniteScroll(
///         hasMore: state.hasMore,
///         isLoading: state.loadingMore,
///         onLoadMore: notifier.loadMore,
///       );
///     }
///     return ItemTile(items[i]);
///   },
/// )
/// ```
class SilkInfiniteScroll extends StatefulWidget {
  const SilkInfiniteScroll({
    required this.hasMore,
    required this.isLoading,
    required this.onLoadMore,
    this.threshold = 120.0,
    super.key,
  });

  /// Whether there are more pages to load.
  final bool hasMore;

  /// Whether a load is currently in progress.
  final bool isLoading;

  /// Called when the widget becomes visible and [hasMore] is true.
  final VoidCallback onLoadMore;

  /// Distance from the bottom (in logical pixels) at which loading is triggered.
  final double threshold;

  @override
  State<SilkInfiniteScroll> createState() => _SilkInfiniteScrollState();
}

class _SilkInfiniteScrollState extends State<SilkInfiniteScroll> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryLoad();
  }

  @override
  void didUpdateWidget(SilkInfiniteScroll old) {
    super.didUpdateWidget(old);
    if (!old.hasMore && widget.hasMore) _tryLoad();
  }

  void _tryLoad() {
    if (!widget.hasMore || widget.isLoading) return;
    // Fire on the next frame so scroll metrics are settled.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final pos = Scrollable.maybeOf(context)?.position;
      if (pos == null) return;
      final distanceToEnd = pos.maxScrollExtent - pos.pixels;
      if (distanceToEnd <= widget.threshold) {
        widget.onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    if (!widget.hasMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: tokens.spaceLg),
        child: Center(
          child: Text(
            '— end —',
            style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
          ),
        ),
      );
    }

    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        _tryLoad();
        return false;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: tokens.spaceLg),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(tokens.accent),
            ),
          ),
        ),
      ),
    );
  }
}
