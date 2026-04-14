import 'package:flutter/material.dart';

import '../../models/rain_preset.dart';
import '../../models/showcase_config.dart';

class GlassControlPanel extends StatelessWidget {
  const GlassControlPanel({
    super.key,
    required this.config,
    required this.onIntensityChanged,
    required this.onBlurChanged,
    required this.onGlowChanged,
    required this.onPresetChanged,
    required this.onPlayPausePressed,
    required this.onResetPressed,
    required this.onMessageChanged,
  });

  final ShowcaseConfig config;
  final ValueChanged<double> onIntensityChanged;
  final ValueChanged<double> onBlurChanged;
  final ValueChanged<double> onGlowChanged;
  final ValueChanged<RainPreset> onPresetChanged;
  final VoidCallback onPlayPausePressed;
  final VoidCallback onResetPressed;
  final ValueChanged<String> onMessageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Showcase Controls', style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  onPressed: onPlayPausePressed,
                  icon: Icon(config.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                ),
                IconButton(
                  onPressed: onResetPressed,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<RainPreset>(
              initialValue: config.preset,
              decoration: const InputDecoration(labelText: 'Preset'),
              items: RainPreset.values
                  .map(
                    (preset) => DropdownMenuItem(
                      value: preset,
                      child: Text(preset.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onPresetChanged(value);
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              initialValue: config.message,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Hero message',
                hintText: 'How are you\nfeeling today?',
              ),
              onFieldSubmitted: onMessageChanged,
            ),
            const SizedBox(height: 16),
            _LabeledSlider(
              label: 'Rain intensity',
              value: config.intensity,
              min: 0.4,
              max: 2.2,
              onChanged: onIntensityChanged,
            ),
            _LabeledSlider(
              label: 'Blur strength',
              value: config.blurSigma,
              min: 0.6,
              max: 1.8,
              onChanged: onBlurChanged,
            ),
            _LabeledSlider(
              label: 'Glow strength',
              value: config.glowStrength,
              min: 0.5,
              max: 1.8,
              onChanged: onGlowChanged,
            ),
            const SizedBox(height: 8),
            Text(
              'Tip: tap or drag on the glass surface to spawn impact splashes.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label  ${value.toStringAsFixed(2)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
