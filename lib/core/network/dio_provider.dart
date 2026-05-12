import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/network/interceptors/auth_interceptor.dart';
import 'package:silk/core/network/interceptors/logging_interceptor.dart';
import 'package:silk/core/network/interceptors/retry_interceptor.dart';

part 'dio_provider.g.dart';

const _baseUrl = 'https://httpbin.org';

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final mainDio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  mainDio.interceptors.addAll([
    if (kDebugMode) LoggingInterceptor(),
    AuthInterceptor(ref, refreshDio),
    RetryInterceptor(mainDio),
  ]);

  return mainDio;
}
