import 'package:flutter/material.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/shared/widgets/nexlab_logo.dart';

class NexLabSplashScreen extends StatefulWidget {
  final String? subtitle;

  const NexLabSplashScreen({
    super.key,
    this.subtitle,
  });

  @override
  State<NexLabSplashScreen> createState() => _NexLabSplashScreenState();
}

class _NexLabSplashScreenState extends State<NexLabSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.25, end: 0.55).animate(
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF070D18),
              Color(0xFF0B192C),
              Color(0xFF0F274A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Soft Radial Glow behind Logo
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: _glowAnimation.value),
                        blurRadius: 90,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),

                // Centered Brand Elements
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo Mark
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: const NexLabLogo(
                          useFullLogo: true,
                          height: 56,
                          isWhite: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Diagnostic Portal Subtitle
                    Text(
                      widget.subtitle ?? 'Next-Gen Diagnostic Portal • Tripoli',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 52),

                    // Sleek Modern Loading Bar
                    SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                          minHeight: 4,
                        ),
                      ),
                    ),
                  ],
                ),

                // Footer Accreditation Note
                Positioned(
                  bottom: 30,
                  child: Text(
                    'ACCREDITED CLINICAL NETWORK',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
