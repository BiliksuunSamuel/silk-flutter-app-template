import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// A swipe-to-confirm slider for high-stakes, irreversible actions.
/// The thumb snaps back if not dragged past the threshold; if it is,
/// [onConfirmed] fires once and the track shows a success state.
///
/// Usage:
/// ```dart
/// SilkSwipeToConfirm(
///   label: 'Swipe to send ₵500',
///   onConfirmed: _sendPayment,
/// )
/// ```
class SilkSwipeToConfirm extends StatefulWidget {
  const SilkSwipeToConfirm({
    required this.label,
    required this.onConfirmed,
    this.confirmedLabel = 'Confirmed',
    this.height = 56,
    this.thumbIcon = Icons.arrow_forward_rounded,
    super.key,
  });

  final String label;
  final VoidCallback onConfirmed;
  final String confirmedLabel;
  final double height;
  final IconData thumbIcon;

  @override
  State<SilkSwipeToConfirm> createState() => _SilkSwipeToConfirmState();
}

class _SilkSwipeToConfirmState extends State<SilkSwipeToConfirm>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  bool _confirmed = false;
  late AnimationController _snapCtrl;
  late Animation<double> _snapAnim;
  double _startDragX = 0;

  @override
  void initState() {
    super.initState();
    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _snapCtrl.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails d) {
    _startDragX = _dragX;
    _snapCtrl.stop();
  }

  void _onDragUpdate(DragUpdateDetails d, double maxDrag) {
    if (_confirmed) return;
    setState(() {
      _dragX = (_startDragX + d.localPosition.dx).clamp(0, maxDrag);
    });
  }

  void _onDragEnd(double maxDrag) {
    if (_confirmed) return;
    final threshold = maxDrag * 0.8;
    if (_dragX >= threshold) {
      setState(() {
        _dragX = maxDrag;
        _confirmed = true;
      });
      HapticFeedback.mediumImpact();
      widget.onConfirmed();
    } else {
      _snapAnim = Tween<double>(begin: _dragX, end: 0).animate(
        CurvedAnimation(parent: _snapCtrl, curve: Curves.elasticOut),
      )..addListener(() => setState(() => _dragX = _snapAnim.value));
      _snapCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final thumbSize = widget.height - 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final maxDrag = trackWidth - thumbSize - 8;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: _confirmed
                ? tokens.success.withValues(alpha: 0.12)
                : tokens.surfaceMuted,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(
              color: _confirmed ? tokens.success : tokens.divider,
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Progress fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: _dragX + thumbSize + 4,
                decoration: BoxDecoration(
                  color: (_confirmed ? tokens.success : tokens.accent)
                      .withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(widget.height / 2),
                ),
              ),
              // Label
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _confirmed ? widget.confirmedLabel : widget.label,
                    key: ValueKey(_confirmed),
                    style: tokens.bodyStyle.copyWith(
                      color: _confirmed
                          ? tokens.success
                          : tokens.onSurfaceMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Thumb
              Positioned(
                left: 4 + _dragX,
                child: GestureDetector(
                  onHorizontalDragStart: _onDragStart,
                  onHorizontalDragUpdate: (d) =>
                      _onDragUpdate(d, maxDrag),
                  onHorizontalDragEnd: (_) => _onDragEnd(maxDrag),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color:
                          _confirmed ? tokens.success : tokens.accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_confirmed
                                  ? tokens.success
                                  : tokens.accent)
                              .withValues(alpha: 0.35),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _confirmed
                          ? Icons.check_rounded
                          : widget.thumbIcon,
                      color: tokens.onAccent,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
