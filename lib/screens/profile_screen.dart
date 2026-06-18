import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'family_members_screen.dart';
import 'payment_methods_screen.dart';
import 'settings_screen.dart';
import 'results_screen.dart';
import 'result_details_screen.dart';
import 'main_navigation_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);

    // Dynamic counts
    final upcomingCount = state.bookings.where((b) => b.status == BookingStatus.pending).length;
    final resultsCount = state.results.length;
    final favoritesCount = state.favorites.length;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header (matching other screens)
              _buildHeader(state, theme),
              const SizedBox(height: 24),

              // Profile Card Info
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.profileScoreGradient,
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.2),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.primaryUser.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Member since May 2026',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Detailed Rows Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildProfileRow(theme, Icons.email_outlined, 'monder@example.com'),
                      const Divider(height: 24),
                      _buildProfileRow(theme, Icons.phone_outlined, '+1 (555) 123-4567'),
                      const Divider(height: 24),
                      _buildProfileRow(theme, Icons.location_on_outlined, '456 Oak Street, Apt 3B, New York, NY 10001'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Health Score Card (Gradients)
              InkWell(
                onTap: () {
                  if (state.results.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultDetailsScreen(result: state.results[0]),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No health data reports to visualize yet.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.profileScoreGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Health Score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '85',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            '/100',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Based on your recent test results',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Activity Section
              Text(
                'MY ACTIVITY',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _buildActivityItem(
                      theme: theme,
                      icon: Icons.calendar_month_outlined,
                      title: 'My Bookings',
                      badgeCount: upcomingCount,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen(initialIndex: 1),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildActivityItem(
                      theme: theme,
                      icon: Icons.assignment_outlined,
                      title: 'Test Results',
                      badgeCount: resultsCount,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResultsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildActivityItem(
                      theme: theme,
                      icon: Icons.favorite_border,
                      title: 'Favorites',
                      badgeCount: favoritesCount,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen(initialIndex: 2),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Settings Section
              Text(
                'ACCOUNT SETTINGS',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.hintColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _buildActivityItem(
                      theme: theme,
                      icon: Icons.credit_card_outlined,
                      title: 'Payment Methods',
                      badgeCount: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildActivityItem(
                      theme: theme,
                      icon: Icons.people_outline,
                      title: 'Family Members',
                      badgeCount: state.familyMembers.length - 1, // Exclude self
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FamilyMembersScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildActivityItem(
                      theme: theme,
                      icon: Icons.settings_outlined,
                      title: 'Settings & Appearance',
                      badgeCount: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppState state, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
            Text(
              state.primaryUser.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? Colors.grey.shade800.withOpacity(0.5)
                : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.coralRed,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(ThemeData theme, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: theme.brightness == Brightness.dark ? Colors.grey.shade200 : Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required int badgeCount,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 22, color: theme.primaryColor.withOpacity(0.8)),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (badgeCount > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: theme.hintColor.withOpacity(0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
