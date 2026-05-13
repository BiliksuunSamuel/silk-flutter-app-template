import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/core/theme/tokens.dart';

/// A lightweight markdown renderer that handles bold, italic, inline code,
/// headings (h1–h3), bullet lists, and horizontal rules.
class SilkMarkdownText extends StatelessWidget {
  const SilkMarkdownText({
    required this.data,
    this.baseStyle,
    super.key,
  });

  final String data;
  final TextStyle? baseStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final base = baseStyle ?? tokens.bodyStyle;

    final lines = data.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      final trimmed = line.trimRight();

      if (trimmed == '---') {
        widgets.add(
          Divider(
            color: tokens.divider,
            thickness: 1,
            height: tokens.spaceLg,
          ),
        );
        continue;
      }

      if (trimmed.startsWith('### ')) {
        widgets.add(
          Text.rich(
            TextSpan(
              children: _parseInline(
                trimmed.substring(4),
                tokens.titleSmStyle.copyWith(color: tokens.onSurface),
                tokens,
              ),
            ),
          ),
        );
        continue;
      }

      if (trimmed.startsWith('## ')) {
        widgets.add(
          Text.rich(
            TextSpan(
              children: _parseInline(
                trimmed.substring(3),
                tokens.titleStyle.copyWith(color: tokens.onSurface),
                tokens,
              ),
            ),
          ),
        );
        continue;
      }

      if (trimmed.startsWith('# ')) {
        widgets.add(
          Text.rich(
            TextSpan(
              children: _parseInline(
                trimmed.substring(2),
                tokens.headlineStyle.copyWith(color: tokens.onSurface),
                tokens,
              ),
            ),
          ),
        );
        continue;
      }

      if (trimmed.startsWith('- ')) {
        widgets.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '•  ',
                style: base.copyWith(color: tokens.onSurface),
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: _parseInline(
                      trimmed.substring(2),
                      base.copyWith(color: tokens.onSurface),
                      tokens,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        continue;
      }

      if (trimmed.isEmpty) {
        widgets.add(SizedBox(height: tokens.spaceSm));
        continue;
      }

      widgets.add(
        Text.rich(
          TextSpan(
            children: _parseInline(
              trimmed,
              base.copyWith(color: tokens.onSurface),
              tokens,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}

List<TextSpan> _parseInline(
  String text,
  TextStyle baseStyle,
  AppTokens tokens,
) {
  final spans = <TextSpan>[];
  final pattern = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*|`(.+?)`');
  var cursor = 0;

  for (final match in pattern.allMatches(text)) {
    if (match.start > cursor) {
      spans.add(TextSpan(
        text: text.substring(cursor, match.start),
        style: baseStyle,
      ));
    }

    if (match.group(1) != null) {
      spans.add(TextSpan(
        text: match.group(1),
        style: baseStyle.copyWith(fontWeight: FontWeight.w700),
      ));
    } else if (match.group(2) != null) {
      spans.add(TextSpan(
        text: match.group(2),
        style: baseStyle.copyWith(fontStyle: FontStyle.italic),
      ));
    } else if (match.group(3) != null) {
      spans.add(TextSpan(
        text: match.group(3),
        style: tokens.monoStyle.copyWith(color: tokens.accent),
      ));
    }

    cursor = match.end;
  }

  if (cursor < text.length) {
    spans.add(TextSpan(
      text: text.substring(cursor),
      style: baseStyle,
    ));
  }

  return spans.isEmpty ? [TextSpan(text: text, style: baseStyle)] : spans;
}
