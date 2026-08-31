import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/health/presentation/pages/family_members/family_members_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/payment_methods/payment_methods_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/settings/settings_screen.dart';
import 'package:nexlab_2026/features/health/presentation/pages/results/results_screen.dart';
import 'package:nexlab_2026/core/routes/app_routes.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/main_navigation/main_navigation_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final upcomingCount = state.bookings.where((b) => b.status == BookingStatus.pending).length;
    final resultsCount = state.results.length;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => state.refreshAll(),
        color: AppTheme.primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.myAccount,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.manageProfileSubtitle,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    // Language switcher button
                    TextButton.icon(
                      onPressed: () => state.toggleLocale(),
                      icon: const Icon(Icons.language, size: 16, color: AppTheme.primaryBlue),
                      label: Text(
                        state.isArabic ? 'English' : 'عربي',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Profile Card Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFEFF6FF),
                              border: Border.all(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                state.primaryUser.name.isNotEmpty
                                    ? state.primaryUser.name[0].toUpperCase()
                                    : 'M',
                                style: const TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.primaryUser.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Outfit',
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  state.currentUser?.email ?? 'patient@nexlab.ly',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.emeraldGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        state.isArabic ? 'حساب نشط • طرابلس، ليبيا' : 'Active Account • Tripoli, Libya',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 1),
                      const SizedBox(height: 16),

                      // Quick Stats Row
                      Row(
                        children: [
                          _buildStatItem(
                            state.isArabic ? 'فصيلة الدم' : 'Blood Group',
                            state.primaryUser.bloodGroup,
                            AppTheme.coralRed,
                            isDark,
                          ),
                          _buildStatDivider(isDark),
                          _buildStatItem(
                            state.isArabic ? 'العمر' : 'Age',
                            '${state.primaryUser.age} ${state.isArabic ? 'سنة' : 'yrs'}',
                            AppTheme.primaryBlue,
                            isDark,
                          ),
                          _buildStatDivider(isDark),
                          _buildStatItem(
                            state.isArabic ? 'الجنس' : 'Gender',
                            state.primaryUser.gender == 'Male'
                                ? l10n.genderMale
                                : (state.primaryUser.gender == 'Female' ? l10n.genderFemale : l10n.genderOther),
                            AppTheme.purpleAmethyst,
                            isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Activity Section Header
                Text(
                  state.isArabic ? 'النشاط والسجلات' : 'ACTIVITY & RECORDS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    letterSpacing: 0.8,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTile(
                        context: context,
                        icon: Icons.calendar_month_outlined,
                        title: l10n.myBookings,
                        subtitle: '$upcomingCount ${state.isArabic ? 'حجوزات قادمة' : 'scheduled bookings'}',
                        badge: upcomingCount > 0 ? '$upcomingCount' : null,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainNavigationScreen(initialIndex: 1),
                            ),
                            (route) => false,
                          );
                        },
                        isDark: isDark,
                      ),
                      const Divider(height: 1),
                      _buildTile(
                        context: context,
                        icon: Icons.assignment_outlined,
                        title: l10n.testResults,
                        subtitle: '$resultsCount ${state.isArabic ? 'تقارير فحص جاهزة' : 'diagnostic reports'}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ResultsScreen()),
                          );
                        },
                        isDark: isDark,
                      ),
                      const Divider(height: 1),
                      _buildTile(
                        context: context,
                        icon: Icons.people_outline,
                        title: l10n.familyMembers,
                        subtitle: '${state.familyMembers.length} ${state.isArabic ? 'أفراد مسجلين' : 'registered members'}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FamilyMembersScreen()),
                          );
                        },
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Preferences Header
                Text(
                  state.isArabic ? 'خيارات الحساب والدفع' : 'ACCOUNT & PREFERENCES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    letterSpacing: 0.8,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTile(
                        context: context,
                        icon: Icons.account_balance_wallet_outlined,
                        title: l10n.libyanPaymentGateways,
                        subtitle: state.isArabic ? 'إدفع لي، سداد، مو كاش والبطاقات' : 'Edfaaly, Sadad, Mobi & Local Cards',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                          );
                        },
                        isDark: isDark,
                      ),
                      const Divider(height: 1),
                      _buildTile(
                        context: context,
                        icon: Icons.settings_outlined,
                        title: l10n.settingsTitle,
                        subtitle: state.isArabic ? 'اللغة، الوضع الليلي، والإشعارات' : 'Language, Dark Mode & Alerts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsScreen()),
                          );
                        },
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      state.logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, size: 16, color: AppTheme.coralRed),
                    label: Text(
                      l10n.signOut,
                      style: const TextStyle(
                        color: AppTheme.coralRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTheme.coralRed.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      width: 1,
      height: 28,
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    String? badge,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Outfit',
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11.5,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
