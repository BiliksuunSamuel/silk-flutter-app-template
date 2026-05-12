import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_service.g.dart';

/// Payload delivered when a notification is tapped or received.
class PushPayload {
  const PushPayload({
    required this.title,
    required this.body,
    this.data = const {},
  });

  final String title;
  final String body;
  final Map<String, dynamic> data;
}

/// Swap the stub for a real implementation (FCM via `firebase_messaging`,
/// APNs direct, OneSignal, etc.) by overriding [pushNotificationServiceProvider]
/// in your ProviderScope overrides at app startup.
abstract interface class PushNotificationService {
  /// Request OS-level notification permission. Returns `true` if granted.
  Future<bool> requestPermission();

  /// Returns the current FCM / APNs device token, or null if unavailable.
  Future<String?> getToken();

  /// Stream of payloads for notifications received while the app is in the
  /// foreground.
  Stream<PushPayload> get onMessage;

  /// Stream of payloads for notifications that brought the app to the
  /// foreground from background / terminated state.
  Stream<PushPayload> get onNotificationTap;
}

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(
  PushNotificationServiceRef ref,
) =>
    const _StubPushNotificationService();

class _StubPushNotificationService implements PushNotificationService {
  const _StubPushNotificationService();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<PushPayload> get onMessage => const Stream.empty();

  @override
  Stream<PushPayload> get onNotificationTap => const Stream.empty();
}
