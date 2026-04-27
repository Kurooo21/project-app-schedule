import 'package:flutter/material.dart';

class AppPalette {
  static const Color background = Color(0xFFF4F7FB);
  static const Color surface = Colors.white;
  static const Color surfaceSoft = Color(0xFFF4F8FB);
  static const Color primary = Color(0xFF66A9D1);
  static const Color primaryStrong = Color(0xFF237AA7);
  static const Color primarySoft = Color(0xFFDCECF8);
  static const Color primaryDark = Color(0xFF143853);
  static const Color text = Color(0xFF204760);
  static const Color subtleText = Color(0xFF6C8295);
  static const Color line = Color(0xFFD8E5EF);
  static const Color accent = Color(0xFFF3B05C);
  static const Color accentSoft = Color(0xFFFFE6BC);
  static const Color success = Color(0xFF57A576);
  static const Color warning = Color(0xFFE3A54A);
  static const Color danger = Color(0xFFE27C73);
}

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FBFF), Color(0xFFEEF4F9), Color(0xFFF5F7FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -50,
            child: _BackdropGlow(
              size: 220,
              colors: [
                AppPalette.primarySoft.withValues(alpha: 0.86),
                AppPalette.primary.withValues(alpha: 0.08),
              ],
            ),
          ),
          Positioned(
            left: -70,
            top: 120,
            child: _BackdropGlow(
              size: 180,
              colors: [
                AppPalette.accentSoft.withValues(alpha: 0.72),
                AppPalette.accent.withValues(alpha: 0.05),
              ],
            ),
          ),
          Positioned(
            right: -80,
            bottom: -110,
            child: _BackdropGlow(
              size: 260,
              colors: [
                AppPalette.primarySoft.withValues(alpha: 0.72),
                AppPalette.primaryStrong.withValues(alpha: 0.06),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}

BoxDecoration buildPageDecoration() {
  return BoxDecoration(
    color: AppPalette.surface.withValues(alpha: 0.97),
    borderRadius: BorderRadius.circular(34),
    border: Border.all(color: Colors.white.withValues(alpha: 0.92), width: 1.2),
    boxShadow: [
      BoxShadow(
        color: AppPalette.primaryDark.withValues(alpha: 0.12),
        blurRadius: 36,
        offset: const Offset(0, 18),
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.9),
        blurRadius: 0,
        spreadRadius: 1,
      ),
    ],
  );
}

BoxDecoration buildPanelDecoration({
  Color color = AppPalette.surface,
  Color borderColor = AppPalette.line,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: borderColor.withValues(alpha: 0.9)),
    boxShadow: [
      BoxShadow(
        color: AppPalette.primaryDark.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 10),
      ),
    ],
  );
}

class _BackdropGlow extends StatelessWidget {
  const _BackdropGlow({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}
