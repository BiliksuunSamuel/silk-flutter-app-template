import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/shared/pagination/paginated_state.dart';

/// Mix this into any [Notifier] / [AsyncNotifier] subclass to get
/// first-page loading, load-more, and refresh out of the box.
///
/// Example:
/// ```dart
/// @riverpod
/// class PostsNotifier extends _$PostsNotifier
///     with PaginatedNotifierMixin<Post> {
///   @override
///   PaginatedState<Post> build() => loadFirstPage();
///
///   @override
///   Future<(List<Post>, bool)> fetchPage(int page) async {
///     final posts = await ref.read(postRepoProvider).getPosts(page: page);
///     return (posts, posts.length == 20);
///   }
/// }
/// ```
mixin PaginatedNotifierMixin<T> on Notifier<PaginatedState<T>> {
  static const int defaultPageSize = 20;

  /// Fetches [page] (1-based). Returns `(items, hasMore)`.
  Future<(List<T>, bool)> fetchPage(int page);

  /// Call from [build] to kick off the first load.
  PaginatedState<T> loadFirstPage() {
    _load(1);
    return const PaginatedState.loading();
  }

  Future<void> refresh() async {
    state = const PaginatedState.loading();
    await _load(1);
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! PaginatedData<T>) return;
    if (!current.hasMore || current.loadingMore) return;

    state = current.copyWith(loadingMore: true);
    await _load(current.page + 1, existing: current.items);
  }

  Future<void> _load(int page, {List<T> existing = const []}) async {
    try {
      final (items, hasMore) = await fetchPage(page);
      state = PaginatedState.data(
        items: [...existing, ...items],
        page: page,
        hasMore: hasMore,
      );
    } on Exception catch (e) {
      if (existing.isEmpty) {
        state = PaginatedState.error(e.toString());
      } else {
        // Keep existing data visible; just clear the loading flag.
        final current = state;
        if (current is PaginatedData<T>) {
          state = current.copyWith(loadingMore: false);
        }
      }
    }
  }
}
