import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/storage/secure_store.dart';
import 'package:silk/core/storage/storage_keys.dart';
import 'package:silk/features/auth/domain/session.dart';

part 'session_provider.g.dart';

@Riverpod(keepAlive: true)
class SessionNotifier extends _$SessionNotifier {
  @override
  Future<Session?> build() async {
    final store = ref.read(secureStoreProvider);
    final accessToken = await store.getString(StorageKeys.accessToken);
    final refreshToken = await store.getString(StorageKeys.refreshToken);
    final userId = await store.getString(StorageKeys.userId);

    if (accessToken != null && refreshToken != null && userId != null) {
      return Session(
        userId: userId,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
    return null;
  }

  Future<void> setSession(Session session) async {
    state = AsyncData(session);
    final store = ref.read(secureStoreProvider);
    await Future.wait([
      store.setString(StorageKeys.accessToken, session.accessToken),
      store.setString(StorageKeys.refreshToken, session.refreshToken),
      store.setString(StorageKeys.userId, session.userId),
    ]);
  }

  Future<void> clearSession() async {
    state = const AsyncData(null);
    await ref.read(secureStoreProvider).clear();
  }
}
