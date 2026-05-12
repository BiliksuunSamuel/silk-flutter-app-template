import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

/// Swap the stub for a real implementation (Firebase Analytics, Mixpanel,
/// PostHog, etc.) by overriding [analyticsServiceProvider] in your
/// ProviderScope overrides at app startup.
abstract interface class AnalyticsService {
  /// Log a named event with optional key–value properties.
  Future<void> logEvent(String name, {Map<String, Object>? params});

  /// Identify the current user for attribution / funnel analytics.
  Future<void> identifyUser(String userId, {Map<String, Object>? traits});

  /// Set a persistent super-property sent with every subsequent event.
  Future<void> setUserProperty(String key, String value);

  /// Reset identity — call on logout.
  Future<void> reset();
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(AnalyticsServiceRef ref) =>
    const _StubAnalyticsService();

class _StubAnalyticsService implements AnalyticsService {
  const _StubAnalyticsService();

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {}

  @override
  Future<void> identifyUser(
    String userId, {
    Map<String, Object>? traits,
  }) async {}

  @override
  Future<void> setUserProperty(String key, String value) async {}

  @override
  Future<void> reset() async {}
}
