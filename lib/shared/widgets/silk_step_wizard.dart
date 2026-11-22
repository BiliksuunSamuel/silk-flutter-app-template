import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

@immutable
class SilkWizardStep {
  const SilkWizardStep({
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;
}

/// Multi-step form wizard with animated slide transitions, a step indicator,
/// and built-in next / back navigation.
///
/// Usage:
/// ```dart
/// SilkStepWizard(
///   steps: [
///     SilkWizardStep(title: 'Personal info', child: _PersonalForm()),
///     SilkWizardStep(title: 'Documents', child: _DocsForm()),
///     SilkWizardStep(title: 'Review', child: _ReviewScreen()),
///   ],
///   onFinish: _submit,
/// )
/// ```
class SilkStepWizard extends StatefulWidget {
  const SilkStepWizard({
    required this.steps,
    this.onFinish,
    this.finishLabel = 'Submit',
    this.nextLabel = 'Next',
    this.backLabel = 'Back',
    this.canProceed = true,
    super.key,
  });

  final List<SilkWizardStep> steps;
  final VoidCallback? onFinish;
  final String finishLabel;
  final String nextLabel;
  final String backLabel;

  /// Set to false to disable the Next button on the current step.
  final bool canProceed;

  @override
  State<SilkStepWizard> createState() => _SilkStepWizardState();
}

class _SilkStepWizardState extends State<SilkStepWizard> {
  int _current = 0;
  bool _forward = true;

  void _next() {
    if (_current < widget.steps.length - 1) {
      setState(() {
        _forward = true;
        _current++;
      });
    } else {
      widget.onFinish?.call();
    }
  }

  void _back() {
    if (_current > 0) {
      setState(() {
        _forward = false;
        _current--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isLast = _current == widget.steps.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step indicator
        _StepIndicator(
          count: widget.steps.length,
          current: _current,
        ),
        SizedBox(height: tokens.spaceLg),
        // Step title
        Text(
          widget.steps[_current].title,
          style: tokens.titleStyle,
        ),
        SizedBox(height: tokens.spaceMd),
        // Animated content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) {
            final offset = _forward
                ? const Offset(1, 0)
                : const Offset(-1, 0);
            return SlideTransition(
              position: Tween(begin: offset, end: Offset.zero).animate(anim),
              child: FadeTransition(opacity: anim, child: child),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(_current),
            child: widget.steps[_current].child,
          ),
        ),
        SizedBox(height: tokens.spaceLg),
        // Navigation
        Row(
          children: [
            if (_current > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _back,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: tokens.onSurface,
                    side: BorderSide(color: tokens.divider),
                    padding: EdgeInsets.symmetric(vertical: tokens.spaceMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(tokens.radiusMd),
                    ),
                  ),
                  child: Text(widget.backLabel),
                ),
              ),
            if (_current > 0) SizedBox(width: tokens.spaceSm),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: widget.canProceed ? _next : null,
                style: FilledButton.styleFrom(
                  backgroundColor: tokens.accent,
                  disabledBackgroundColor:
                      tokens.accent.withValues(alpha: 0.4),
                  padding: EdgeInsets.symmetric(vertical: tokens.spaceMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.radiusMd),
                  ),
                ),
                child: Text(
                  isLast ? widget.finishLabel : widget.nextLabel,
                  style: TextStyle(
                    color: tokens.onAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: tokens.spaceXs),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 4,
              decoration: BoxDecoration(
                color: i <= current ? tokens.accent : tokens.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
