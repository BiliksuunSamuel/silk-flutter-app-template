import 'package:flutter/material.dart';
import 'package:silk/core/theme/tokens.dart';

extension AppTokensContext on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
