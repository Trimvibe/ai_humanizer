import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../components/glass_card.dart';
import '../../components/glowing_button.dart';

import 'checkout_screen.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isYearly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(LucideIcons.gem, color: AppColors.neonPurple, size: 64),
            const SizedBox(height: 16),
            Text(
              'Unlock HumanFlow Pro',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Bypass AI detectors with unlimited words and advanced tones.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Monthly',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: !_isYearly ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                ),
                Switch(
                  value: _isYearly,
                  activeColor: AppColors.neonCyan,
                  onChanged: (val) {
                    setState(() {
                      _isYearly = val;
                    });
                  },
                ),
                Text(
                  'Yearly (-20%)',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _isYearly ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GlassCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _isYearly ? '\$9.99' : '\$12.99',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppColors.neonCyan,
                            ),
                      ),
                      Text(
                        '/mo',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureRow(context, 'Unlimited words per month'),
                  _buildFeatureRow(context, 'Advanced emotional tones'),
                  _buildFeatureRow(context, 'Built-in AI Detector'),
                  _buildFeatureRow(context, 'Export to PDF & DOCX'),
                  _buildFeatureRow(context, 'Priority processing speed'),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: GlowingButton(
                      text: 'Upgrade Now',
                      glowColor: AppColors.neonCyan,
                      onPressed: () async {
                        final success = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(isYearly: _isYearly),
                          ),
                        );
                        if (success == true && mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {},
              child: Text(
                'Restore Purchases',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const Icon(LucideIcons.checkCircle2, color: AppColors.neonCyan, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
