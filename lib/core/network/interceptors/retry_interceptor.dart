import 'package:dio/dio.dart';
import 'package:silk/core/logging/app_logger.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);

  final Dio _dio;

  static const _maxRetries = 3;
  static const _retryDelays = [
    Duration(milliseconds: 300),
    Duration(milliseconds: 600),
    Duration(milliseconds: 1200),
  ];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final currentAttempt =
        (err.requestOptions.extra['_retry_count'] as int?) ?? 0;

    if (!_shouldRetry(err) || currentAttempt >= _maxRetries) {
      return handler.next(err);
    }

    // Never retry non-idempotent POST requests unless flagged
    if (err.requestOptions.method.toUpperCase() == 'POST') {
      final isIdempotent =
          err.requestOptions.extra['idempotent'] == true;
      if (!isIdempotent) return handler.next(err);
    }

    AppLogger.d(
      'Retry ${currentAttempt + 1}/$_maxRetries for ${err.requestOptions.uri}',
      tag: 'Retry',
    );

    await Future<void>.delayed(_retryDelays[currentAttempt]);

    err.requestOptions.extra['_retry_count'] = currentAttempt + 1;

    try {
      final response = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    final isNetworkError = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout;

    final statusCode = err.response?.statusCode;
    final isServerError = statusCode != null && statusCode >= 500;

    return isNetworkError || isServerError;
  }
}
