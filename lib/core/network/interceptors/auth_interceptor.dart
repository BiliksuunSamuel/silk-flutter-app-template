import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/logging/app_logger.dart';
import 'package:silk/features/auth/domain/session.dart';
import 'package:silk/features/auth/presentation/providers/session_provider.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref, this._refreshDio);

  final Ref _ref;

  // Separate Dio without auth interceptors — avoids circular dependency.
  final Dio _refreshDio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Respect a per-request token set via HttpRequestDto.token.
    if (!options.headers.containsKey('Authorization')) {
      final session = _ref.read(sessionNotifierProvider).valueOrNull;
      if (session != null) {
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final session = _ref.read(sessionNotifierProvider).valueOrNull;
    if (session == null) {
      return handler.next(err);
    }

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': session.refreshToken},
      );

      final data = response.data!;
      final newSession = Session(
        userId: session.userId,
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );

      await _ref
          .read(sessionNotifierProvider.notifier)
          .setSession(newSession);

      err.requestOptions.headers['Authorization'] =
          'Bearer ${newSession.accessToken}';

      final retried = await _refreshDio.fetch<dynamic>(err.requestOptions);
      handler.resolve(retried);
    } on Exception catch (e) {
      AppLogger.e('Token refresh failed — logging out', error: e, tag: 'Auth');
      await _ref.read(sessionNotifierProvider.notifier).clearSession();
      handler.next(err);
    }
  }
}
