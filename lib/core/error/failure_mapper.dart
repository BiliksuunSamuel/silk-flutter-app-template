import 'package:silk/core/error/app_failure.dart';
import 'package:silk/core/network/api_exception.dart';

abstract final class FailureMapper {
  static AppFailure map(ApiException exception) {
    return switch (exception) {
      NetworkException(:final message) => AppFailure.network(message),
      UnauthorizedException() => const AppFailure.unauthorized(),
      ForbiddenException() => const AppFailure.forbidden(),
      NotFoundException() => const AppFailure.notFound(),
      ServerException(:final message) => AppFailure.server(message),
      UnknownApiException(:final message) => AppFailure.unknown(message),
    };
  }
}
