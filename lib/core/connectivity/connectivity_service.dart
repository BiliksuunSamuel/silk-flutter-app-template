import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Reactive connectivity state. `true` = online, `false` = offline.
@Riverpod(keepAlive: true)
Stream<bool> connectivityStream(ConnectivityStreamRef ref) =>
    Connectivity().onConnectivityChanged.map(
      (results) => results.any((r) => r != ConnectivityResult.none),
    );

/// One-shot check — useful before making a network call.
@riverpod
Future<bool> isOnline(IsOnlineRef ref) async {
  final results = await Connectivity().checkConnectivity();
  return results.any((r) => r != ConnectivityResult.none);
}
