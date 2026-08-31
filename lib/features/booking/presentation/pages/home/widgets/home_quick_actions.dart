import 'package:flutter/material.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/bookings/bookings_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/family_members/family_members_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/results/results_screen.dart';

class HomeQuickActions extends StatelessWidget {
  final bool isDark;
  final bool isArabic;

  const HomeQuickActions({
    super.key,
    required this.isDark,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildActionCard(
          context: context,
          icon: Icons.calendar_month_outlined,
          title: isArabic ? 'مواعيدي' : 'Bookings',
          subtitle: isArabic ? 'الحجوزات النشطة' : 'Appointments',
          gradient: AppTheme.blueGradient,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookingsScreen()),
            );
          },
        ),
        const SizedBox(width: 10),
        _buildActionCard(
          context: context,
          icon: Icons.biotech_outlined,
          title: isArabic ? 'نتائج الفحص' : 'Reports',
          subtitle: isArabic ? 'تقارير PDF' : 'Official PDF',
          gradient: AppTheme.purpleGradient,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResultsScreen()),
            );
          },
        ),
        const SizedBox(width: 10),
        _buildActionCard(
          context: context,
          icon: Icons.people_outline,
          title: isArabic ? 'أفراد العائلة' : 'Family',
          subtitle: isArabic ? 'إدارة المرضى' : 'Dependents',
          gradient: AppTheme.greenGradient,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FamilyMembersScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161F30) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
            boxShadow: AppTheme.cardShadow(isDark),
          ),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Outfit',
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
