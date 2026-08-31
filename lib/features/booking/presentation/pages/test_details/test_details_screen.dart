import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/select_lab/select_lab_screen.dart';

class TestDetailsScreen extends StatelessWidget {
  final DiagnosticTest test;

  const TestDetailsScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = state.isFavorite(test);
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);
    final defaultLab = state.allLabs.isNotEmpty ? state.allLabs.first : null;

    Color categoryColor = AppTheme.primaryBlue;
    if (test.category == 'Heart') categoryColor = AppTheme.coralRed;
    if (test.category == 'Thyroid') categoryColor = AppTheme.purpleAmethyst;
    if (test.category == 'Energy') categoryColor = AppTheme.amberGold;
    if (test.category == 'Blood') categoryColor = AppTheme.primaryCyan;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          test.category.toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: categoryColor,
            fontFamily: 'Outfit',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? AppTheme.coralRed : null,
            ),
            onPressed: () => state.toggleFavorite(test),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isArabic ? 'تم نسخ رابط الفحص' : 'Test info link copied.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Card with Category Accent
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
                boxShadow: AppTheme.cardShadow(isDark),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 5,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    test.category.toUpperCase(),
                                    style: TextStyle(
                                      color: categoryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.verified_rounded, size: 14, color: AppTheme.emeraldGreen),
                                    const SizedBox(width: 4),
                                    Text(
                                      isArabic ? 'معتمد ISO' : 'ISO Accredited',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              test.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Outfit',
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              test.subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Three Metric Indicators Strip
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
                boxShadow: AppTheme.cardShadow(isDark),
              ),
              child: Row(
                children: [
                  _buildMetric(
                    label: isArabic ? 'وقت النتيجة' : 'TURNAROUND',
                    value: isArabic ? '${test.reportsInHours} ساعة' : '${test.reportsInHours} Hours',
                    icon: Icons.schedule_rounded,
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMetric(
                    label: isArabic ? 'نوع العينة' : 'SAMPLE',
                    value: test.sampleType,
                    icon: Icons.science_outlined,
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildMetric(
                    label: isArabic ? 'الصيام' : 'FASTING',
                    value: test.fastingRequired
                        ? (isArabic ? 'مطلوب (10-12س)' : 'Required (10-12h)')
                        : (isArabic ? 'غير مطلوب' : 'None'),
                    icon: Icons.no_food_outlined,
                    isDark: isDark,
                    highlight: test.fastingRequired,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Clinical Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
                boxShadow: AppTheme.cardShadow(isDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'الغرض الطبي والتفاصيل' : 'Clinical Overview',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Outfit',
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    test.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Fasting Alert if applicable
            if (test.fastingRequired) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.orangeSunset.withValues(alpha: isDark ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.orangeSunset.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.orangeSunset, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'تعليمات الصيام للمريض' : 'Patient Fasting Instructions',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.orangeSunset,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic
                                ? 'يجب الصيام لمدة 10 إلى 12 ساعة قبل سحب العينة. يُسمح بشرب الماء فقط خلال فترة الصيام.'
                                : 'Fasting for 10-12 hours prior to sample collection is required. Water is permitted during fasting.',
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppTheme.orangeSunset,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 5. Default Lab Location Preview
            if (defaultLab != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161F30) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.local_hospital_outlined, color: AppTheme.primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            defaultLab.name,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic ? 'متاح للزيارة وسحب العينات المنزلي في طرابلس' : 'Available for Lab Visit & Home Collection in Tripoli',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161F30) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.totalAmount,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${test.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Outfit',
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'د.ل' : 'LYD',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryBlue,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      state.startBooking(test);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SelectLabScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isArabic ? 'اختيار المختبر والموعد' : 'Select Lab & Schedule',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
    bool highlight = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: highlight ? AppTheme.orangeSunset : (isDark ? Colors.white : const Color(0xFF0F172A)),
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 32,
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
    );
  }
}
