import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'select_lab_screen.dart';

class TestDetailsScreen extends StatelessWidget {
  final DiagnosticTest test;

  const TestDetailsScreen({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isFav = state.isFavorite(test);

    // Get default lab details for description
    final defaultLab = state.allLabs[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppTheme.coralRed : null,
            ),
            onPressed: () => state.toggleFavorite(test),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share link copied to clipboard!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Top Blue Gradient Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                gradient: AppTheme.blueGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(test.icon, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    test.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    test.subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Offered by ${defaultLab.name}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Column(
                  children: [
                    // Price Card
                    _buildPriceCard(test, theme),
                    const SizedBox(height: 20),

                    // Quick Info Grid
                    _buildQuickInfoSection(test, theme),
                    const SizedBox(height: 20),

                    // About section
                    _buildSectionCard(
                      theme,
                      'About this test',
                      Text(
                        test.description,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Preparation warning
                    if (test.fastingRequired) ...[
                      _buildPreparationCard(theme),
                      const SizedBox(height: 16),
                    ],

                    // Lab details info card
                    _buildLabInfoCard(defaultLab, theme),
                    const SizedBox(height: 80), // spacer for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: theme.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade100,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectLabScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Select Lab & Book',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceCard(DiagnosticTest test, ThemeData theme) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test Price',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${test.price.toInt()}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.emeraldGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.emeraldGreen.withOpacity(0.2)),
              ),
              child: const Text(
                'NABL Certified',
                style: TextStyle(
                  color: AppTheme.emeraldGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoSection(DiagnosticTest test, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Information',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  theme,
                  Icons.access_time_filled_outlined,
                  'Reports in',
                  '${test.reportsInHours} hours',
                  AppTheme.primaryBlue,
                ),
                _buildInfoItem(
                  theme,
                  Icons.water_drop_rounded,
                  'Sample type',
                  test.sampleType,
                  AppTheme.primaryBlue,
                ),
                _buildInfoItem(
                  theme,
                  Icons.restaurant_menu_outlined,
                  'Fasting',
                  test.fastingRequired ? 'Required' : 'Not Required',
                  test.fastingRequired ? AppTheme.orangeSunset : AppTheme.emeraldGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(ThemeData theme, IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(ThemeData theme, String title, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildPreparationCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.amberGold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.amberGold.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppTheme.amberGold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preparation Required',
                  style: TextStyle(
                    color: Color(0xFFB45309), // Amber-800 style
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fasting of 8-12 hours is required before this test. You may drink water, but avoid food, beverages, and medications unless advised by your doctor.',
                  style: TextStyle(
                    color: const Color(0xFFB45309).withOpacity(0.85),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabInfoCard(LabOption lab, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lab Information',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              lab.name,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: AppTheme.amberGold, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${lab.rating} / 5.0',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMainLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildLabDetailRow(theme, Icons.location_on_outlined, 'Location', lab.address),
            const SizedBox(height: 10),
            _buildLabDetailRow(theme, Icons.access_time, 'Operating Hours', lab.hours),
          ],
        ),
      ),
    );
  }

  Widget _buildLabDetailRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 13),
              ),
            ],
          ),
        )
      ],
    );
  }
}
