import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_quick_actions.dart';
import 'widgets/home_upcoming_card.dart';
import 'widgets/health_category_chips.dart';
import 'widgets/diagnostic_test_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = Provider.of<AppState>(context);
    final isArabic = state.isArabic;

    // Dynamically derive categories from all loaded tests
    final availableCategories = state.allTests
        .map((t) => t.category.trim())
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();

    // Filter tests
    final displayTests = state.allTests.where((test) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        if (!test.name.toLowerCase().contains(q) &&
            !test.subtitle.toLowerCase().contains(q) &&
            !test.category.toLowerCase().contains(q)) {
          return false;
        }
      }
      if (_selectedCategory != null) {
        if (test.category.trim().toLowerCase() != _selectedCategory!.trim().toLowerCase()) {
          return false;
        }
      }
      return true;
    }).toList();

    final pendingBookings = state.bookings.where((b) => b.status == BookingStatus.pending).toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => state.refreshAll(),
          color: AppTheme.primaryBlue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Greeting, Avatar, Language Toggle, Notifications)
                HomeHeader(state: state, isDark: isDark),
                const SizedBox(height: 20),

                // 2. Modern Search Bar
                HomeSearchBar(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  onClear: () => setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  }),
                  isDark: isDark,
                  isArabic: isArabic,
                ),
                const SizedBox(height: 18),

                // 3. Quick Action Cards (Bookings, Reports, Family)
                HomeQuickActions(isDark: isDark, isArabic: isArabic),
                const SizedBox(height: 20),

                // 4. Live Upcoming Appointment Card (if active)
                if (pendingBookings.isNotEmpty) ...[
                  HomeUpcomingCard(
                    booking: pendingBookings.first,
                    isDark: isDark,
                    isArabic: isArabic,
                  ),
                  const SizedBox(height: 20),
                ],

                // 5. Health Categories Selector
                Text(
                  isArabic ? 'الفئات والتحاليل المخبرية' : 'HEALTH CATEGORIES',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    letterSpacing: 0.8,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 10),
                HealthCategoryChips(
                  availableCategories: availableCategories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                  isDark: isDark,
                  isArabic: isArabic,
                ),
                const SizedBox(height: 20),

                // 6. Diagnostic Tests List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'الفحوصات المخبرية المتاحة' : 'AVAILABLE DIAGNOSTIC TESTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        letterSpacing: 0.8,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      '${displayTests.length} ${isArabic ? 'فحص' : 'tests'}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlue,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 7. Tests List
                if (displayTests.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.biotech_outlined, size: 44, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          isArabic ? 'لا توجد تحاليل مطابقة حالياً' : 'No diagnostic tests found',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () => state.refreshAll(),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: Text(isArabic ? 'تحديث القائمة من الخادم' : 'Refresh Tests'),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayTests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final test = displayTests[index];
                      return DiagnosticTestCard(
                        test: test,
                        isDark: isDark,
                        isArabic: isArabic,
                        isFavorite: state.isFavorite(test),
                        onToggleFavorite: () => state.toggleFavorite(test),
                      );
                    },
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
