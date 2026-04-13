import 'dart:math' as math;

import 'package:flutter/material.dart';

class ParticleFieldController {
  _ParticleBackgroundState? _state;

  void _attach(_ParticleBackgroundState state) {
    _state = state;
  }

  void _detach(_ParticleBackgroundState state) {
    if (_state == state) {
      _state = null;
    }
  }

  void triggerTap(Offset position) => _state?._triggerTapImpulse(position);

  void startDrag(Offset position) => _state?._setTouchPosition(position);

  void updateDrag(Offset position) => _state?._setTouchPosition(position);

  void endDrag() => _state?._clearTouchPosition();
}

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key, this.controller});

  final ParticleFieldController? controller;

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  static const int _particleCount = 280;
  static const double _burstRadius = 96;
  static const int _gatherFrames = 240;
  static const int _burstFrames = 88;

  late final AnimationController _controller;
  late final List<Particle> _particles;
  final math.Random _random = math.Random();
  Offset? _touchPosition;
  Offset? _tapImpulseCenter;
  double _tapImpulseStrength = 0;
  int _frame = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    _particles = List.generate(_particleCount, (_) => Particle.random(_random));
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    _controller.dispose();
    super.dispose();
  }

  void _triggerTapImpulse(Offset position) {
    setState(() {
      _touchPosition = position;
      _tapImpulseCenter = position;
      _tapImpulseStrength = 1.0;
    });
  }

  void _setTouchPosition(Offset position) {
    if (!mounted) {
      return;
    }
    setState(() {
      _touchPosition = position;
    });
  }

  void _clearTouchPosition() {
    if (!mounted) {
      return;
    }
    setState(() {
      _touchPosition = null;
    });
  }

  void _updateParticles(Size size) {
    if (size.isEmpty) {
      return;
    }

    _frame += 1;
    final center = Offset(size.width / 2, size.height / 2);
    final phaseLength = _gatherFrames + _burstFrames;
    final phaseFrame = _frame % phaseLength;
    final isBurstPhase = phaseFrame >= _gatherFrames;
    final gatherProgress = (phaseFrame / _gatherFrames).clamp(0.0, 1.0);
    final burstProgress =
        ((phaseFrame - _gatherFrames) / _burstFrames).clamp(0.0, 1.0);
    final gatherForce = isBurstPhase ? 0.02 : 0.035 + (gatherProgress * 0.09);
    final swirlForce =
        isBurstPhase ? 0.010 : 0.006 + math.sin(_frame / 20) * 0.002;
    final driftForce = isBurstPhase ? 0.016 : 0.006;
    final burstForce = isBurstPhase ? (1 - burstProgress) * 0.26 : 0.0;

    if (_tapImpulseStrength > 0.01) {
      _tapImpulseStrength *= 0.92;
    } else {
      _tapImpulseStrength = 0;
      _tapImpulseCenter = null;
    }

    for (final particle in _particles) {
      if (particle.position == Offset.zero) {
        particle.position = Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        );
      }

      final toCenter = center - particle.position;
      final distToCenter = math.max(toCenter.distance, 0.001);
      final centerDirection = toCenter / distToCenter;
      final tangentDirection = Offset(-centerDirection.dy, centerDirection.dx);
      final normalizedCenterDistance =
          (distToCenter / size.shortestSide).clamp(0.0, 1.0);

      particle.velocity += centerDirection * gatherForce;
      particle.velocity +=
          tangentDirection * swirlForce * particle.swirlDirection;
      particle.velocity += particle.drift * driftForce;

      if (isBurstPhase && distToCenter < size.shortestSide * 0.28) {
        final burstDirection = particle.position - center;
        final burstDistance = math.max(burstDirection.distance, 0.001);
        particle.velocity += (burstDirection / burstDistance) *
            burstForce *
            (1.4 - burstProgress);
      }

      if (_touchPosition != null) {
        final awayFromTouch = particle.position - _touchPosition!;
        final touchDistance = awayFromTouch.distance;
        if (touchDistance > 0 && touchDistance < 220) {
          final touchStrength = (1 - touchDistance / 220) * 0.7;
          particle.velocity +=
              (awayFromTouch / touchDistance) * touchStrength * 1.9;
        }
      }

      if (_tapImpulseCenter != null && _tapImpulseStrength > 0) {
        final awayFromTap = particle.position - _tapImpulseCenter!;
        final tapDistance = awayFromTap.distance;
        if (tapDistance > 0 && tapDistance < 260) {
          final impulseFalloff = 1 - tapDistance / 260;
          particle.velocity += (awayFromTap / tapDistance) *
              impulseFalloff *
              _tapImpulseStrength *
              8;
        }
      }

      if (!isBurstPhase && distToCenter < _burstRadius) {
        particle.velocity += Offset(
          (_random.nextDouble() - 0.5) * 0.16,
          (_random.nextDouble() - 0.5) * 0.16,
        );
      }

      particle.velocity *= 0.94 - normalizedCenterDistance * 0.04;
      particle.position += particle.velocity;

      if (particle.position.dx <= 0 || particle.position.dx >= size.width) {
        particle.velocity =
            Offset(-particle.velocity.dx * 0.88, particle.velocity.dy);
      }
      if (particle.position.dy <= 0 || particle.position.dy >= size.height) {
        particle.velocity =
            Offset(particle.velocity.dx, -particle.velocity.dy * 0.88);
      }

      particle.position = Offset(
        particle.position.dx.clamp(6, size.width - 6),
        particle.position.dy.clamp(6, size.height - 6),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              _updateParticles(size);

              return CustomPaint(
                size: size,
                painter: ParticlePainter(
                  particles: _particles,
                  touchPosition: _touchPosition,
                  tapImpulseCenter: _tapImpulseCenter,
                  tapImpulseStrength: _tapImpulseStrength,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Particle {
  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.opacity,
    required this.drift,
    required this.swirlDirection,
  });

  Offset position;
  Offset velocity;
  final double size;
  final Color color;
  final double opacity;
  final Offset drift;
  final double swirlDirection;

  factory Particle.random(math.Random random) {
    final hue = 190 + random.nextDouble() * 95;
    return Particle(
      position: Offset.zero,
      velocity: Offset(
        random.nextDouble() * 2.4 - 1.2,
        random.nextDouble() * 2.4 - 1.2,
      ),
      size: random.nextDouble() * 4 + 1.6,
      color: HSVColor.fromAHSV(1, hue, 0.72, 0.98).toColor(),
      opacity: random.nextDouble() * 0.45 + 0.38,
      drift: Offset(
        random.nextDouble() * 2 - 1,
        random.nextDouble() * 2 - 1,
      ),
      swirlDirection: random.nextBool() ? 1 : -1,
    );
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.particles,
    this.touchPosition,
    this.tapImpulseCenter,
    required this.tapImpulseStrength,
  });

  final List<Particle> particles;
  final Offset? touchPosition;
  final Offset? tapImpulseCenter;
  final double tapImpulseStrength;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final particlePaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.6);

    for (int i = 0; i < particles.length; i += 1) {
      for (int j = i + 2; j < particles.length; j += 2) {
        final p1 = particles[i];
        final p2 = particles[j];
        final distance = (p1.position - p2.position).distance;
        if (distance < 110) {
          linePaint.color = Colors.white.withValues(
            alpha: (1 - distance / 110).clamp(0.0, 1.0) * 0.12,
          );
          canvas.drawLine(p1.position, p2.position, linePaint);
        }
      }
    }

    if (touchPosition != null) {
      final touchPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: touchPosition!, radius: 120));
      canvas.drawCircle(touchPosition!, 120, touchPaint);
    }

    if (tapImpulseCenter != null && tapImpulseStrength > 0) {
      final ringPaint = Paint()
        ..color =
            const Color(0xFF67E8F9).withValues(alpha: 0.18 * tapImpulseStrength)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2;
      final ringRadius = 28 + (1 - tapImpulseStrength) * 84;
      canvas.drawCircle(tapImpulseCenter!, ringRadius, ringPaint);
    }

    for (final particle in particles) {
      particlePaint.color = particle.color.withValues(alpha: particle.opacity);
      canvas.drawCircle(particle.position, particle.size, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
