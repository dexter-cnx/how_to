import 'dart:ui';

class RainPreset {
  const RainPreset({
    required this.name,
    required this.centerGlow,
    required this.outerGlow,
    required this.textColor,
    required this.baseSpawnChance,
    required this.baseBlur,
    required this.baseGlowOpacity,
    required this.backgroundTint,
  });

  final String name;
  final Color centerGlow;
  final Color outerGlow;
  final Color textColor;
  final double baseSpawnChance;
  final double baseBlur;
  final double baseGlowOpacity;
  final Color backgroundTint;

  static const calm = RainPreset(
    name: 'Calm',
    centerGlow: Color(0xFF0066FF),
    outerGlow: Color(0xFF99DDFF),
    textColor: Color(0xFFF6FAFF),
    baseSpawnChance: 0.10,
    baseBlur: 140,
    baseGlowOpacity: 0.95,
    backgroundTint: Color(0xFFF8FBFF),
  );

  static const storm = RainPreset(
    name: 'Storm',
    centerGlow: Color(0xFF2146FF),
    outerGlow: Color(0xFF6EA2FF),
    textColor: Color(0xFFF8FBFF),
    baseSpawnChance: 0.18,
    baseBlur: 180,
    baseGlowOpacity: 1.0,
    backgroundTint: Color(0xFFF2F5FB),
  );

  static const night = RainPreset(
    name: 'Night',
    centerGlow: Color(0xFF1035A6),
    outerGlow: Color(0xFF6C8EFF),
    textColor: Color(0xFFEAF2FF),
    baseSpawnChance: 0.12,
    baseBlur: 165,
    baseGlowOpacity: 0.88,
    backgroundTint: Color(0xFFF1F4FA),
  );

  static const frost = RainPreset(
    name: 'Frost',
    centerGlow: Color(0xFF3FA9F5),
    outerGlow: Color(0xFFDCF4FF),
    textColor: Color(0xFFFAFEFF),
    baseSpawnChance: 0.08,
    baseBlur: 155,
    baseGlowOpacity: 0.86,
    backgroundTint: Color(0xFFFAFDFF),
  );

  static const values = [calm, storm, night, frost];
}
