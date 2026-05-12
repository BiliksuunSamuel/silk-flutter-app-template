import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/network/api_exception_mapper.dart';
import 'package:silk/core/network/dio_provider.dart';

part 'http_client.g.dart';

class HttpRequestDto {
  const HttpRequestDto({
    required this.url,
    this.data,
    this.token,
    this.params,
    this.headers,
    this.cancelToken,
    this.onSendProgress,
    this.onReceiveProgress,
  });

  /// Relative path or absolute URL.
  final String url;

  /// Request body — JSON map, [FormData], raw string, etc.
  final Object? data;

  /// Per-request Bearer token. When set, [AuthInterceptor] will not overwrite
  /// it with the session token.
  final String? token;

  /// URL query parameters.
  final Map<String, dynamic>? params;

  /// Extra headers merged on top of the Dio base headers.
  final Map<String, dynamic>? headers;

  /// Cancellation token — cancel with [CancelToken.cancel].
  final CancelToken? cancelToken;

  /// Upload progress callback (POST / PUT / PATCH).
  final ProgressCallback? onSendProgress;

  /// Download progress callback.
  final ProgressCallback? onReceiveProgress;
}

@Riverpod(keepAlive: true)
HttpClient httpClient(HttpClientRef ref) => HttpClient(ref.watch(dioProvider));

class HttpClient {
  const HttpClient(this._dio);

  final Dio _dio;

  // ── Verbs ──────────────────────────────────────────────────────────────────

  Future<Response<T>> get<T>(HttpRequestDto req) => _run(
        () => _dio.get<T>(
          req.url,
          queryParameters: req.params,
          options: _buildOptions(req),
          cancelToken: req.cancelToken,
          onReceiveProgress: req.onReceiveProgress,
        ),
      );

  Future<Response<T>> post<T>(HttpRequestDto req) => _run(
        () => _dio.post<T>(
          req.url,
          data: req.data,
          queryParameters: req.params,
          options: _buildOptions(req),
          cancelToken: req.cancelToken,
          onSendProgress: req.onSendProgress,
          onReceiveProgress: req.onReceiveProgress,
        ),
      );

  Future<Response<T>> put<T>(HttpRequestDto req) => _run(
        () => _dio.put<T>(
          req.url,
          data: req.data,
          queryParameters: req.params,
          options: _buildOptions(req),
          cancelToken: req.cancelToken,
          onSendProgress: req.onSendProgress,
          onReceiveProgress: req.onReceiveProgress,
        ),
      );

  Future<Response<T>> patch<T>(HttpRequestDto req) => _run(
        () => _dio.patch<T>(
          req.url,
          data: req.data,
          queryParameters: req.params,
          options: _buildOptions(req),
          cancelToken: req.cancelToken,
          onSendProgress: req.onSendProgress,
          onReceiveProgress: req.onReceiveProgress,
        ),
      );

  Future<Response<T>> delete<T>(HttpRequestDto req) => _run(
        () => _dio.delete<T>(
          req.url,
          data: req.data,
          queryParameters: req.params,
          options: _buildOptions(req),
          cancelToken: req.cancelToken,
        ),
      );

  // ── Internals ──────────────────────────────────────────────────────────────

  Options _buildOptions(HttpRequestDto req) {
    final hdrs = <String, dynamic>{
      if (req.token != null) 'Authorization': 'Bearer ${req.token}',
      ...?req.headers,
    };
    return Options(headers: hdrs.isEmpty ? null : hdrs);
  }

  Future<Response<T>> _run<T>(Future<Response<T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      // Translate raw Dio errors to domain-level ApiException so callers
      // never have a hard dependency on Dio's exception types.
      throw DioExceptionMapper.map(e);
    }
  }
}
