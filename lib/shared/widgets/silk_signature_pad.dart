import 'package:flutter/material.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Controller for [SilkSignaturePad] — call [clear] to reset the canvas.
class SilkSignaturePadController extends ChangeNotifier {
  final List<List<Offset>> _strokes = [];

  List<List<Offset>> get strokes => List.unmodifiable(_strokes);

  bool get isEmpty => _strokes.isEmpty;

  void _addPoint(Offset point) {
    if (_strokes.isEmpty) _strokes.add([]);
    _strokes.last.add(point);
    notifyListeners();
  }

  void _endStroke() {
    _strokes.add([]);
    notifyListeners();
  }

  void clear() {
    _strokes.clear();
    notifyListeners();
  }
}

/// A freehand signature capture canvas. Use [SilkSignaturePadController.clear]
/// to reset, and [controller.isEmpty] to validate before submission.
///
/// Usage:
/// ```dart
/// final _sigCtrl = SilkSignaturePadController();
///
/// SilkSignaturePad(controller: _sigCtrl)
/// ```
class SilkSignaturePad extends StatefulWidget {
  const SilkSignaturePad({
    required this.controller,
    this.height = 200,
    this.strokeColor,
    this.strokeWidth = 2.5,
    this.backgroundColor,
    this.hint = 'Sign here',
    this.onChanged,
    super.key,
  });

  final SilkSignaturePadController controller;
  final double height;
  final Color? strokeColor;
  final double strokeWidth;
  final Color? backgroundColor;
  final String hint;
  final VoidCallback? onChanged;

  @override
  State<SilkSignaturePad> createState() => _SilkSignaturePadState();
}

class _SilkSignaturePadState extends State<SilkSignaturePad> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(SilkSignaturePad old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_rebuild);
      widget.controller.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final strokeColor = widget.strokeColor ?? tokens.onSurface;
    final bg = widget.backgroundColor ?? tokens.surfaceMuted;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
        border: Border.all(color: tokens.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: (d) {
              widget.controller._addPoint(d.localPosition);
            },
            onPanUpdate: (d) {
              widget.controller._addPoint(d.localPosition);
            },
            onPanEnd: (_) {
              widget.controller._endStroke();
            },
            child: CustomPaint(
              painter: _SignaturePainter(
                strokes: widget.controller.strokes,
                strokeColor: strokeColor,
                strokeWidth: widget.strokeWidth,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          if (widget.controller.isEmpty)
            Center(
              child: Text(
                widget.hint,
                style: tokens.bodyStyle.copyWith(
                  color: tokens.onSurfaceMuted.withValues(alpha: 0.5),
                ),
              ),
            ),
          Positioned(
            bottom: tokens.spaceSm,
            left: tokens.spaceMd,
            right: tokens.spaceMd,
            child: Divider(color: tokens.divider, height: 1),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter({
    required this.strokes,
    required this.strokeColor,
    required this.strokeWidth,
  });

  final List<List<Offset>> strokes;
  final Color strokeColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke[0].dx, stroke[0].dy);
      for (var i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) =>
      old.strokes != strokes ||
      old.strokeColor != strokeColor ||
      old.strokeWidth != strokeWidth;
}
