import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/network/dio_provider.dart';
import 'package:silk/features/auth/data/models/auth_response.dart';
import 'package:silk/features/auth/data/models/login_request.dart';

part 'auth_api.g.dart';

@riverpod
AuthApi authApi(AuthApiRef ref) => AuthApi(ref.watch(dioProvider));

class AuthApi {
  const AuthApi(this._dio);

  final Dio _dio;

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    return AuthResponse.fromJson(response.data!);
  }

  Future<AuthResponse> verifyOtp(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      data: body,
    );
    return AuthResponse.fromJson(response.data!);
  }

  Future<AuthResponse> refreshToken(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: body,
    );
    return AuthResponse.fromJson(response.data!);
  }
}
