import 'dart:math' as math;

import 'package:flutter/material.dart';

/// One-shot celebratory confetti burst rendered in an [Overlay].
/// Call [SilkConfetti.burst] from anywhere — no widget setup needed.
///
/// Usage:
/// ```dart
/// SilkConfetti.burst(context);
/// ```
abstract class SilkConfetti {
  static void burst(
    BuildContext context, {
    int particleCount = 120,
    Duration duration = const Duration(milliseconds: 2200),
    List<Color>? colors,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ConfettiOverlay(
        particleCount: particleCount,
        duration: duration,
        colors: colors,
        onDone: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _ConfettiOverlay extends StatefulWidget {
  const _ConfettiOverlay({
    required this.particleCount,
    required this.duration,
    required this.onDone,
    this.colors,
  });

  final int particleCount;
  final Duration duration;
  final VoidCallback onDone;
  final List<Color>? colors;

  @override
  State<_ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<_ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;

  static const _defaultColors = [
    Color(0xFF6366F1),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) widget.onDone();
      })
      ..forward();

    final rng = math.Random();
    final colors = widget.colors ?? _defaultColors;
    _particles = List.generate(widget.particleCount, (_) {
      return _Particle(
        color: colors[rng.nextInt(colors.length)],
        startX: rng.nextDouble(),
        velocityX: (rng.nextDouble() - 0.5) * 0.6,
        velocityY: rng.nextDouble() * 0.4 + 0.4,
        size: rng.nextDouble() * 8 + 5,
        rotation: rng.nextDouble() * math.pi * 2,
        rotationSpeed: (rng.nextDouble() - 0.5) * 12,
        isCircle: rng.nextBool(),
        delay: rng.nextDouble() * 0.3,
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _ConfettiPainter(
          particles: _particles,
          progress: _ctrl.value,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.color,
    required this.startX,
    required this.velocityX,
    required this.velocityY,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.isCircle,
    required this.delay,
  });

  final Color color;
  final double startX;
  final double velocityX;
  final double velocityY;
  final double size;
  final double rotation;
  final double rotationSpeed;
  final bool isCircle;

  /// Particle starts appearing after this fraction of total duration.
  final double delay;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      // Gravity: y accelerates quadratically
      final x = (p.startX + p.velocityX * t) * size.width;
      final y = (p.velocityY * t + 0.5 * t * t) * size.height;

      // Fade out in the last 25% of each particle's life
      final opacity = t < 0.75 ? 1.0 : (1.0 - t) / 0.25;
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity.clamp(0.0, 1.0));

      canvas
        ..save()
        ..translate(x, y)
        ..rotate(p.rotation + p.rotationSpeed * t);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.5,
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
