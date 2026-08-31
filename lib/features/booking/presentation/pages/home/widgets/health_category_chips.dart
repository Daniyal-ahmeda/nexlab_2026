import 'package:flutter/material.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';

class HealthCategoryChips extends StatelessWidget {
  final List<String> availableCategories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;
  final bool isDark;
  final bool isArabic;

  const HealthCategoryChips({
    super.key,
    required this.availableCategories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.isDark,
    required this.isArabic,
  });

  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('blood') || lower.contains('دم')) return Icons.water_drop_outlined;
    if (lower.contains('heart') || lower.contains('قلب')) return Icons.favorite_border_rounded;
    if (lower.contains('thyroid') || lower.contains('غدة')) return Icons.bubble_chart_outlined;
    if (lower.contains('vitamin') || lower.contains('energy') || lower.contains('فيتامين')) return Icons.bolt_rounded;
    if (lower.contains('diabetes') || lower.contains('sugar') || lower.contains('سكر')) return Icons.speed_rounded;
    if (lower.contains('liver') || lower.contains('كبد')) return Icons.health_and_safety_outlined;
    if (lower.contains('kidney') || lower.contains('كلى')) return Icons.medical_services_outlined;
    if (lower.contains('urine') || lower.contains('بول')) return Icons.biotech_outlined;
    if (lower.contains('package') || lower.contains('باقة')) return Icons.inventory_2_outlined;
    return Icons.science_outlined;
  }

  @override
  Widget build(BuildContext context) {
    // Build list with 'All' first, then available categories from database
    final List<Map<String, dynamic>> items = [
      {
        'key': null,
        'label': isArabic ? 'الكل' : 'All',
        'icon': Icons.grid_view_rounded,
      },
      ...availableCategories.map((cat) => {
            'key': cat,
            'label': cat,
            'icon': _getCategoryIcon(cat),
          }),
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = items[index];
          final catKey = cat['key'] as String?;
          final isSelected = (selectedCategory == null && catKey == null) ||
              (selectedCategory != null && catKey != null && selectedCategory!.trim().toLowerCase() == catKey.trim().toLowerCase());

          return InkWell(
            onTap: () => onCategorySelected(catKey),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : (isDark ? const Color(0xFF161F30) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : const Color(0xFF0F172A)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
