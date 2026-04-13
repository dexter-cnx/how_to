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
    final sectionGap = isMobile ? 20.0 : 24.0;

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
                  horizontal: isMobile ? 16 : 40,
                  vertical: isMobile ? 18 : 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(isMobile: isMobile),
                        SizedBox(height: isMobile ? 20 : 28),
                        _HeroSection(isMobile: isMobile),
                        SizedBox(height: sectionGap),
                        _StatsSection(isMobile: isMobile),
                        SizedBox(height: sectionGap),
                        _FeatureGrid(isMobile: isMobile),
                        SizedBox(height: sectionGap),
                        _FooterCard(isMobile: isMobile),
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
      spacing: isMobile ? 10 : 0,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isMobile ? 40 : 42,
              height: isMobile ? 40 : 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.22),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: isMobile ? 20 : 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Particle Showcase',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isMobile)
                  Text(
                    'Ambient motion demo',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 0.3,
                      color: Colors.white.withValues(alpha: 0.56),
                    ),
                  ),
              ],
            ),
          ],
        ),
        Wrap(
          spacing: isMobile ? 8 : 12,
          runSpacing: 8,
          children: [
            _ChipLabel(label: 'Flutter', isMobile: isMobile),
            _ChipLabel(label: 'Interactive', isMobile: isMobile),
            _ChipLabel(label: 'Showcase Ready', isMobile: isMobile),
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
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: isMobile ? 0.08 : 0.06),
            const Color(0xFF0F172A).withValues(alpha: 0.72),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF020617).withValues(alpha: 0.28),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: isMobile ? -12 : -18,
            top: isMobile ? -18 : -24,
            child: Container(
              width: isMobile ? 92 : 140,
              height: isMobile ? 92 : 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF67E8F9).withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          if (isMobile)
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCopy(isMobile: true),
                SizedBox(height: 24),
                _PreviewCard(isCompact: true),
              ],
            )
          else
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _HeroCopy(isMobile: false)),
                SizedBox(width: 24),
                Expanded(flex: 2, child: _PreviewCard()),
              ],
            ),
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
        if (isMobile)
          Container(
            width: 56,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                colors: [Color(0xFF67E8F9), Color(0xFF8B5CF6)],
              ),
            ),
          ),
        if (isMobile) const SizedBox(height: 14),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 12,
            vertical: isMobile ? 7 : 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'Realtime particle canvas with tap burst and regroup',
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFD8B4FE),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Text(
          'Turn your particle background into a polished Flutter showcase.',
          style: TextStyle(
            fontSize: isMobile ? 30 : 56,
            height: isMobile ? 1.08 : 1.05,
            fontWeight: FontWeight.w800,
            letterSpacing: isMobile ? -0.6 : -1.2,
          ),
        ),
        SizedBox(height: isMobile ? 14 : 18),
        Text(
          'This starter demonstrates your uploaded particle effect as the main visual layer, wrapped in a landing-page style UI that works well for demos, portfolio pages, and web showcases.',
          style: TextStyle(
            fontSize: isMobile ? 14 : 18,
            height: isMobile ? 1.5 : 1.6,
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
        SizedBox(height: isMobile ? 18 : 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Live Demo Feel'),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 18,
                  vertical: isMobile ? 14 : 16,
                ),
                backgroundColor: const Color(0xFF67E8F9),
                foregroundColor: const Color(0xFF07111F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.touch_app_outlined),
              label: const Text('Tap or drag'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 18,
                  vertical: isMobile ? 14 : 16,
                ),
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
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
      crossAxisSpacing: isMobile ? 12 : 16,
      mainAxisSpacing: isMobile ? 12 : 16,
      childAspectRatio: isMobile ? 1.05 : 1.6,
      children: [
        _StatCard(isMobile: isMobile, value: '180', label: 'Particles'),
        _StatCard(
          isMobile: isMobile,
          value: '110px',
          label: 'Link Distance',
        ),
        _StatCard(isMobile: isMobile, value: 'Tap+Drag', label: 'Interaction'),
        _StatCard(
          isMobile: isMobile,
          value: '60fps*',
          label: 'Showcase Target',
        ),
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
        crossAxisSpacing: isMobile ? 12 : 16,
        mainAxisSpacing: isMobile ? 12 : 16,
        childAspectRatio: isMobile ? 1.75 : 2.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final item = features[index];
        return _FeatureCard(
          isMobile: isMobile,
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
  const _PreviewCard({this.isCompact = false});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 16 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF020617).withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
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
          SizedBox(height: isCompact ? 14 : 16),
          Container(
            padding: EdgeInsets.all(isCompact ? 12 : 14),
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
          SizedBox(height: isCompact ? 12 : 14),
          Text(
            'Tip: replace the text content with your product, agency, toolkit, or app details and this becomes a reusable promo shell.',
            style: TextStyle(
              fontSize: isCompact ? 12 : 13,
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
  const _FooterCard({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.07),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.rocket_launch_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Next step: swap in your branding, add CTA buttons, and deploy with Flutter Web for a clean visual showcase.',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.isMobile,
    required this.icon,
    required this.title,
    required this.description,
  });

  final bool isMobile;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isMobile ? 44 : 52,
            height: isMobile ? 44 : 52,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              size: isMobile ? 20 : 24,
              color: const Color(0xFFD8B4FE),
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 10),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    height: 1.5,
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
  const _StatCard({
    required this.isMobile,
    required this.value,
    required this.label,
  });

  final bool isMobile;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF111827).withValues(alpha: 0.88),
            const Color(0xFF0F172A).withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              const Color(0xFF67E8F9).withValues(alpha: isMobile ? 0.12 : 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 11 : 14,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.label, required this.isMobile});

  final String label;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 14,
        vertical: isMobile ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isMobile ? 12 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
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
