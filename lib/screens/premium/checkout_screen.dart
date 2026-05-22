import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../components/glass_card.dart';
import '../../components/animated_text_field.dart';
import '../../components/glowing_button.dart';
import '../../services/credit_service.dart';

class CheckoutScreen extends StatefulWidget {
  final bool isYearly;
  const CheckoutScreen({super.key, required this.isYearly});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    if (_nameController.text.trim().isEmpty || _cardNumberController.text.length < 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid payment details.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate network delay for payment gateway authorization
    await Future.delayed(const Duration(seconds: 2));

    // Save "Pro Status" locally in SharedPreferences
    await CreditService.setProStatus(true);

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // Show success modal dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Icon(LucideIcons.checkCircle, color: AppColors.neonCyan, size: 28),
              SizedBox(width: 12),
              Text('Payment Successful!'),
            ],
          ),
          content: const Text(
            'Welcome to HumanFlow Pro! You now have unlimited generations, access to all premium tones, and high-intensity rewrites.',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Dismiss Dialog
                Navigator.of(context).pop(true); // Return true to previous screen
              },
              child: const Text('Get Started', style: TextStyle(color: AppColors.neonCyan, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.isYearly ? '\$9.99/mo (\$119.88 billed yearly)' : '\$12.99/mo';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Secure Checkout'),
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: isDark ? AppColors.textPrimary : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HumanFlow Pro Plan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.neonCyan),
                      ),
                    ],
                  ),
                  const Icon(LucideIcons.gem, color: AppColors.neonPurple, size: 36),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Payment Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            // Card Input Form
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  AnimatedTextField(
                    controller: _nameController,
                    hintText: 'Cardholder Name',
                    prefixIcon: LucideIcons.user,
                  ),
                  const SizedBox(height: 20),
                  AnimatedTextField(
                    controller: _cardNumberController,
                    hintText: 'Card Number (16 digits)',
                    prefixIcon: LucideIcons.creditCard,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedTextField(
                          controller: _expiryController,
                          hintText: 'MM/YY',
                          prefixIcon: LucideIcons.calendar,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AnimatedTextField(
                          controller: _cvvController,
                          hintText: 'CVC (3 digits)',
                          prefixIcon: LucideIcons.shieldAlert,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: _isProcessing
                        ? const Center(child: CircularProgressIndicator(color: AppColors.neonCyan))
                        : GlowingButton(
                            text: 'Pay & Subscribe',
                            icon: LucideIcons.lock,
                            glowColor: AppColors.neonCyan,
                            onPressed: _processPayment,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Guide banner explaining real implementation details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neonPurple.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.info, color: AppColors.neonPurple, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Production Setup Tip',
                        style: TextStyle(color: AppColors.neonPurple, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'To accept real payments in production:\n\n'
                    '1. Integrate Stripe using the `flutter_stripe` package or Razorpay using `razorpay_flutter`.\n'
                    '2. Set up your backend server (e.g. Supabase Edge Functions or Node.js) to initialize payments securely and obtain a client secret.\n'
                    '3. In your Flutter code, initialize the payment flow with `Stripe.instance.initPaymentSheet(...)` and present it to the user.\n'
                    '4. Configure webhook listeners on your backend to automatically upgrade the user profile inside Supabase table upon successful charge completion.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondary : Colors.black87,
                    ),
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
}
