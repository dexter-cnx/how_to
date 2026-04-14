import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../engine/rain_scene_controller.dart';
import '../../models/showcase_config.dart';
import '../widgets/glass_control_panel.dart';
import '../widgets/rain_glass_scene.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final RainSceneController _controller;
  ShowcaseConfig _config = ShowcaseConfig.initial();
  @override
  void initState() {
    super.initState();
    _controller = RainSceneController();
    _ticker = createTicker((_) => _controller.tick(_config))..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 1100;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: isWide
              ? Row(
                  children: [
                    Expanded(flex: 7, child: _buildSceneCard()),
                    const SizedBox(width: 18),
                    SizedBox(width: 360, child: _buildControlPanel()),
                  ],
                )
              : Column(
                  children: [
                    Expanded(flex: 7, child: _buildSceneCard()),
                    const SizedBox(height: 16),
                    Expanded(flex: 5, child: SingleChildScrollView(child: _buildControlPanel())),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSceneCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: RainGlassScene(controller: _controller, config: _config),
    );
  }

  Widget _buildControlPanel() {
    return GlassControlPanel(
      config: _config,
      onIntensityChanged: (value) => setState(() => _config = _config.copyWith(intensity: value)),
      onBlurChanged: (value) => setState(() => _config = _config.copyWith(blurSigma: value)),
      onGlowChanged: (value) => setState(() => _config = _config.copyWith(glowStrength: value)),
      onPresetChanged: (preset) => setState(() => _config = _config.copyWith(preset: preset)),
      onPlayPausePressed: () => setState(() => _config = _config.copyWith(isPlaying: !_config.isPlaying)),
      onResetPressed: _controller.reset,
      onMessageChanged: (value) {
        final safeValue = value.trim().isEmpty ? 'How are you\nfeeling today?' : value;
        setState(() => _config = _config.copyWith(message: safeValue));
      },
    );
  }
}
