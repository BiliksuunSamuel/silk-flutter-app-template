import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:silk/core/motion/haptics.dart';
import 'package:silk/core/motion/motion_tokens.dart';
import 'package:silk/core/theme/context_tokens_extension.dart';

/// Wraps a widget and plays a particle burst when tapped.
///
/// The burst renders in the app Overlay so particles escape parent clip bounds.
/// Use [SilkReactionBurst.trigger] to fire the effect imperatively from any
/// context (e.g. after an async state change).
class SilkReactionBurst extends StatefulWidget {
  const SilkReactionBurst({
    required this.child,
    this.onTap,
    this.color,
    this.particleCount = 12,
    this.spreadRadius = 52.0,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Particle color. Defaults to [AppTokens.accent].
  final Color? color;

  /// Number of particles in the burst.
  final int particleCount;

  /// How far particles travel from the center, in logical pixels.
  final double spreadRadius;

  /// Programmatically fire a burst centred on [context]'s render object.
  static void trigger({
    required BuildContext context,
    required Color color,
    int particleCount = 12,
    double spreadRadius = 52,
  }) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    _spawnBurst(
      context: context,
      center: box.localToGlobal(box.size.center(Offset.zero)),
      color: color,
      particleCount: particleCount,
      spreadRadius: spreadRadius,
    );
  }

  static void _spawnBurst({
    required BuildContext context,
    required Offset center,
    required Color color,
    required int particleCount,
    required double spreadRadius,
  }) {
    final overlay = Overlay.of(context);
    var removed = false;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _BurstLayer(
        center: center,
        color: color,
        particleCount: particleCount,
        spreadRadius: spreadRadius,
        onDone: () {
          if (removed) return;
          removed = true;
          SchedulerBinding.instance.addPostFrameCallback((_) => entry.remove());
        },
      ),
    );
    overlay.insert(entry);
  }

  @override
  State<SilkReactionBurst> createState() => _SilkReactionBurstState();
}

class _SilkReactionBurstState extends State<SilkReactionBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    // press → 0.82, release → 1.28 (overshoot), settle → 1.0
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.82), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.28), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.28, end: 1), weight: 40),
    ]).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: MotionTokens.emphasizedDecel),
    );
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _bounceCtrl.forward(from: 0);
  }

  void _onTapUp(TapUpDetails _) {
    final color = widget.color ?? context.tokens.accent;
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.attached) {
      SilkReactionBurst._spawnBurst(
        context: context,
        center: box.localToGlobal(box.size.center(Offset.zero)),
        color: color,
        particleCount: widget.particleCount,
        spreadRadius: widget.spreadRadius,
      );
    }
    Haptics.medium();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _bounceCtrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: widget.child,
      ),
    );
  }
}

// ─── Overlay layer ──────────────────────────────────────────────────────────

class _BurstLayer extends StatefulWidget {
  const _BurstLayer({
    required this.center,
    required this.color,
    required this.particleCount,
    required this.spreadRadius,
    required this.onDone,
  });

  final Offset center;
  final Color color;
  final int particleCount;
  final double spreadRadius;
  final VoidCallback onDone;

  @override
  State<_BurstLayer> createState() => _BurstLayerState();
}

class _BurstLayerState extends State<_BurstLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_ParticleSpec> _specs;

  @override
  void initState() {
    super.initState();

    final rand = math.Random();
    final n = widget.particleCount;

    // Evenly spaced angles with small random jitter.
    // First 70%: larger, far particles. Rest: small, close satellites.
    _specs = List.generate(n, (i) {
      final primary = i < (n * 0.7).ceil();
      final baseAngle = (2 * math.pi / n) * i;
      return _ParticleSpec(
        angle: baseAngle + (rand.nextDouble() - 0.5) * 0.6,
        distance: widget.spreadRadius *
            (primary ? 1.0 : 0.55) *
            (0.65 + rand.nextDouble() * 0.35),
        size: primary
            ? 5.0 + rand.nextDouble() * 4.0
            : 3.0 + rand.nextDouble() * 2.5,
        // Slight upward drift — heavier particles pulled down less.
        drift: primary ? 0.0 : -6.0 * rand.nextDouble(),
        startDelay: rand.nextDouble() * 0.07,
        // Mix of accent and a lighter tint for variety.
        colorShift: rand.nextDouble() > 0.7 ? 0.35 : 0.0,
      );
    });

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    )..forward().then((_) => widget.onDone());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Stack(
            children: _specs.map((spec) {
              // Travel: decelerate to final position.
              final travelT = _interval(
                spec.startDelay,
                1,
                MotionTokens.emphasizedDecel,
              ).value;

              // Fade out: start at 50% of animation.
              final fadeT = _interval(
                spec.startDelay + 0.5,
                1,
                Curves.easeIn,
              ).value;

              // Scale: grow 0→1 over first 25%, then shrink 1→0 over last 40%.
              final growT = _interval(
                spec.startDelay,
                spec.startDelay + 0.25,
                Curves.easeOut,
              ).value;
              final shrinkT = _interval(0.6, 1, Curves.easeIn).value;

              final dx = math.cos(spec.angle) * spec.distance * travelT;
              final dy = math.sin(spec.angle) * spec.distance * travelT +
                  spec.drift * travelT;

              final opacity = (1 - fadeT).clamp(0.0, 1.0);
              final scale =
                  (growT * (1 - shrinkT * 0.9)).clamp(0.0, 1.0);

              final color = spec.colorShift > 0
                  ? Color.lerp(
                      widget.color,
                      Colors.white.withValues(alpha: 0.9),
                      spec.colorShift,
                    )!
                  : widget.color;

              return Positioned(
                left: widget.center.dx + dx - spec.size / 2,
                top: widget.center.dy + dy - spec.size / 2,
                width: spec.size,
                height: spec.size,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // Returns a curved animation over a sub-interval [start, end] of _ctrl.
  CurvedAnimation _interval(double start, double end, Curve curve) {
    return CurvedAnimation(
      parent: _ctrl,
      curve: Interval(start.clamp(0, 1), end.clamp(0, 1), curve: curve),
    );
  }
}

// ─── Particle data ───────────────────────────────────────────────────────────

class _ParticleSpec {
  const _ParticleSpec({
    required this.angle,
    required this.distance,
    required this.size,
    required this.drift,
    required this.startDelay,
    required this.colorShift,
  });

  final double angle;
  final double distance;
  final double size;
  final double drift;      // vertical drift offset in px (negative = up)
  final double startDelay; // 0.0–0.07, fraction of total duration
  final double colorShift; // 0 = base color, 0.35 = tinted toward white
}
