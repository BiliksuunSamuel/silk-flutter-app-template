import 'package:flutter/material.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

class SilkExpandable extends StatefulWidget {
  const SilkExpandable({
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.trailing,
    this.onExpansionChanged,
    super.key,
  });

  final Widget title;
  final Widget child;
  final bool initiallyExpanded;

  /// Replaces the default chevron. Pass null to keep the chevron.
  final Widget? trailing;

  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<SilkExpandable> createState() => _SilkExpandableState();
}

class _SilkExpandableState extends State<SilkExpandable>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _ctrl;
  late final Animation<double> _chevronTurn;
  late final Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: MotionTokens.standard,
      value: _expanded ? 1.0 : 0.0,
    );
    _chevronTurn = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: MotionTokens.standardCurve),
    );
    _heightFactor = CurvedAnimation(
      parent: _ctrl,
      curve: MotionTokens.emphasizedDecel,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    });
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: tokens.spaceMd),
            child: Row(
              children: [
                Expanded(child: widget.title),
                SizedBox(width: tokens.spaceSm),
                widget.trailing ??
                    RotationTransition(
                      turns: _chevronTurn,
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: tokens.onSurfaceMuted,
                        size: 20,
                      ),
                    ),
              ],
            ),
          ),
        ),
        // Animated body
        ClipRect(
          child: AnimatedBuilder(
            animation: _heightFactor,
            builder: (_, child) => Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: tokens.spaceMd),
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
