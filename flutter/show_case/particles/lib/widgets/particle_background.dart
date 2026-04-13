import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;
  Offset? touchPosition;
  final int particleCount = 180;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    particles = List.generate(particleCount, (_) => Particle.random());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles(Size size) {
    for (final p in particles) {
      final center = Offset(size.width / 2, size.height / 2);
      final toCenter = center - p.position;
      final distanceToCenter = toCenter.distance;

      if (distanceToCenter > 50) {
        final force = toCenter / distanceToCenter * 0.08;
        p.velocity += force;
      }

      if (touchPosition != null) {
        final toTouch = p.position - touchPosition!;
        final dist = toTouch.distance;
        if (dist < 250 && dist > 0) {
          final repelForce = toTouch / dist * (300 / (dist + 10));
          p.velocity += repelForce * 0.15;
        }
      }

      p.position += p.velocity;
      p.velocity *= 0.96;

      if (p.position.dx < 0 || p.position.dx > size.width) {
        p.velocity = p.velocity.scale(-0.8, 1);
      }
      if (p.position.dy < 0 || p.position.dy > size.height) {
        p.velocity = p.velocity.scale(1, -0.8);
      }

      p.position = Offset(
        p.position.dx.clamp(0, size.width),
        p.position.dy.clamp(0, size.height),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          touchPosition = details.localPosition;
        });
      },
      onPanEnd: (_) {
        setState(() {
          touchPosition = null;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              _updateParticles(size);

              return CustomPaint(
                size: size,
                painter: ParticlePainter(
                  particles: particles,
                  touchPosition: touchPosition,
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
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double opacity;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.opacity,
  });

  factory Particle.random() {
    final random = math.Random();
    return Particle(
      position: Offset(random.nextDouble() * 800, random.nextDouble() * 600),
      velocity: Offset(
        random.nextDouble() * 2 - 1,
        random.nextDouble() * 2 - 1,
      ),
      size: random.nextDouble() * 3.5 + 1.5,
      color: Colors.white,
      opacity: random.nextDouble() * 0.6 + 0.4,
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? touchPosition;

  ParticlePainter({required this.particles, this.touchPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.0;

    for (var i = 0; i < particles.length; i++) {
      for (var j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];
        final dist = (p1.position - p2.position).distance;
        if (dist < 120) {
          linePaint.color = Colors.white.withOpacity((1 - dist / 120) * 0.12);
          canvas.drawLine(p1.position, p2.position, linePaint);
        }
      }
    }

    for (final p in particles) {
      paint.color = p.color.withOpacity(p.opacity);
      canvas.drawCircle(p.position, p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
