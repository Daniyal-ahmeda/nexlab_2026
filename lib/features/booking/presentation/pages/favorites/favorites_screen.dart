import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/test_details/test_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);
    final list = state.favorites;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.favorites,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  fontFamily: 'Outfit',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                list.isEmpty
                    ? (isArabic ? 'لم تقم بحفظ أي تحاليل بعد' : 'Nothing saved yet')
                    : '${list.length} ${isArabic ? "فحص محفوظ" : "saved tests"}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              if (list.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 52,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isArabic ? 'قائمتك المفضلة فارغة' : 'Your favorites list is empty',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Outfit',
                            color: isDark ? Colors.grey.shade300 : const Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isArabic
                              ? 'انقر على رمز القلب في أي فحص لحفظه هنا لسهولة الوصول إليه.'
                              : 'Tap the heart icon on any test to save it here for quick booking.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final test = list[index];
                    return _buildFavoriteItem(context, test, isDark, isArabic, state);
                  },
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(
    BuildContext context,
    DiagnosticTest test,
    bool isDark,
    bool isArabic,
    AppState state,
  ) {
    Color categoryColor = AppTheme.primaryBlue;
    if (test.category == 'Heart') categoryColor = AppTheme.coralRed;
    if (test.category == 'Thyroid') categoryColor = AppTheme.purpleAmethyst;
    if (test.category == 'Energy') categoryColor = AppTheme.amberGold;
    if (test.category == 'Blood') categoryColor = AppTheme.primaryCyan;

    return InkWell(
      onTap: () {
        state.startBooking(test);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TestDetailsScreen(test: test)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.biotech_outlined, color: categoryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test.name,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Outfit',
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${test.price.toInt()} ${isArabic ? "د.ل" : "LYD"} • ${test.reportsInHours} ${isArabic ? "ساعة" : "Hours"}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_rounded, color: AppTheme.coralRed, size: 22),
              onPressed: () => state.toggleFavorite(test),
            ),
          ],
        ),
      ),
    );
  }
}
