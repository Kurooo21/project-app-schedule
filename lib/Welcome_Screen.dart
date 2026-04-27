import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_style.dart';
import 'home_screen.dart';
import 'schedule_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 20,
                  ),
                  child: ScreenSurface(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Atur Jadwal\nLebih Mudah.',
                          style: GoogleFonts.sora(
                            fontSize: 36,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            color: AppPalette.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Susun pelajaran, tugas, dan kegiatan harian dalam satu tempat yang rapi dan nyaman.',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                            color: AppPalette.subtleText,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const _HeroBanner(),
                        const SizedBox(height: 32),
                        const _FeatureList(),
                        const SizedBox(height: 48),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppPalette.primaryDark,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Mulai Sekarang',
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF163854), Color(0xFF1F668C), Color(0xFF78C0DF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppPalette.primaryDark.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Hari ini',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fokus pada agenda pentingmu tanpa ribet.',
            style: GoogleFonts.sora(
              fontSize: 22,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _FeatureItem(
          icon: Icons.bolt_rounded,
          title: 'Cepat & Ringan',
          subtitle: 'Akses jadwalmu dalam sekejap',
        ),
        SizedBox(height: 16),
        _FeatureItem(
          icon: Icons.auto_awesome_rounded,
          title: 'Desain Modern',
          subtitle: 'Tampilan bersih dan nyaman di mata',
        ),
        SizedBox(height: 16),
        _FeatureItem(
          icon: Icons.edit_calendar_rounded,
          title: 'Mudah Diatur',
          subtitle: 'Tambah dan ubah jadwal dengan mudah',
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppPalette.primarySoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: AppPalette.primaryDark,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppPalette.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppPalette.subtleText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
