import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../components/glowing_button.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Humanize AI Text',
      'description': 'Bypass robotic writing and make your AI-generated content sound natural and authentic.',
      'icon': LucideIcons.sparkles,
      'color': AppColors.neonPurple,
    },
    {
      'title': 'Multiple Tones',
      'description': 'Choose from Casual, Academic, Professional, Gen-Z, Storytelling, and more to fit your audience.',
      'icon': LucideIcons.mic,
      'color': AppColors.neonCyan,
    },
    {
      'title': 'Beat AI Detectors',
      'description': 'Improve your human score and reduce AI detection probability with advanced rewriting algorithms.',
      'icon': LucideIcons.shieldCheck,
      'color': AppColors.neonBlue,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                        final page = _pages[index];
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        final circleBg = isDark ? AppColors.backgroundSlate : const Color(0xFFE2E8F0);
                        final iconColor = isDark ? Colors.white : Colors.black87;

                        return Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: circleBg,
                                  boxShadow: [
                                    BoxShadow(
                                      color: page['color'].withOpacity(0.3),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: page['color'].withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  page['icon'],
                                  size: 80,
                                  color: iconColor,
                                ),
                              ),
                        const SizedBox(height: 60),
                        Text(
                          page['title'],
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          page['description'],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.neonPurple
                              : AppColors.textSecondary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  GlowingButton(
                    text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    onPressed: _nextPage,
                    glowColor: AppColors.neonCyan,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
