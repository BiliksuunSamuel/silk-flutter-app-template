/// Compile-time configuration injected via `--dart-define`.
///
/// Usage:
///   flutter run --dart-define=BASE_URL=https://api.example.com \
///               --dart-define=ENV=staging
///
/// VS Code launch.json / Xcode scheme / Gradle buildConfig all support
/// passing dart-defines so this is the recommended flavors approach.
abstract final class AppConfig {
  static const env = String.fromEnvironment('ENV', defaultValue: 'development');
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://httpbin.org',
  );

  static bool get isDevelopment => env == 'development';
  static bool get isStaging => env == 'staging';
  static bool get isProduction => env == 'production';
}
