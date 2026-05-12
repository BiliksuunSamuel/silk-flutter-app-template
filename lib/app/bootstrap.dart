import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/core/crash/crash_reporter.dart';
import 'package:silk/core/extensions/dimension_extensions.dart';
import 'package:silk/core/logging/app_logger.dart';

typedef AppBuilder = Widget Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();

  // Seed the responsive sizer from the physical window before the first build
  // so AppTypography.* font sizes are correct on startup.
  final view = PlatformDispatcher.instance.views.first;
  SilkSizer.screenWidth = view.physicalSize.width / view.devicePixelRatio;

  // Create the root container so we can wire error handlers before runApp.
  final container = ProviderContainer();
  final reporter = container.read(crashReporterProvider);

  // Catch Flutter framework errors (e.g. build/layout exceptions).
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    reporter.recordError(
      details.exception,
      details.stack,
      reason: details.context?.toDescription(),
      fatal: false,
    );
  };

  // Catch errors outside the Flutter framework (async zones, isolates, etc.).
  PlatformDispatcher.instance.onError = (error, stack) {
    reporter.recordError(error, stack, fatal: true);
    return true;
  };

  // UncontrolledProviderScope lets the widget tree use the existing container
  // rather than creating a second one, avoiding duplicate provider state.
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: builder(),
    ),
  );
}
