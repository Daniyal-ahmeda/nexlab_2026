import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void _simulateClearCache() {
    setState(() {
      _cacheSize = 0.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Temporary medical report cache cleared (245 MB freed).'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings & Security',
          style: TextStyle(
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
              // Notifications
              _buildSectionTitle('NOTIFICATIONS & ALERTS', isDark),
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
                      title: 'Push Notifications',
                      subtitle: 'Alerts for sample updates & report ready',
                      value: _pushNotifications,
                      onChanged: (val) => setState(() => _pushNotifications = val),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSwitchRow(
                      icon: Icons.mail_outline,
                      title: 'Email Notifications',
                      subtitle: 'Official PDF report copies sent to email',
                      value: _emailNotifications,
                      onChanged: (val) => setState(() => _emailNotifications = val),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildSwitchRow(
                      icon: Icons.sms_outlined,
                      title: 'SMS Appointment Reminders',
                      subtitle: 'Text updates for home technician arrival',
                      value: _smsNotifications,
                      onChanged: (val) => setState(() => _smsNotifications = val),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Appearance & Language
              _buildSectionTitle('DISPLAY & PREFERENCES', isDark),
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
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Theme',
                      subtitle: 'High contrast OLED clinical interface',
                      value: state.isDarkMode,
                      onChanged: (_) => state.toggleTheme(),
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildActionRow(
                      icon: Icons.language_outlined,
                      title: 'App Interface Language',
                      valueText: 'English (US) • العربية',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bilingual English / Arabic support active.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data & Storage
              _buildSectionTitle('DATA & STORAGE', isDark),
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
                      title: 'Clear Report Cache',
                      valueText: _cacheSize > 0 ? '${_cacheSize.toInt()} MB cached' : '0 MB (Cleared)',
                      onTap: _simulateClearCache,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security & Privacy
              _buildSectionTitle('SECURITY & PRIVACY', isDark),
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
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      valueText: 'Updated 30d ago',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password security active.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      isDark: isDark,
                    ),
                    const Divider(height: 1),
                    _buildActionRow(
                      icon: Icons.privacy_tip_outlined,
                      title: 'HIPAA & Medical Data Privacy',
                      valueText: 'ISO 27001 Compliant',
                      onTap: () {},
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
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
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
