import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/pressable_scale.dart';

@immutable
class SilkDialogAction {
  const SilkDialogAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isPrimary;
}

/// Token-styled modal dialog. Use [SilkDialog.show] for arbitrary content
/// and [SilkDialog.confirm] as a two-button confirmation shortcut.
///
/// Usage:
/// ```dart
/// final confirmed = await SilkDialog.confirm(
///   context: context,
///   title: 'Withdraw funds',
///   message: 'Are you sure you want to withdraw ₵500?',
///   confirmLabel: 'Withdraw',
///   isDestructive: true,
/// );
/// ```
abstract class SilkDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    List<SilkDialogAction>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => _SilkDialogWidget<T>(
        title: title,
        content: content,
        actions: actions ?? const [],
      ),
    );
  }

  /// Convenience shortcut — returns true if confirmed, false/null if cancelled.
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    return show<bool>(
      context: context,
      barrierDismissible: false,
      title: title,
      content: Builder(
        builder: (ctx) => Text(
          message,
          style: ctx.tokens.bodyStyle.copyWith(
            color: ctx.tokens.onSurfaceMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        SilkDialogAction(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        SilkDialogAction(
          label: confirmLabel,
          isPrimary: !isDestructive,
          isDestructive: isDestructive,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

class _SilkDialogWidget<T> extends StatelessWidget {
  const _SilkDialogWidget({
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final Widget content;
  final List<SilkDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.surface,
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          boxShadow: tokens.shadowFloating,
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: tokens.titleStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: tokens.spaceMd),
              content,
              if (actions.isNotEmpty) ...[
                SizedBox(height: tokens.spaceLg),
                Row(
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) SizedBox(width: tokens.spaceSm),
                      Expanded(child: _DialogButton(action: actions[i])),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.action});

  final SilkDialogAction action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final Color bg;
    final Color fg;

    if (action.isDestructive) {
      bg = tokens.danger;
      fg = Colors.white;
    } else if (action.isPrimary) {
      bg = tokens.accent;
      fg = tokens.onAccent;
    } else {
      bg = tokens.surface;
      fg = tokens.onSurface;
    }

    final filled = action.isDestructive || action.isPrimary;

    return PressableScale(
      onTap: action.onPressed,
      haptic: action.isPrimary ? PressHaptic.light : PressHaptic.selection,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          border: filled ? null : Border.all(color: tokens.hairlineStrong),
        ),
        alignment: Alignment.center,
        child: Text(
          action.label,
          style: tokens.titleSmStyle.copyWith(color: fg),
        ),
      ),
    );
  }
}
