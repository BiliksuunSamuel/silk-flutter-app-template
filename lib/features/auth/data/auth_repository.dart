import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/error/app_failure.dart';
import 'package:silk/core/error/failure_mapper.dart';
import 'package:silk/core/network/api_exception.dart';
import 'package:silk/core/network/result.dart';
import 'package:silk/features/auth/data/auth_api.dart';
import 'package:silk/features/auth/data/models/login_request.dart';
import 'package:silk/features/auth/domain/session.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepository(ref.watch(authApiProvider));

class AuthRepository {
  const AuthRepository(this._api);

  final AuthApi _api;

  Future<Result<bool, AppFailure>> requestOtp(String phone) async {
    try {
      await _api.login(LoginRequest(phone: phone));
      return const Result.success(true);
    } on ApiException catch (e) {
      return Result.failure(FailureMapper.map(e));
    }
  }

  Future<Result<Session, AppFailure>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _api.verifyOtp({'phone': phone, 'otp': otp});
      return Result.success(
        Session(
          userId: response.userId,
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        ),
      );
    } on ApiException catch (e) {
      return Result.failure(FailureMapper.map(e));
    }
  }
}
