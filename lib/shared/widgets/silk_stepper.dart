import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';
import 'package:silk/shared/widgets/silk_reaction_burst.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

class SilkStep {
  const SilkStep({
    required this.label,
    this.description,
    this.icon,
  });

  final String label;
  final String? description;

  /// Overrides the default node icon. Only shown for [SilkStepStatus.completed]
  /// and [SilkStepStatus.active] nodes; pending nodes always show the index.
  final IconData? icon;
}

enum SilkStepStatus { completed, active, pending }

// ── Component ─────────────────────────────────────────────────────────────────

class SilkStepper extends StatelessWidget {
  const SilkStepper({
    required this.steps,
    required this.currentStep,
    this.axis = Axis.vertical,
    this.onStepTap,
    super.key,
  }) : assert(
          currentStep >= 0 && currentStep < steps.length,
          'currentStep must be a valid index into steps',
        );

  final List<SilkStep> steps;

  /// Zero-based index of the currently active step.
  final int currentStep;

  /// [Axis.vertical] (default) stacks steps top-to-bottom.
  /// [Axis.horizontal] lays them out left-to-right, labels below the nodes.
  final Axis axis;

  /// Called when a step node is tapped. Wire this up to update [currentStep].
  final void Function(int index)? onStepTap;

  SilkStepStatus _statusOf(int index) {
    if (index < currentStep) return SilkStepStatus.completed;
    if (index == currentStep) return SilkStepStatus.active;
    return SilkStepStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    return axis == Axis.vertical
        ? _VerticalStepper(steps: steps, statusOf: _statusOf, onStepTap: onStepTap)
        : _HorizontalStepper(steps: steps, statusOf: _statusOf, onStepTap: onStepTap);
  }
}

// ── Vertical layout ───────────────────────────────────────────────────────────

class _VerticalStepper extends StatelessWidget {
  const _VerticalStepper({
    required this.steps,
    required this.statusOf,
    required this.onStepTap,
  });

  final List<SilkStep> steps;
  final SilkStepStatus Function(int) statusOf;
  final void Function(int)? onStepTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < steps.length; i++)
          _VerticalStepRow(
            step: steps[i],
            index: i,
            status: statusOf(i),
            isLast: i == steps.length - 1,
            onTap: onStepTap != null ? () => onStepTap!(i) : null,
          ),
      ],
    );
  }
}

class _VerticalStepRow extends StatelessWidget {
  const _VerticalStepRow({
    required this.step,
    required this.index,
    required this.status,
    required this.isLast,
    required this.onTap,
  });

  final SilkStep step;
  final int index;
  final SilkStepStatus status;

  /// Whether this is the last step in the list.
  final bool isLast;
  final VoidCallback? onTap;

  static const double _nodeSize = 28;
  static const double _connectorWidth = 2;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final nodeColor = switch (status) {
      SilkStepStatus.completed => tokens.accent,
      SilkStepStatus.active    => tokens.accent,
      SilkStepStatus.pending   => tokens.surfaceMuted,
    };

    final connectorColor = status == SilkStepStatus.completed
        ? tokens.accent
        : tokens.surfaceMuted;

    final labelStyle = switch (status) {
      SilkStepStatus.active  => tokens.bodySmStyle.copyWith(color: tokens.onSurface, fontWeight: FontWeight.w600),
      SilkStepStatus.pending => tokens.bodySmStyle.copyWith(color: tokens.onSurfaceMuted),
      _                      => tokens.bodySmStyle.copyWith(color: tokens.onSurface),
    };

    final description = step.description;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Node + connector column
        Column(
          children: [
            _TappableNode(
              status: status,
              index: index,
              nodeColor: nodeColor,
              nodeSize: _nodeSize,
              icon: step.icon,
              isFinal: isLast,
              onTap: onTap,
            ),
            if (!isLast)
              AnimatedContainer(
                duration: MotionTokens.emphasized,
                curve: MotionTokens.emphasizedDecel,
                width: _connectorWidth,
                height: 40,
                color: connectorColor,
              ),
          ],
        ),

        SizedBox(width: tokens.spaceMd),

        // Label + description
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: (_nodeSize - (tokens.bodySmStyle.fontSize ?? 14)) / 2,
              bottom: isLast ? 0 : tokens.spaceLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: MotionTokens.standard,
                  curve: MotionTokens.standardCurve,
                  style: labelStyle,
                  child: Text(step.label),
                ),
                if (description != null) ...[
                  SizedBox(height: tokens.spaceXs),
                  Text(
                    description,
                    style: tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Horizontal layout ─────────────────────────────────────────────────────────

class _HorizontalStepper extends StatelessWidget {
  const _HorizontalStepper({
    required this.steps,
    required this.statusOf,
    required this.onStepTap,
  });

  final List<SilkStep> steps;
  final SilkStepStatus Function(int) statusOf;
  final void Function(int)? onStepTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _HorizontalStepColumn(
              step: steps[i],
              index: i,
              status: statusOf(i),
              isLast: i == steps.length - 1,
              onTap: onStepTap != null ? () => onStepTap!(i) : null,
            ),
          ),

          if (i < steps.length - 1)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: tokens.spaceLg),
                child: _AnimatedConnector(
                  completed: statusOf(i) == SilkStepStatus.completed,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _HorizontalStepColumn extends StatelessWidget {
  const _HorizontalStepColumn({
    required this.step,
    required this.index,
    required this.status,
    required this.isLast,
    required this.onTap,
  });

  final SilkStep step;
  final int index;
  final SilkStepStatus status;
  final bool isLast;
  final VoidCallback? onTap;

  static const double _nodeSize = 28;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    final nodeColor = switch (status) {
      SilkStepStatus.completed => tokens.accent,
      SilkStepStatus.active    => tokens.accent,
      SilkStepStatus.pending   => tokens.surfaceMuted,
    };

    final labelStyle = switch (status) {
      SilkStepStatus.active  => tokens.captionStyle.copyWith(color: tokens.onSurface, fontWeight: FontWeight.w600),
      SilkStepStatus.pending => tokens.captionStyle.copyWith(color: tokens.onSurfaceMuted),
      _                      => tokens.captionStyle.copyWith(color: tokens.onSurface),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TappableNode(
          status: status,
          index: index,
          nodeColor: nodeColor,
          nodeSize: _nodeSize,
          icon: step.icon,
          isFinal: isLast,
          onTap: onTap,
        ),
        SizedBox(height: tokens.spaceXs),
        AnimatedDefaultTextStyle(
          duration: MotionTokens.standard,
          curve: MotionTokens.standardCurve,
          style: labelStyle,
          child: Text(step.label, textAlign: TextAlign.center, maxLines: 2),
        ),
      ],
    );
  }
}

