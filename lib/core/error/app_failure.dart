import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  const factory AppFailure.network(String message) = NetworkFailure;
  const factory AppFailure.unauthorized() = UnauthorizedFailure;
  const factory AppFailure.forbidden() = ForbiddenFailure;
  const factory AppFailure.notFound() = NotFoundFailure;
  const factory AppFailure.server(String message) = ServerFailure;
  const factory AppFailure.unknown(String message) = UnknownFailure;

  const AppFailure._();

  String get userMessage => switch (this) {
        NetworkFailure(:final message) =>
          message.isEmpty ? 'No internet connection.' : message,
        UnauthorizedFailure() => 'Session expired. Please sign in again.',
        ForbiddenFailure() => "You don't have permission to do that.",
        NotFoundFailure() => 'The requested resource was not found.',
        ServerFailure() => 'Something went wrong. Please try again.',
        UnknownFailure(:final message) =>
          message.isEmpty ? 'An unexpected error occurred.' : message,
      };
}
