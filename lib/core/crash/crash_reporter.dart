import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crash_reporter.g.dart';

/// Swap the stub for a real implementation (Firebase Crashlytics, Sentry,
/// Datadog, etc.) by overriding [crashReporterProvider] in your
/// ProviderScope overrides at app startup.
abstract interface class CrashReporter {
  /// Record a caught exception with optional stack trace and context.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
    Map<String, Object>? extra,
  });

  /// Log a breadcrumb — a low-priority message attached to the next crash.
  void log(String message);

  /// Tag the current user for crash attribution. Call after login.
  Future<void> setUserId(String userId);

  /// Clear the user tag. Call on logout.
  Future<void> clearUserId();
}

@Riverpod(keepAlive: true)
CrashReporter crashReporter(CrashReporterRef ref) => const _StubCrashReporter();

class _StubCrashReporter implements CrashReporter {
  const _StubCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
    Map<String, Object>? extra,
  }) async {}

  @override
  void log(String message) {}

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<void> clearUserId() async {}
}
