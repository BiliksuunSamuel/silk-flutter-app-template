import 'package:dio/dio.dart';
import 'package:silk/core/logging/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  static const _tag = 'HTTP';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d(
      '→ ${options.method} ${options.uri}',
      tag: _tag,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.d(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      tag: _tag,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err,
      stackTrace: err.stackTrace,
      tag: _tag,
    );
    handler.next(err);
  }
}
