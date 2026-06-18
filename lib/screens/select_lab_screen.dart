import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'select_date_time_screen.dart';

class SelectLabScreen extends StatefulWidget {
  const SelectLabScreen({super.key});

  @override
  State<SelectLabScreen> createState() => _SelectLabScreenState();
}

class _SelectLabScreenState extends State<SelectLabScreen> {
  LabOption? _selectedLab;
  bool _isHomeCollection = false;

  @override
  void initState() {
    super.initState();
    final state = Provider.of<AppState>(context, listen: false);
    _isHomeCollection = state.isHomeCollection;
    _selectedLab = state.selectedLab;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final test = state.selectedTest;

    if (test == null) {
      return const Scaffold(
        body: Center(child: Text('No test selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Select Lab'),
            Text(
              test.name,
              style: TextStyle(
                fontSize: 12,
                color: theme.brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Choose Service Type
              Text(
                'Choose Service Type',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildServiceTypeCard(
                      theme: theme,
                      title: 'Lab Visit',
                      subtitle: 'Visit the lab',
                      icon: Icons.business,
                      isActive: !_isHomeCollection,
                      onTap: () {
                        setState(() {
                          _isHomeCollection = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildServiceTypeCard(
                      theme: theme,
                      title: 'Home Collection',
                      subtitle: 'Sample at home',
                      icon: Icons.home_outlined,
                      isActive: _isHomeCollection,
                      onTap: () {
                        setState(() {
                          _isHomeCollection = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Available Labs Near You
              Text(
                'Available Labs Near You',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.allLabs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final lab = state.allLabs[index];
                  final isLabSelected = _selectedLab?.id == lab.id;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLab = lab;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isLabSelected ? theme.primaryColor : (theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200),
                          width: isLabSelected ? 2 : 1,
                        ),
                        boxShadow: isLabSelected
                            ? [
                                BoxShadow(
                                  color: theme.primaryColor.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lab.name,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: AppTheme.amberGold, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${lab.rating} (${lab.reviewsCount}+ reviews)',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isLabSelected ? theme.primaryColor : Colors.grey.shade400,
                                    width: isLabSelected ? 6 : 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildLabRow(theme, Icons.location_on_outlined, lab.address),
                          const SizedBox(height: 10),
                          _buildLabRow(theme, Icons.access_time, lab.hours),
                          const SizedBox(height: 10),
                          _buildLabRow(theme, Icons.phone_outlined, lab.phone),
                          
                          if (lab.hasHomeCollection) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.emeraldGreen.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.home_outlined, color: AppTheme.emeraldGreen, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Home collection available',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.emeraldGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(height: 1),
                          ),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Test Price',
                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                              ),
                              Text(
                                '\$${test.price.toInt()}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
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
          onPressed: _selectedLab == null
              ? null
              : () {
                  state.selectedLab = _selectedLab;
                  state.isHomeCollection = _isHomeCollection;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectDateTimeScreen(),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
            disabledForegroundColor: Colors.grey,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Continue to Schedule',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTypeCard({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final borderColor = isActive
        ? theme.primaryColor
        : (theme.brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive ? theme.primaryColor : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : (theme.brightness == Brightness.dark ? Colors.white54 : Colors.grey.shade600),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isActive ? theme.primaryColor : (theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87),
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.hintColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
