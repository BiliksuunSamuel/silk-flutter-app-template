import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_state.freezed.dart';

@freezed
sealed class PaginatedState<T> with _$PaginatedState<T> {
  /// Initial state — nothing fetched yet.
  const factory PaginatedState.initial() = PaginatedInitial<T>;

  /// First page is loading.
  const factory PaginatedState.loading() = PaginatedLoading<T>;

  /// A page loaded successfully.
  const factory PaginatedState.data({
    required List<T> items,
    required int page,
    required bool hasMore,

    /// True while the next page is being fetched.
    @Default(false) bool loadingMore,
  }) = PaginatedData<T>;

  /// Hard error (first page failed).
  const factory PaginatedState.error(String message) = PaginatedError<T>;
}
