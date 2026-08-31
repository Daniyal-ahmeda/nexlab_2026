import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/home/home_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/bookings/bookings_screen.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/favorites/favorites_screen.dart';
import 'package:nexlab_2026/features/auth/presentation/pages/profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingsScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = Provider.of<AppState>(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161F30) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, l10n.navHome, isDark),
            _buildNavItem(1, Icons.calendar_month_rounded, Icons.calendar_month_outlined, l10n.navBookings, isDark),
            _buildNavItem(2, Icons.favorite_rounded, Icons.favorite_border_rounded, state.isArabic ? 'المفضلة' : 'Favorites', isDark),
            _buildNavItem(3, Icons.person_rounded, Icons.person_outline_rounded, l10n.navProfile, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppTheme.primaryBlue : (isDark ? Colors.grey.shade400 : Colors.grey.shade500);

    return InkWell(
      onTap: () {
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: isSelected
            ? BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: color,
                fontFamily: 'Outfit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
