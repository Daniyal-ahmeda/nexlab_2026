import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';
import 'package:nexlab_2026/shared/widgets/nexlab_logo.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = true;
  double _cacheSize = 24.5;

  void _simulateClearCache(AppLocalizations l10n) {
    setState(() => _cacheSize = 0.0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.cacheFreed),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, AppState state, bool isDark, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF161F30) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Text('🇱🇾', style: TextStyle(fontSize: 24)),
                  title: Text(
                    l10n.arabic,
                    style: TextStyle(
                      fontWeight: state.isArabic ? FontWeight.w800 : FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: state.isArabic ? AppTheme.primaryBlue : null,
                    ),
                  ),
                  trailing: state.isArabic ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryBlue) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: state.isArabic ? AppTheme.primaryBlue.withValues(alpha: 0.1) : null,
                  onTap: () {
                    state.setLocale(const Locale('ar'));
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                  title: Text(
                    l10n.english,
                    style: TextStyle(
                      fontWeight: !state.isArabic ? FontWeight.w800 : FontWeight.w600,
                      fontFamily: 'Outfit',
                      color: !state.isArabic ? AppTheme.primaryBlue : null,
                    ),
                  ),
                  trailing: !state.isArabic ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryBlue) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: !state.isArabic ? AppTheme.primaryBlue.withValues(alpha: 0.1) : null,
                  onTap: () {
                    state.setLocale(const Locale('en'));
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = state.isArabic;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'Outfit',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Preferences Section
            _buildSectionHeader(l10n.preferences, isDark),
            const SizedBox(height: 10),
            _buildCard(
              isDark: isDark,
              children: [
                ListTile(
                  leading: const Icon(Icons.language_rounded, color: AppTheme.primaryBlue),
                  title: Text(l10n.language, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit')),
                  subtitle: Text(state.isArabic ? l10n.arabic : l10n.english),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => _showLanguageSelector(context, state, isDark, l10n),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.purpleAmethyst),
                  title: Text(l10n.darkMode, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit')),
                  subtitle: Text(isDark ? 'OLED Dark' : 'Light Mode'),
                  value: state.isDarkMode,
                  activeThumbColor: AppTheme.primaryBlue,
                  onChanged: (_) => state.toggleTheme(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Notifications Section
            _buildSectionHeader(l10n.notifications, isDark),
            const SizedBox(height: 10),
            _buildCard(
              isDark: isDark,
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined, color: AppTheme.emeraldGreen),
                  title: Text(l10n.pushNotifications, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit')),
                  subtitle: Text(l10n.pushSubtitle),
                  value: _pushNotifications,
                  activeThumbColor: AppTheme.primaryBlue,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.sms_outlined, color: AppTheme.amberGold),
                  title: Text(l10n.smsAlerts, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit')),
                  subtitle: Text(l10n.smsSubtitle),
                  value: _smsNotifications,
                  activeThumbColor: AppTheme.primaryBlue,
                  onChanged: (val) => setState(() => _smsNotifications = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.email_outlined, color: AppTheme.primaryCyan),
                  title: Text(l10n.emailReports, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit')),
                  subtitle: Text(l10n.emailSubtitle),
                  value: _emailNotifications,
                  activeThumbColor: AppTheme.primaryBlue,
                  onChanged: (val) => setState(() => _emailNotifications = val),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Storage Section
            _buildSectionHeader(l10n.dataStorage, isDark),
            const SizedBox(height: 10),
            _buildCard(
              isDark: isDark,
              children: [
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined, color: AppTheme.orangeSunset),
                  title: Text(l10n.clearCache, style: const TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Outfit')),
                  subtitle: Text('${_cacheSize.toStringAsFixed(1)} MB ${l10n.cachedData}'),
                  trailing: TextButton(
                    onPressed: _cacheSize > 0 ? () => _simulateClearCache(l10n) : null,
                    child: Text(
                      l10n.clear,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _cacheSize > 0 ? AppTheme.coralRed : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. About & Version
            Center(
              child: Column(
                children: [
                  NexLabLogo(
                    useFullLogo: true,
                    height: 28,
                    isWhite: isDark,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'NexLab Diagnostic v2.4.0 (2026)',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isArabic ? 'بوابة التحاليل الطبية الرائدة في طرابلس، ليبيا' : 'Tripoli Medical Diagnostic Portal',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        letterSpacing: 0.8,
        fontFamily: 'Outfit',
      ),
    );
  }

  Widget _buildCard({required bool isDark, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
        boxShadow: AppTheme.cardShadow(isDark),
      ),
      child: Column(children: children),
    );
  }
}
