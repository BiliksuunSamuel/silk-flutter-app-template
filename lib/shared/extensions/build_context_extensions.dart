import 'package:flutter/material.dart';
import 'package:silk/core/theme/tokens.dart';

export 'package:silk/core/theme/context_tokens_extension.dart';

extension BuildContextX on BuildContext {
  AppTokens get tokens => Theme.of(this).extension<AppTokens>()!;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  MediaQueryData get mq => MediaQuery.of(this);

  double get screenWidth => mq.size.width;

  double get screenHeight => mq.size.height;

  EdgeInsets get padding => mq.padding;

  EdgeInsets get viewInsets => mq.viewInsets;
}
