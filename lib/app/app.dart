import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:silk/app/scroll_behavior.dart';
import 'package:silk/core/router/app_router.dart';
import 'package:silk/core/theme/dark_tokens.dart';
import 'package:silk/core/theme/light_tokens.dart';
import 'package:silk/core/theme/theme_builder.dart';
import 'package:silk/core/theme/theme_mode_provider.dart';

class SilkApp extends ConsumerWidget {
  const SilkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref
        .watch(themeModeNotifierProvider)
        .valueOrNull ?? ThemeMode.system;

    return MaterialApp.router(
      title: 'Silk',
      scrollBehavior: const SilkScrollBehavior(),
      theme: ThemeBuilder.buildTheme(lightTokens),
      darkTheme: ThemeBuilder.buildTheme(darkTokens),
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
