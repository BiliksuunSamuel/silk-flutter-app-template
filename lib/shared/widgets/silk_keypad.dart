import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

/// Numeric keypad for PIN entry or amount input.
///
/// Usage:
/// ```dart
/// SilkKeypad(
///   onKeyTap: (digit) => setState(() => _pin += digit),
///   onDelete: () => setState(() {
///     if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
///   }),
/// )
/// ```
class SilkKeypad extends StatelessWidget {
  const SilkKeypad({
    required this.onKeyTap,
    required this.onDelete,
    this.showDecimal = false,
    super.key,
  });

  final void Function(String digit) onKeyTap;
  final VoidCallback onDelete;

  /// Shows a decimal point key in the bottom-left slot.
  /// When false, that slot is left empty.
  final bool showDecimal;

  static const _digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 3; row++) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var col = 0; col < 3; col++) ...[
                if (col > 0) SizedBox(width: tokens.spaceXs),
                _KeyButton(
                  label: _digits[row * 3 + col],
                  onTap: () => onKeyTap(_digits[row * 3 + col]),
                ),
              ],
            ],
          ),
          SizedBox(height: tokens.spaceXs),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _KeyButton(
              label: showDecimal ? '.' : null,
              onTap: showDecimal ? () => onKeyTap('.') : null,
            ),
            SizedBox(width: tokens.spaceXs),
            _KeyButton(label: '0', onTap: () => onKeyTap('0')),
            SizedBox(width: tokens.spaceXs),
            _KeyButton(icon: Icons.backspace_outlined, onTap: onDelete),
          ],
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({this.label, this.icon, this.onTap});

  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    if (label == null && icon == null) {
      return const SizedBox(width: 80, height: 56);
    }

    Widget content;
    if (icon != null) {
      content = Icon(icon, size: 22, color: tokens.onSurface);
    } else {
      content = Text(
        label!,
        style: tokens.titleStyle.copyWith(
          fontWeight: FontWeight.w400,
          color: tokens.onSurface,
        ),
      );
    }

    final cell = Container(
      width: 80,
      height: 56,
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
      ),
      alignment: Alignment.center,
      child: content,
    );

    if (onTap == null) return cell;

    return SilkReactionBurst(
      onTap: onTap,
      color: tokens.accent,
      particleCount: 6,
      spreadRadius: 24,
      child: cell,
    );
  }
}
