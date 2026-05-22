import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';
import '../../components/glass_card.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _weeklyAnalytics = false;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs != null) {
      setState(() {
        _emailNotifications = _prefs!.getBool('pref_email_notifications') ?? true;
        _pushNotifications = _prefs!.getBool('pref_push_notifications') ?? true;
        _weeklyAnalytics = _prefs!.getBool('pref_weekly_analytics') ?? false;
      });
    }
  }

  void _updatePreference(String key, bool value) async {
    if (_prefs != null) {
      await _prefs!.setBool(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: isDark ? AppColors.textPrimary : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Preferences',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage how and when you want to receive alerts from HumanFlow.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildSwitchTile(
                    'Push Notifications',
                    'Get instant alerts on rewrite status and credit updates.',
                    _pushNotifications,
                    (val) {
                      setState(() {
                        _pushNotifications = val;
                      });
                      _updatePreference('pref_push_notifications', val);
                    },
                  ),
                  const Divider(color: AppColors.glassBorder, height: 32),
                  _buildSwitchTile(
                    'Email Reports',
                    'Receive reports on your processed documents and stats.',
                    _emailNotifications,
                    (val) {
                      setState(() {
                        _emailNotifications = val;
                      });
                      _updatePreference('pref_email_notifications', val);
                    },
                  ),
                  const Divider(color: AppColors.glassBorder, height: 32),
                  _buildSwitchTile(
                    'Weekly Summary',
                    'Get a weekly wrap up of your humanization analytics.',
                    _weeklyAnalytics,
                    (val) {
                      setState(() {
                        _weeklyAnalytics = val;
                      });
                      _updatePreference('pref_weekly_analytics', val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: AppColors.neonCyan,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
