import 'package:flutter/widgets.dart';
import 'package:silk/core/logging/app_logger.dart';

typedef AppBuilder = Widget Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init();
  runApp(builder());
}
