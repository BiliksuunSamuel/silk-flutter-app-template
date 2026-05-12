import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/network/http_client.dart';
import 'package:silk/features/auth/data/models/auth_response.dart';
import 'package:silk/features/auth/data/models/login_request.dart';

part 'auth_api.g.dart';

@riverpod
AuthApi authApi(AuthApiRef ref) => AuthApi(ref.watch(httpClientProvider));

class AuthApi {
  const AuthApi(this._client);

  final HttpClient _client;

  Future<AuthResponse> login(LoginRequest request) async {
    final res = await _client.post<Map<String, dynamic>>(
      HttpRequestDto(url: '/auth/login', data: request.toJson()),
    );
    return AuthResponse.fromJson(res.data!);
  }

  Future<AuthResponse> verifyOtp(Map<String, dynamic> body) async {
    final res = await _client.post<Map<String, dynamic>>(
      HttpRequestDto(url: '/auth/otp/verify', data: body),
    );
    return AuthResponse.fromJson(res.data!);
  }

  Future<AuthResponse> refreshToken(Map<String, dynamic> body) async {
    final res = await _client.post<Map<String, dynamic>>(
      HttpRequestDto(url: '/auth/refresh', data: body),
    );
    return AuthResponse.fromJson(res.data!);
  }
}
