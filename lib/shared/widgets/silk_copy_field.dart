import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Read-only field displaying a value with a one-tap copy-to-clipboard button.
/// Ideal for account numbers, reference codes, wallet addresses.
///
/// Usage:
/// ```dart
/// SilkCopyField(
///   label: 'Account number',
///   value: '0123456789',
/// )
/// ```
class SilkCopyField extends StatefulWidget {
  const SilkCopyField({
    required this.value,
    this.label,
    this.obscure = false,
    this.copiedLabel = 'Copied!',
    super.key,
  });

  final String value;
  final String? label;

  /// When true, shows the value masked as ••••  followed by the last 4 chars.
  final bool obscure;

  final String copiedLabel;

  @override
  State<SilkCopyField> createState() => _SilkCopyFieldState();
}

class _SilkCopyFieldState extends State<SilkCopyField> {
  bool _copied = false;

  String get _displayValue {
    if (!widget.obscure || widget.value.length <= 4) return widget.value;
    final tail = widget.value.substring(widget.value.length - 4);
    return '•••• •••• $tail';
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
          ),
          SizedBox(height: tokens.spaceXs),
        ],
        Container(
          decoration: BoxDecoration(
            color: tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(tokens.radiusMd),
            border: Border.all(color: tokens.divider),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spaceMd,
            vertical: tokens.spaceMd,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _displayValue,
                  style: tokens.bodyStyle.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                    letterSpacing: widget.obscure ? 1.5 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: tokens.spaceSm),
              GestureDetector(
                onTap: _copied ? null : _copy,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _copied
                      ? Row(
                          key: const ValueKey('copied'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: tokens.success,
                            ),
                            SizedBox(width: tokens.spaceXs),
                            Text(
                              widget.copiedLabel,
                              style: tokens.captionStyle
                                  .copyWith(color: tokens.success),
                            ),
                          ],
                        )
                      : Icon(
                          Icons.copy_outlined,
                          key: const ValueKey('copy'),
                          size: 18,
                          color: tokens.onSurfaceMuted,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
