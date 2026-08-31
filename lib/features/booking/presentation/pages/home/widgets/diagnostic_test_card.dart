import 'package:flutter/material.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/test_details/test_details_screen.dart';

class DiagnosticTestCard extends StatelessWidget {
  final DiagnosticTest test;
  final bool isDark;
  final bool isArabic;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const DiagnosticTestCard({
    super.key,
    required this.test,
    required this.isDark,
    required this.isArabic,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    Color categoryColor = AppTheme.primaryBlue;
    if (test.category == 'Heart') categoryColor = AppTheme.coralRed;
    if (test.category == 'Thyroid') categoryColor = AppTheme.purpleAmethyst;
    if (test.category == 'Energy') categoryColor = AppTheme.amberGold;
    if (test.category == 'Blood') categoryColor = AppTheme.primaryCyan;

    return Container(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Category tag + favorite button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: categoryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            test.category.toUpperCase(),
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Outfit',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? AppTheme.coralRed : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                        size: 20,
                      ),
                      onPressed: onToggleFavorite,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Title & Subtitle
                Text(
                  test.name,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Outfit',
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  test.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                // Tags Row (Turnaround, Fasting, Sample Type)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildMetaPill(
                      icon: Icons.schedule_rounded,
                      label: isArabic ? '${test.reportsInHours} ساعة' : '${test.reportsInHours}h Results',
                      isDark: isDark,
                    ),
                    if (test.fastingRequired)
                      _buildMetaPill(
                        icon: Icons.no_food_outlined,
                        label: isArabic ? 'صيام مطلوب' : 'Fasting Required',
                        isDark: isDark,
                      ),
                    _buildMetaPill(
                      icon: Icons.science_outlined,
                      label: test.sampleType,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Bottom Action Bar: Price + Book Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'سعر الفحص' : 'Price',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${test.price.toInt()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Outfit',
                            color: isDark ? Colors.white : AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isArabic ? 'د.ل' : 'LYD',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TestDetailsScreen(test: test)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArabic ? 'حجز الفحص' : 'Book Test',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Outfit',
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaPill({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
