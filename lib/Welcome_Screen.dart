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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: ScreenSurface(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // TITLE
                        Text(
                          'DAILY SCHEDULE',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: AppPalette.primaryStrong,
                          ),
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // INTERACTIVE ILLUSTRATION
                        const _ModernIllustration(),
                        
                        const SizedBox(height: 60),
                        
                        // WELCOME TEXT
                        Column(
                          children: [
                            Text(
                              'WELCOME',
                              style: GoogleFonts.manrope(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: AppPalette.primaryStrong,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                color: AppPalette.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // MULAI BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppPalette.primaryStrong,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                              shadowColor: AppPalette.primaryStrong.withValues(alpha: 0.4),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'MULAI',
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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

class _ModernIllustration extends StatefulWidget {
  const _ModernIllustration();

  @override
  State<_ModernIllustration> createState() => _ModernIllustrationState();
}

class _ModernIllustrationState extends State<_ModernIllustration> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft circle
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.primarySoft.withValues(alpha: 0.5),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.primary.withValues(alpha: 0.1),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // Inner circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.surface,
              boxShadow: [
                BoxShadow(
                  color: AppPalette.primaryDark.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          // Calendar Icon
          const Icon(
            Icons.edit_calendar_rounded,
            size: 55,
            color: AppPalette.primaryStrong,
          ),
          // Floating decoration - Top Right
          Positioned(
            top: 15,
            right: 25,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.accent,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.accent.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          // Floating decoration - Bottom Left
          Positioned(
            bottom: 25,
            left: 20,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.success,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.success.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
