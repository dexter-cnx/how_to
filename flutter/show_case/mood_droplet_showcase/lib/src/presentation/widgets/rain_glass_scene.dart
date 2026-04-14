import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../engine/rain_scene_controller.dart';
import '../../models/showcase_config.dart';
import '../../painters/rain_drops_painter.dart';

class RainGlassScene extends StatelessWidget {
  const RainGlassScene({
    super.key,
    required this.controller,
    required this.config,
  });

  final RainSceneController controller;
  final ShowcaseConfig config;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final circleSize = math.min(size.width, size.height) * 0.94;

        return GestureDetector(
          onTapDown: (details) => _splashAt(details.localPosition, size),
          onPanUpdate: (details) => _splashAt(details.localPosition, size, intensity: 0.7),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(42),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: config.preset.backgroundTint),
                ),
                Center(
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          config.preset.centerGlow.withOpacity(config.preset.baseGlowOpacity * config.glowStrength),
                          config.preset.outerGlow.withOpacity(0.55 * config.glowStrength),
                          config.preset.outerGlow.withOpacity(0.18 * config.glowStrength),
                          Colors.white.withOpacity(0),
                        ],
                        stops: const [0, 0.4, 0.75, 1],
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: config.preset.baseBlur * config.blurSigma,
                        sigmaY: config.preset.baseBlur * config.blurSigma,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: RainDropsPainter(
                            drops: controller.drops,
                            blurMultiplier: config.blurSigma,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      config.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: config.preset.textColor,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w400,
                        height: 1.28,
                        shadows: [
                          Shadow(
                            blurRadius: 30,
                            color: config.preset.centerGlow.withOpacity(0.42),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const _DeviceChrome(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _splashAt(Offset localPosition, Size size, {double intensity = 1}) {
    final normalized = Offset(
      localPosition.dx / size.width,
      localPosition.dy / size.height,
    );
    controller.splashAt(normalized, intensity: intensity * config.intensity);
  }
}

class _DeviceChrome extends StatelessWidget {
  const _DeviceChrome();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 28),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 120,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Showcase', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('11:17', style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    Icon(Icons.signal_cellular_4_bar, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.wifi, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, size: 16),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, size: 22, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
