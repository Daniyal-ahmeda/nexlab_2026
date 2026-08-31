import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/features/booking/presentation/pages/select_date_time/select_date_time_screen.dart';

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
    _selectedLab = state.selectedLab ?? (state.allLabs.isNotEmpty ? state.allLabs.first : null);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);
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
            Text(
              l10n.selectLab,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'Outfit',
              ),
            ),
            Text(
              test.name,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => state.refreshAll(),
        color: AppTheme.primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.all(20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Collection Method Toggle
            Text(
              isArabic ? 'طريقة سحب العينة' : 'COLLECTION METHOD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                letterSpacing: 0.8,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161F30) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMethodSegment(
                      title: isArabic ? 'زيارة المختبر' : 'Lab Visit',
                      subtitle: isArabic ? 'حضور شخصي للمقر' : 'Visit branch in Tripoli',
                      icon: Icons.local_hospital_outlined,
                      isSelected: !_isHomeCollection,
                      onTap: () => setState(() => _isHomeCollection = false),
                      isDark: isDark,
                    ),
                  ),
                  Expanded(
                    child: _buildMethodSegment(
                      title: isArabic ? 'سحب منزلي' : 'Home Visit',
                      subtitle: isArabic ? 'فني مختبر لمنزلك' : 'Technician arrives at home',
                      icon: Icons.home_outlined,
                      isSelected: _isHomeCollection,
                      onTap: () => setState(() => _isHomeCollection = true),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Labs List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isArabic ? 'المختبرات المعتمدة في طرابلس' : 'ACCREDITED LAB PARTNERS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    letterSpacing: 0.8,
                    fontFamily: 'Outfit',
                  ),
                ),
                Text(
                  '${state.allLabs.length} ${isArabic ? 'مختبرات' : 'labs'}',
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

            // 3. Labs Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.allLabs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lab = state.allLabs[index];
                final isSelected = _selectedLab?.id == lab.id;

                return InkWell(
                  onTap: () => setState(() => _selectedLab = lab),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF161F30) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : AppTheme.cardShadow(isDark),
                    ),
                    child: Row(
                      children: [
                        // Radio dot or icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                                : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isSelected ? Icons.check_circle_rounded : Icons.local_hospital_outlined,
                            color: isSelected ? AppTheme.primaryBlue : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      lab.name,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Outfit',
                                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.amberGold.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star_rounded, size: 12, color: AppTheme.amberGold),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${lab.rating}',
                                          style: const TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.amberGold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                lab.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.schedule_outlined, size: 12, color: AppTheme.primaryBlue),
                                  const SizedBox(width: 3),
                                  Text(
                                    lab.hours,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.verified_rounded, size: 12, color: AppTheme.emeraldGreen),
                                  const SizedBox(width: 3),
                                  Text(
                                    isArabic ? 'معتمد' : 'Verified',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.emeraldGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
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
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _selectedLab == null
                  ? null
                  : () {
                      state.selectedLab = _selectedLab;
                      state.isHomeCollection = _isHomeCollection;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SelectDateTimeScreen()),
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
                    isArabic ? 'متابعة لاختيار الموعد' : 'Continue to Date & Time',
                    style: const TextStyle(
                      fontSize: 14,
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
      ),
    );
  }

  Widget _buildMethodSegment({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'Outfit',
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                color: isSelected
                    ? Colors.white70
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
