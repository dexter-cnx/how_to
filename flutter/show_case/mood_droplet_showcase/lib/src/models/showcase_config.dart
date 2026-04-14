import 'rain_preset.dart';

class ShowcaseConfig {
  const ShowcaseConfig({
    required this.message,
    required this.intensity,
    required this.blurSigma,
    required this.glowStrength,
    required this.isPlaying,
    required this.preset,
  });

  final String message;
  final double intensity;
  final double blurSigma;
  final double glowStrength;
  final bool isPlaying;
  final RainPreset preset;

  factory ShowcaseConfig.initial() {
    return const ShowcaseConfig(
      message: 'How are you\nfeeling today?',
      intensity: 1,
      blurSigma: 1,
      glowStrength: 1,
      isPlaying: true,
      preset: RainPreset.calm,
    );
  }

  ShowcaseConfig copyWith({
    String? message,
    double? intensity,
    double? blurSigma,
    double? glowStrength,
    bool? isPlaying,
    RainPreset? preset,
  }) {
    return ShowcaseConfig(
      message: message ?? this.message,
      intensity: intensity ?? this.intensity,
      blurSigma: blurSigma ?? this.blurSigma,
      glowStrength: glowStrength ?? this.glowStrength,
      isPlaying: isPlaying ?? this.isPlaying,
      preset: preset ?? this.preset,
    );
  }
}
