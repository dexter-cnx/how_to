import 'package:flutter/material.dart';
import 'widgets/particle_background.dart';

void main() {
  runApp(const ParticleShowcaseApp());
}

class ParticleShowcaseApp extends StatelessWidget {
  const ParticleShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Particle Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF050816),
        useMaterial3: true,
      ),
      home: const ShowcasePage(),
    );
  }
}

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  final ParticleFieldController _particleController = ParticleFieldController();
  int? _activePointer;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Scaffold(
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          _activePointer = event.pointer;
          _particleController.triggerTap(event.localPosition);
          _particleController.startDrag(event.localPosition);
        },
        onPointerMove: (event) {
          if (_activePointer == event.pointer) {
            _particleController.updateDrag(event.localPosition);
          }
        },
        onPointerUp: (event) {
          if (_activePointer == event.pointer) {
            _particleController.endDrag();
            _activePointer = null;
          }
        },
        onPointerCancel: (event) {
          if (_activePointer == event.pointer) {
            _particleController.endDrag();
            _activePointer = null;
          }
        },
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF030712),
                      Color(0xFF0B1023),
                      Color(0xFF111827),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ParticleBackground(controller: _particleController),
            ),
            const Positioned.fill(child: _SoftGlowLayer()),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 40,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(isMobile: isMobile),
                        const SizedBox(height: 28),
                        _HeroSection(isMobile: isMobile),
                        const SizedBox(height: 24),
                        _StatsSection(isMobile: isMobile),
                        const SizedBox(height: 24),
                        _FeatureGrid(isMobile: isMobile),
                        const SizedBox(height: 24),
                        const _FooterCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                ),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Particle Showcase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ChipLabel(label: 'Flutter'),
            _ChipLabel(label: 'Interactive'),
            _ChipLabel(label: 'Showcase Ready'),
          ],
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final content = [
      _HeroCopy(isMobile: isMobile),
      SizedBox(width: isMobile ? 0 : 24, height: isMobile ? 24 : 0),
      const _PreviewCard(),
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: content[0]),
                content[1],
                const Expanded(flex: 2, child: _PreviewCard()),
              ],
            ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Realtime particle canvas with tap burst and regroup',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD8B4FE),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Turn your particle background into a polished Flutter showcase.',
          style: TextStyle(
            fontSize: isMobile ? 34 : 56,
            height: 1.05,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'This starter demonstrates your uploaded particle effect as the main visual layer, wrapped in a landing-page style UI that works well for demos, portfolio pages, and web showcases.',
          style: TextStyle(
            fontSize: isMobile ? 15 : 18,
            height: 1.6,
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Live Demo Feel'),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.touch_app_outlined),
              label: const Text('Tap or drag'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 0.95 : 1.6,
      children: const [
        _StatCard(value: '180', label: 'Particles'),
        _StatCard(value: '110px', label: 'Link Distance'),
        _StatCard(value: 'Tap+Drag', label: 'Interaction'),
        _StatCard(value: '60fps*', label: 'Showcase Target'),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final features = const [
      _FeatureItem(
        icon: Icons.blur_on,
        title: 'Pulse motion system',
        description:
            'Particles gather into the center, burst back outward, then regroup in a repeating rhythm.',
      ),
      _FeatureItem(
        icon: Icons.hub_outlined,
        title: 'Network line effect',
        description:
            'Nearby particles connect with soft lines, adding depth and a premium motion feel.',
      ),
      _FeatureItem(
        icon: Icons.pan_tool_alt_outlined,
        title: 'Touch interaction',
        description:
            'Tap to blast nearby particles outward or drag across the screen to keep pushing them around.',
      ),
      _FeatureItem(
        icon: Icons.web_asset_outlined,
        title: 'Portfolio-friendly layout',
        description:
            'The scaffold includes hero, stats, features, and footer sections for quick customization.',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isMobile ? 2.2 : 2.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final item = features[index];
        return _FeatureCard(
          icon: item.icon,
          title: item.title,
          description: item.description,
        );
      },
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFF87171),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBBF24),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF34D399),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use cases',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 14),
                _PreviewLine(
                    label: 'Landing page', value: 'Premium motion background'),
                _PreviewLine(
                    label: 'Portfolio', value: 'Interactive hero section'),
                _PreviewLine(
                    label: 'Event screen', value: 'Ambient animated backdrop'),
                _PreviewLine(
                    label: 'App intro', value: 'Modern visual identity'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tip: replace the text content with your product, agency, toolkit, or app details and this becomes a reusable promo shell.',
            style: TextStyle(
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterCard extends StatelessWidget {
  const _FooterCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Next step: swap in your branding, add CTA buttons, and deploy with Flutter Web for a clean visual showcase.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: const Color(0xFFD8B4FE)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    height: 1.55,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
          ),
        ],
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

class _PreviewLine extends StatelessWidget {
  const _PreviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.58)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftGlowLayer extends StatelessWidget {
  const _SoftGlowLayer();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: _GlowOrb(size: 280, opacity: 0.20),
          ),
          Positioned(
            right: -60,
            top: 120,
            child: _GlowOrb(size: 220, opacity: 0.14),
          ),
          Positioned(
            bottom: -100,
            left: 120,
            child: _GlowOrb(size: 260, opacity: 0.12),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF8B5CF6).withValues(alpha: opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
