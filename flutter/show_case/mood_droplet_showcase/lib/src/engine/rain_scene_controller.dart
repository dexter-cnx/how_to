import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../models/drop_state.dart';
import '../models/raindrop.dart';
import '../models/showcase_config.dart';

class RainSceneController extends ChangeNotifier {
  RainSceneController({math.Random? random}) : _random = random ?? math.Random() {
    seedInitialDrops();
  }

  final math.Random _random;
  final List<Raindrop> _drops = [];

  List<Raindrop> get drops => List.unmodifiable(_drops);

  void seedInitialDrops() {
    _drops
      ..clear()
      ..addAll(List.generate(38, (_) => _buildStuckDrop()));
    notifyListeners();
  }

  void reset() => seedInitialDrops();

  void tick(ShowcaseConfig config) {
    if (config.isPlaying) {
      _spawnNaturalRain(config);
      _updateDrops();
      notifyListeners();
    }
  }

  void splashAt(Offset normalizedOffset, {double intensity = 1}) {
    final clampedX = normalizedOffset.dx.clamp(0.0, 1.0);
    final clampedY = normalizedOffset.dy.clamp(0.0, 1.0);
    _spawnImpact(clampedX, clampedY, intensity: intensity);
    notifyListeners();
  }

  Raindrop _buildStuckDrop() {
    return Raindrop(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      w: _random.nextDouble() * 20 + 14,
      h: _random.nextDouble() * 24 + 14,
      rotation: _random.nextDouble() * math.pi,
      state: DropState.stuck,
      opacity: _random.nextDouble() * 0.2 + 0.74,
      life: 1,
      vx: 0,
      vy: 0,
    );
  }

  void _spawnNaturalRain(ShowcaseConfig config) {
    final chance = config.preset.baseSpawnChance * config.intensity;
    if (_random.nextDouble() < chance) {
      _spawnImpact(
        _random.nextDouble(),
        _random.nextDouble(),
        intensity: config.intensity,
      );
    }
  }

  void _spawnImpact(double impactX, double impactY, {double intensity = 1}) {
    _drops.add(
      Raindrop(
        x: impactX,
        y: impactY,
        w: _random.nextDouble() * 25 + 20,
        h: _random.nextDouble() * 30 + 20,
        rotation: _random.nextDouble() * math.pi,
        state: DropState.stuck,
        opacity: 0.92,
        life: 1,
        vx: 0,
        vy: 0,
      ),
    );

    final splashCount = (_random.nextInt(5) + 6 + intensity * 2).round();
    for (var i = 0; i < splashCount; i++) {
      final angle = (math.pi * 2 / splashCount) * i + _random.nextDouble() * 0.5;
      final speed = (_random.nextDouble() * 0.008 + 0.004) * intensity;
      _drops.add(
        Raindrop(
          x: impactX + math.cos(angle) * 0.02,
          y: impactY + math.sin(angle) * 0.02,
          w: _random.nextDouble() * 6 + 3,
          h: _random.nextDouble() * 8 + 3,
          rotation: _random.nextDouble() * math.pi,
          state: DropState.splashing,
          opacity: 0.82,
          life: 1,
          vx: math.cos(angle) * speed,
          vy: math.sin(angle) * speed,
        ),
      );
    }
  }

  void _updateDrops() {
    for (final drop in _drops) {
      switch (drop.state) {
        case DropState.splashing:
          drop.x += drop.vx;
          drop.y += drop.vy;
          drop.vx *= 0.92;
          drop.vy = drop.vy * 0.92 + 0.0008;
          drop.life -= 0.003;
          if (drop.vx.abs() < 0.0005) {
            drop.state = DropState.sliding;
            drop.vx = 0;
          }
        case DropState.sliding:
          drop.y += 0.001 + drop.vy;
          drop.x += math.sin(drop.y * 15) * 0.0002;
          drop.life -= 0.004;
        case DropState.stuck:
          drop.life -= 0.0003;
      }
      drop.opacity = (drop.life * 0.9).clamp(0.0, 1.0);
    }
    _drops.removeWhere((drop) => drop.life <= 0 || drop.y > 1.1);
  }
}
