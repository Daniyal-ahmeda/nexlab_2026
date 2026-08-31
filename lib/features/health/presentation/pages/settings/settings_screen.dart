import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexlab_2026/core/l10n/app_localizations.dart';
import 'package:nexlab_2026/core/providers/app_state.dart';
import 'package:nexlab_2026/core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _autoDownload = true;
  double _cacheSize = 245.0;

  void _simulateClearCache(AppLocalizations l10n) {
    setState(() {
      _cacheSize = 0.0;
    });
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
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Text('🇱🇾', style: TextStyle(fontSize: 24)),
                  title: Text(
                    l10n.arabic,
                    style: TextStyle(
                      fontWeight: state.isArabic ? FontWeight.w800 : FontWeight.w500,
                      color: state.isArabic ? AppTheme.primaryBlue : null,
                    ),
                  ),
                  trailing: state.isArabic
                      ? const Icon(Icons.check_circle, color: AppTheme.primaryBlue)
                      : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  tileColor: state.isArabic
                      ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                      : null,
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
                      fontWeight: !state.isArabic ? FontWeight.w800 : FontWeight.w500,
                      color: !state.isArabic ? AppTheme.primaryBlue : null,
                    ),
                  ),
                  trailing: !state.isArabic
                      ? const Icon(Icons.check_circle, color: AppTheme.primaryBlue)
                      : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  tileColor: !state.isArabic
                      ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                      : null,
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language & Appearance
              _buildSectionTitle(l10n.appearanceSection, isDark),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildActionRow(
                      icon: Icons.language_outlined,
                      title: l10n.language,
                      valueText: state.isArabic ? l10n.arabic : l10n.english,
                      onTap: () => _showLanguageSelector(context, state, isDark, l10n),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSwitchRow(
                      icon: Icons.dark_mode_outlined,
                      title: l10n.darkMode,
                      subtitle: isDark ? 'OLED Dark Mode active' : 'Standard clean mode',
                      value: state.isDarkMode,
                      onChanged: (_) => state.toggleTheme(),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Notifications
              _buildSectionTitle(l10n.notificationsSection, isDark),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSwitchRow(
                      icon: Icons.notifications_none_outlined,
                      title: l10n.pushNotifications,
                      subtitle: l10n.pushSubtitle,
                      value: _pushNotifications,
                      onChanged: (val) => setState(() => _pushNotifications = val),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSwitchRow(
                      icon: Icons.mail_outline,
                      title: l10n.emailNotifications,
                      subtitle: l10n.emailSubtitle,
                      value: _emailNotifications,
                      onChanged: (val) => setState(() => _emailNotifications = val),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSwitchRow(
                      icon: Icons.sms_outlined,
                      title: l10n.smsNotifications,
                      subtitle: l10n.smsSubtitle,
                      value: _smsNotifications,
                      onChanged: (val) => setState(() => _smsNotifications = val),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data & Storage
              _buildSectionTitle(l10n.storageSection, isDark),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSwitchRow(
                      icon: Icons.download_outlined,
                      title: 'Auto-Download Medical PDFs',
                      subtitle: 'Store reports offline upon completion',
                      value: _autoDownload,
                      onChanged: (val) => setState(() => _autoDownload = val),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildActionRow(
                      icon: Icons.delete_sweep_outlined,
                      title: l10n.clearCache,
                      valueText: _cacheSize > 0 ? '${_cacheSize.toInt()} MB' : '0 MB',
                      onTap: () => _simulateClearCache(l10n),
                      isDark: isDark,
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

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          letterSpacing: 0.8,
          fontFamily: 'Outfit',
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: isDark ? Colors.grey.shade300 : const Color(0xFF334155)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Outfit',
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeTrackColor: AppTheme.primaryBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String valueText,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: isDark ? Colors.grey.shade300 : const Color(0xFF334155)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Outfit',
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (valueText.isNotEmpty)
            Text(
              valueText,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right, size: 18, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
        ],
      ),
    );
  }
}
