import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';

@freezed
sealed class ApiException with _$ApiException {
  const factory ApiException.network(String message) = NetworkException;
  const factory ApiException.unauthorized() = UnauthorizedException;
  const factory ApiException.forbidden() = ForbiddenException;
  const factory ApiException.notFound() = NotFoundException;
  const factory ApiException.server(String message) = ServerException;
  const factory ApiException.unknown(String message) = UnknownApiException;
}