class _AnimatedConnector extends StatelessWidget {
  const _AnimatedConnector({required this.completed});

  final bool completed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Center(
      child: AnimatedContainer(
        duration: MotionTokens.emphasized,
        curve: MotionTokens.emphasizedDecel,
        height: 2,
        color: completed ? tokens.accent : tokens.surfaceMuted,
      ),
    );
  }
}

// ── Tappable node — burst on tap + pulse ring when active ─────────────────────

class _TappableNode extends StatelessWidget {
  const _TappableNode({
    required this.status,
    required this.index,
    required this.nodeColor,
    required this.nodeSize,
    required this.isFinal,
    required this.onTap,
    this.icon,
  });

  final SilkStepStatus status;
  final int index;
  final Color nodeColor;
  final double nodeSize;
  final bool isFinal;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    Widget node = _PulseRing(
      active: status == SilkStepStatus.active,
      nodeSize: nodeSize,
      color: tokens.accent,
      child: _NodeDisc(
        status: status,
        index: index,
        nodeColor: nodeColor,
        nodeSize: nodeSize,
        isFinal: isFinal,
        icon: icon,
      ),
    );

    if (onTap != null) {
      node = SilkReactionBurst(
        onTap: onTap,
        color: status == SilkStepStatus.pending
            ? tokens.onSurfaceMuted
            : tokens.accent,
        particleCount: 8,
        spreadRadius: 28,
        child: node,
      );
    }

    return node;
  }
}

// ── Pulse ring — repeating expanding ring on the active node ──────────────────

class _PulseRing extends StatefulWidget {
  const _PulseRing({
    required this.active,
    required this.nodeSize,
    required this.color,
    required this.child,
  });

  final bool active;
  final double nodeSize;
  final Color color;
  final Widget child;

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.active) _ctrl.repeat();
  }

  @override
  void didUpdateWidget(_PulseRing old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      _ctrl.repeat();
    } else if (!widget.active && old.active) {
      _ctrl
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final t = Curves.easeOut.transform(_ctrl.value);
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer expanding ring
            Transform.scale(
              scale: 1.0 + t * 1.0,
              child: Opacity(
                opacity: (1.0 - t) * 0.3,
                child: Container(
                  width: widget.nodeSize,
                  height: widget.nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.color, width: 2),
                  ),
                ),
              ),
            ),
            // Inner ring — offset by half a period for a layered heartbeat feel
            Transform.scale(
              scale: 1.0 + ((t + 0.5) % 1.0) * 1.0,
              child: Opacity(
                opacity: (1.0 - (t + 0.5) % 1.0) * 0.15,
                child: Container(
                  width: widget.nodeSize,
                  height: widget.nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }
}

// ── Node disc (visual only) ───────────────────────────────────────────────────

class _NodeDisc extends StatelessWidget {
  const _NodeDisc({
    required this.status,
    required this.index,
    required this.nodeColor,
    required this.nodeSize,
    required this.isFinal,
    this.icon,
  });

  final SilkStepStatus status;
  final int index;
  final Color nodeColor;
  final double nodeSize;
  final bool isFinal;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isActive = status == SilkStepStatus.active;
    final isCompleted = status == SilkStepStatus.completed;
    // Active on the last step renders filled, same as completed.
    final filledActive = isActive && isFinal;

    Widget nodeContent;
    if (isCompleted || filledActive) {
      nodeContent = Icon(
        icon ?? Icons.check_rounded,
        size: nodeSize * 0.55,
        color: tokens.onAccent,
      );
    } else if (isActive) {
      nodeContent = icon != null
          ? Icon(icon, size: nodeSize * 0.55, color: tokens.onAccent)
          : Text(
              '${index + 1}',
              style: tokens.labelStyle.copyWith(
                color: tokens.onAccent,
                fontWeight: FontWeight.w700,
              ),
            );
    } else {
      nodeContent = Text(
        '${index + 1}',
        style: tokens.labelStyle.copyWith(
          color: tokens.onSurfaceMuted,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return AnimatedContainer(
      duration: MotionTokens.emphasized,
      curve: MotionTokens.emphasizedDecel,
      width: nodeSize,
      height: nodeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (isActive && !filledActive) ? Colors.transparent : nodeColor,
        border: (isActive && !filledActive)
            ? Border.all(color: tokens.accent, width: 2.5)
            : null,
      ),
      child: Center(child: nodeContent),
    );
  }
}
