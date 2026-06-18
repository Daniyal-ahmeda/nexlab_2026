import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
              // Notifications Section
              _buildSectionHeader('NOTIFICATIONS', theme),
              Card(
                child: Column(
                  children: [
                    _buildSwitchItem(
                      theme: theme,
                      icon: Icons.notifications_none_outlined,
                      iconColor: AppTheme.primaryBlue,
                      title: 'Push Notifications',
                      subtitle: 'Get notified about bookings & results',
                      value: _pushNotifications,
                      onChanged: (val) {
                        setState(() {
                          _pushNotifications = val;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildSwitchItem(
                      theme: theme,
                      icon: Icons.mail_outline,
                      iconColor: AppTheme.emeraldGreen,
                      title: 'Email Notifications',
                      subtitle: 'Receive updates via email',
                      value: _emailNotifications,
                      onChanged: (val) {
                        setState(() {
                          _emailNotifications = val;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildSwitchItem(
                      theme: theme,
                      icon: Icons.sms_outlined,
                      iconColor: AppTheme.purpleAmethyst,
                      title: 'SMS Notifications',
                      subtitle: 'Get text message updates',
                      value: _smsNotifications,
                      onChanged: (val) {
                        setState(() {
                          _smsNotifications = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Appearance Section
              _buildSectionHeader('APPEARANCE', theme),
              Card(
                child: Column(
                  children: [
                    _buildSwitchItem(
                      theme: theme,
                      icon: Icons.dark_mode_outlined,
                      iconColor: AppTheme.purpleAmethyst,
                      title: 'Dark Mode',
                      subtitle: 'Switch to dark theme',
                      value: state.isDarkMode,
                      onChanged: (val) {
                        state.toggleTheme();
                      },
                    ),
                    const Divider(height: 1),
                    _buildChevronItem(
                      theme: theme,
                      icon: Icons.language_outlined,
                      iconColor: AppTheme.primaryBlue,
                      title: 'Language',
                      valueText: 'English (US)',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Language selection simulation!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data & Storage Section
              _buildSectionHeader('DATA & STORAGE', theme),
              Card(
                child: Column(
                  children: [
                    _buildSwitchItem(
                      theme: theme,
                      icon: Icons.download_outlined,
                      iconColor: AppTheme.emeraldGreen,
                      title: 'Auto-Download Reports',
                      subtitle: 'Save reports automatically',
                      value: _autoDownload,
                      onChanged: (val) {
                        setState(() {
                          _autoDownload = val;
                        });
                      },
                    ),
                    const Divider(height: 1),
                    _buildChevronItem(
                      theme: theme,
                      icon: Icons.delete_sweep_outlined,
                      iconColor: AppTheme.orangeSunset,
                      title: 'Clear Cache',
                      valueText: _cacheSize > 0 ? '${_cacheSize.toInt()} MB stored' : '0 MB (Cleared)',
                      onTap: () {
                        _simulateClearCache();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Security Section
              _buildSectionHeader('SECURITY', theme),
              Card(
                child: Column(
                  children: [
                    _buildChevronItem(
                      theme: theme,
                      icon: Icons.lock_outline,
                      iconColor: AppTheme.coralRed,
                      title: 'Change Password',
                      valueText: '',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Change password simulation!'),
                            behavior: SnackBarBehavior.floating,
                          ),
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

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: theme.hintColor,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildChevronItem({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String valueText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (valueText.isNotEmpty) ...[
              Text(
                valueText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
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
      ),
    );
  }

  void _simulateClearCache() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Storage Cache'),
          content: const Text('Are you sure you want to clear cached medical reports? This will release 245 MB of storage.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _cacheSize = 0.0;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache successfully cleared!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Clear', style: TextStyle(color: AppTheme.coralRed)),
            ),
          ],
        );
      },
    );
  }
}
