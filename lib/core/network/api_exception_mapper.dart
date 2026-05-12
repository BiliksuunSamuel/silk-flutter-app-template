import 'package:dio/dio.dart';
import 'package:silk/core/network/api_exception.dart';

abstract final class DioExceptionMapper {
  static ApiException map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException.network(e.message ?? 'Network error');
      case DioExceptionType.badResponse:
        return _fromStatusCode(e.response?.statusCode, e.message);
      case DioExceptionType.cancel:
        return const ApiException.network('Request cancelled');
      case DioExceptionType.badCertificate:
        return const ApiException.network('Bad certificate');
      case DioExceptionType.unknown:
        return ApiException.unknown(e.message ?? 'Unknown error');
    }
  }

  static ApiException _fromStatusCode(int? code, String? message) {
    if (code == null) {
      return ApiException.unknown(message ?? 'Unknown error');
    }
    return switch (code) {
      401 => const ApiException.unauthorized(),
      403 => const ApiException.forbidden(),
      404 => const ApiException.notFound(),
      _ when code >= 500 => ApiException.server('Server error $code'),
      _ => ApiException.unknown(message ?? 'Unknown error ($code)'),
    };
  }
}
