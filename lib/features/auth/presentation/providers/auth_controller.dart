import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/error/app_failure.dart';
import 'package:silk/core/network/result.dart';
import 'package:silk/features/auth/data/auth_repository.dart';
import 'package:silk/features/auth/domain/session.dart';
import 'package:silk/features/auth/presentation/providers/session_provider.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<bool> requestOtp(String phone) async {
    state = const AsyncValue.loading();
    final result = await ref.read(authRepositoryProvider).requestOtp(phone);
    return result.when(
      success: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      failure: (AppFailure e) {
        state = AsyncValue.error(e, StackTrace.current);
        return false;
      },
    );
  }

  Future<bool> verifyOtp({required String phone, required String otp}) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(authRepositoryProvider)
        .verifyOtp(phone: phone, otp: otp);
    return result.when(
      success: (Session session) {
        unawaited(
          ref.read(sessionNotifierProvider.notifier).setSession(session),
        );
        state = const AsyncValue.data(null);
        return true;
      },
      failure: (AppFailure e) {
        state = AsyncValue.error(e, StackTrace.current);
        return false;
      },
    );
  }

  Future<void> signOut() async {
    await ref.read(sessionNotifierProvider.notifier).clearSession();
  }
}
