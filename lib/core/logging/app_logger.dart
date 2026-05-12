import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract final class AppLogger {
  static late final Logger _logger;

  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 100,
        colors: true,
        printEmojis: true,
      ),
      filter: kReleaseMode ? ProductionFilter() : DevelopmentFilter(),
      level: kReleaseMode ? Level.warning : Level.trace,
    );
  }

  static void d(String message, {String? tag}) =>
      _logger.d(_fmt(message, tag));

  static void i(String message, {String? tag}) =>
      _logger.i(_fmt(message, tag));

  static void w(String message, {String? tag}) =>
      _logger.w(_fmt(message, tag));

  static void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) =>
      _logger.e(_fmt(message, tag), error: error, stackTrace: stackTrace);

  static String _fmt(String message, String? tag) =>
      tag != null ? '[$tag] $message' : message;
}
