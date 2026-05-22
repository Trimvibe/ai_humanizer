import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_provider.dart';
import '../../components/glass_card.dart';
import '../auth/login_screen.dart';
import 'account_settings_screen.dart';
import 'help_support_screen.dart';
import 'notification_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _displayName = 'Guest User';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? '';
        // Name comes from Google OAuth user_metadata
        _displayName = user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            user.email?.split('@')[0] ??
            'User';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.backgroundSlate,
                      border: Border.all(color: AppColors.neonPurple, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPurple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.user, size: 40, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.neonCyan,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.edit2, size: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _displayName,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            if (_email.isNotEmpty)
              Text(
                _email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            const SizedBox(height: 4),
            const SizedBox(height: 32),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    context, 
                    LucideIcons.settings, 
                    'Account Settings',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AccountSettingsScreen()),
                      ).then((_) => _loadUserData());
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    LucideIcons.bell,
                    'Notifications',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()),
                      );
                    },
                  ),
                  _buildDivider(),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return _buildListTile(
                        context,
                        LucideIcons.moon,
                        'Dark Mode',
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (val) {
                            themeProvider.toggleTheme();
                          },
                          activeColor: AppColors.neonPurple,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildListTile(
                    context, 
                    LucideIcons.share2, 
                    'Share App with Friends',
                    onTap: () => _shareApp(context),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context, 
                    LucideIcons.helpCircle, 
                    'Help & Support',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    LucideIcons.logOut,
                    'Log Out',
                    textColor: Colors.red,
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.backgroundSlate,
                          title: Text('Log Out', style: Theme.of(ctx).textTheme.titleLarge),
                          content: Text('Are you sure you want to log out?', style: Theme.of(ctx).textTheme.bodyLarge),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await Supabase.instance.client.auth.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      }
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

  void _shareApp(BuildContext context) {
    Clipboard.setData(
      const ClipboardData(
        text: 'Check out HumanFlow AI! Make AI-generated writing sound natural, bypass AI detectors, and fix grammar mistakes instantly. Download or access it here: https://humanflow-ai.web.app',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(LucideIcons.check, color: AppColors.neonCyan),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Share link copied to clipboard! Paste it to share with your friends.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundSlate,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, {Widget? trailing, Color? textColor, VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.textPrimary : Colors.black87;

    return ListTile(
      leading: Icon(icon, color: textColor ?? defaultColor),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColor ?? defaultColor,
            ),
      ),
      trailing: trailing ?? Icon(LucideIcons.chevronRight, color: AppColors.textSecondary),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: AppColors.glassBorder);
  }
}
