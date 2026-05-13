import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkExpandableText extends StatefulWidget {
  const SilkExpandableText({
    required this.text,
    this.maxLines = 3,
    this.expandText = 'Read more',
    this.collapseText = 'Show less',
    this.style,
    super.key,
  });

  final String text;
  final int maxLines;
  final String expandText;
  final String collapseText;

  /// Overrides the default body text style.
  final TextStyle? style;

  @override
  State<SilkExpandableText> createState() => _SilkExpandableTextState();
}

class _SilkExpandableTextState extends State<SilkExpandableText> {
  bool _expanded = false;
  bool _needsTruncation = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final style = widget.style ?? tokens.bodyStyle.copyWith(color: tokens.onSurface);

    return LayoutBuilder(
      builder: (context, constraints) {
        final tp = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        _needsTruncation = tp.didExceedMaxLines;

        return AnimatedSize(
          duration: MotionTokens.standard,
          curve: MotionTokens.emphasizedDecel,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: style,
                maxLines: _expanded ? null : widget.maxLines,
                overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              if (_needsTruncation) ...[
                SizedBox(height: tokens.spaceXs),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? widget.collapseText : widget.expandText,
                    style: tokens.bodySmStyle.copyWith(
                      color: tokens.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
