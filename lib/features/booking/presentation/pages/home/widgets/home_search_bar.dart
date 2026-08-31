import 'package:flutter/material.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool isDark;
  final bool isArabic;

  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.isDark,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: isArabic
              ? 'ابحث عن فحص، باقة، أو تحليل دم...'
              : 'Search diagnostic tests, panels, CBC...',
          hintStyle: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppTheme.primaryBlue,
            size: 22,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
