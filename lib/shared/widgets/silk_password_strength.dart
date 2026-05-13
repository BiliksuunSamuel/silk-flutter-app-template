import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

enum _Strength { empty, weak, fair, strong, veryStrong }

/// Animated password strength indicator — a segmented bar + label.
/// Pair it directly below a password [SilkTextField].
///
/// Usage:
/// ```dart
/// SilkPasswordStrength(password: _passwordController.text)
/// ```
class SilkPasswordStrength extends StatelessWidget {
  const SilkPasswordStrength({
    required this.password,
    this.showLabel = true,
    this.segments = 4,
    super.key,
  });

  final String password;
  final bool showLabel;
  final int segments;

  static _Strength _evaluate(String p) {
    if (p.isEmpty) return _Strength.empty;
    var score = 0;
    if (p.length >= 8) score++;
    if (p.length >= 12) score++;
    if (RegExp('[A-Z]').hasMatch(p)) score++;
    if (RegExp('[0-9]').hasMatch(p)) score++;
    if (RegExp('[^A-Za-z0-9]').hasMatch(p)) score++;
    if (score <= 1) return _Strength.weak;
    if (score == 2) return _Strength.fair;
    if (score == 3) return _Strength.strong;
    return _Strength.veryStrong;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final strength = _evaluate(password);

    final (filledSegments, color, label) = switch (strength) {
      _Strength.empty => (0, tokens.divider, ''),
      _Strength.weak => (1, tokens.danger, 'Weak'),
      _Strength.fair => (2, const Color(0xFFF59E0B), 'Fair'),
      _Strength.strong => (3, tokens.success, 'Strong'),
      _Strength.veryStrong => (4, tokens.success, 'Very strong'),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(segments, (i) {
            final active = i < filledSegments;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: i < segments - 1 ? 4 : 0,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: 4,
                  decoration: BoxDecoration(
                    color: active ? color : tokens.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            );
          }),
        ),
        if (showLabel && label.isNotEmpty) ...[
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Align(
              key: ValueKey(label),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: tokens.captionStyle.copyWith(color: color),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
