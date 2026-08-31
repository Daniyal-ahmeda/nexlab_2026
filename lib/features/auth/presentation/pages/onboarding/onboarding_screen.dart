import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/register/register_screen.dart';
import 'package:nexlab_2026/shared/widgets/nexlab_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onFinish() {
    final state = Provider.of<AppState>(context, listen: false);
    state.completeOnboarding();
  }

  void _goToRegister() {
    final state = Provider.of<AppState>(context, listen: false);
    state.completeOnboarding();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;

    final slides = [
      _OnboardingSlideData(
        icon: Icons.biotech_rounded,
        gradient: AppTheme.blueGradient,
        titleEn: 'Accredited Diagnostic Labs in Tripoli',
        titleAr: 'شبكة المختبرات المعتمدة في ليبيا',
        descEn: 'Compare test packages, transparent LYD pricing, and book top-rated clinical laboratories across Tripoli.',
        descAr: 'قارن بين باقات الفحوصات الطبية، والأسعار الشفافة بالدينار الليبي، واحجز موعدك لدى أفضل المختبرات المعتمدة.',
        badgeEn: 'VERIFIED CLINICAL NETWORK',
        badgeAr: 'شبكة طبية معتمدة',
      ),
      _OnboardingSlideData(
        icon: Icons.home_work_rounded,
        gradient: AppTheme.oceanGradient,
        titleEn: 'Doorstep Collection or Lab Visit',
        titleAr: 'سحب العينات من المنزل أو زيارة المختبر',
        descEn: 'Licensed phlebotomists arrive at your home or office with sterile equipment at your preferred time slot.',
        descAr: 'أخصائي تمريض وسحب عينات مرخص يصل إلى منزلك أو مكتبك بمعدات معقمة في الموعد الذي تختاره.',
        badgeEn: 'FLEXIBLE HEALTHCARE',
        badgeAr: 'رعاية صحية مرنة',
      ),
      _OnboardingSlideData(
        icon: Icons.verified_user_rounded,
        gradient: AppTheme.purpleGradient,
        titleEn: 'Instant Digital Reports & Tracking',
        titleAr: 'نتائج فورية وتقارير PDF معتمدة',
        descEn: 'Real-time push notifications when results are certified. Download and share official digital PDF reports.',
        descAr: 'إشعارات حية ومباشرة فور اعتماد الفحوصات. تصفح وحمّل تقارير التحاليل الرسمية بصيغة PDF في أي وقت.',
        badgeEn: 'REAL-TIME CLINICAL DATA',
        badgeAr: 'بيانات مخبرية فورية',
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NexLab Transparent Logo
                  NexLabLogo(
                    useFullLogo: true,
                    height: 32,
                    isWhite: isDark,
                  ),

                  Row(
                    children: [
                      // Language Switcher
                      TextButton.icon(
                        onPressed: () => state.toggleLocale(),
                        icon: const Icon(Icons.language, size: 16, color: AppTheme.primaryBlue),
                        label: Text(
                          isArabic ? 'English' : 'عربي',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Skip Button
                      if (_currentPage < slides.length - 1)
                        TextButton(
                          onPressed: _onFinish,
                          child: Text(
                            isArabic ? 'تخطي' : 'Skip',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Carousel Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Visual Graphic Hero Container
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: slide.gradient,
                            boxShadow: [
                              BoxShadow(
                                color: slide.gradient.colors.first.withValues(alpha: 0.35),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              slide.icon,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: slide.gradient.colors.first.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: slide.gradient.colors.first.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isArabic ? slide.badgeAr : slide.badgeEn,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: slide.gradient.colors.first,
                              letterSpacing: 0.8,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          isArabic ? slide.titleAr : slide.titleEn,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                            letterSpacing: -0.5,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          isArabic ? slide.descAr : slide.descEn,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.5,
                            color: isDark ? Colors.grey.shade400 : const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dot Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentPage == index
                        ? AppTheme.primaryBlue
                        : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Bottom Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _onFinish();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == slides.length - 1
                                ? (isArabic ? 'ابدأ الآن' : 'Get Started')
                                : (isArabic ? 'التالي' : 'Continue'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isArabic ? Icons.arrow_back : Icons.arrow_forward,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isArabic ? 'ليس لديك حساب؟ ' : "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                      GestureDetector(
                        onTap: _goToRegister,
                        child: Text(
                          isArabic ? 'تسجيل جديد' : 'Register Now',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlideData {
  final IconData icon;
  final LinearGradient gradient;
  final String titleEn;
  final String titleAr;
  final String descEn;
  final String descAr;
  final String badgeEn;
  final String badgeAr;

  const _OnboardingSlideData({
    required this.icon,
    required this.gradient,
    required this.titleEn,
    required this.titleAr,
    required this.descEn,
    required this.descAr,
    required this.badgeEn,
    required this.badgeAr,
  });
}
