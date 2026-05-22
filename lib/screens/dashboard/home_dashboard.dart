import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../components/glass_card.dart';
import '../../components/glowing_button.dart';
import '../../services/ai_service.dart';
import '../../services/credit_service.dart';
import 'output_screen.dart';

class HomeDashboard extends StatefulWidget {
  final Function(int)? onNavigate;

  const HomeDashboard({super.key, this.onNavigate});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final TextEditingController _textController = TextEditingController();
  int _wordCount = 0;
  int _charCount = 0;
  double _intensity = 1.0;
  String _selectedTone = 'Professional';
  bool _isLoading = false;

  final List<String> _tones = [
    'Casual',
    'Academic',
    'Professional',
    'Gen-Z',
    'Storytelling',
    'Emotional',
    'Persuasive'
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      final text = _textController.text;
      setState(() {
        _charCount = text.length;
        _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showUpgradeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: AppColors.glassBorder),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.alertTriangle, color: Colors.orangeAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              'Daily Limit Reached',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'All users are limited to 1000 words per day. Please try again tomorrow.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: GlowingButton(
                text: 'OK',
                glowColor: AppColors.neonCyan,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundSlate : const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.neonPurple.withOpacity(0.5)),
              ),
              child: const Icon(LucideIcons.sparkles, color: AppColors.neonPurple, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'HumanFlow',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history, color: AppColors.neonCyan),
            onPressed: () {
              if (widget.onNavigate != null) {
                widget.onNavigate!(2); // Navigate to History tab
              }
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.user, color: AppColors.neonCyan),
            onPressed: () {
              if (widget.onNavigate != null) {
                widget.onNavigate!(3); // Navigate to Profile tab
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Input Text',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.upload, size: 20),
                            color: AppColors.textSecondary,
                            onPressed: () {},
                            tooltip: 'Upload File (.txt, .pdf, .docx)',
                          ),
                          IconButton(
                            icon: const Icon(LucideIcons.trash2, size: 20),
                            color: AppColors.textSecondary,
                            onPressed: () => _textController.clear(),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black12),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark ? AppColors.textPrimary : Colors.black,
                          ),
                      cursorColor: AppColors.neonCyan,
                      decoration: InputDecoration(
                        hintText: 'Paste your AI text here...',
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_wordCount words | $_charCount characters',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.textSecondary : Colors.black87,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Credits: ${CreditService.isPro() ? "Pro (Unlimited)" : "${CreditService.getRemainingCredits()} words left today"}',
                            style: TextStyle(
                              color: AppColors.neonCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(LucideIcons.bot, size: 16, color: AppColors.neonPurple),
                          const SizedBox(width: 4),
                          Text(
                            'AI Prob: 98%',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.neonPurple,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Select Tone',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _tones.map((tone) {
                final isSelected = _selectedTone == tone;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTone = tone),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.neonCyan.withOpacity(0.2) : (isDark ? AppColors.backgroundSlate : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.neonCyan : (isDark ? AppColors.glassBorder : Colors.black12),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.neonCyan.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      tone,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isSelected ? AppColors.neonCyan : (isDark ? AppColors.textPrimary : Colors.black87),
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Humanization Intensity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  _intensity == 0 ? 'Low' : _intensity == 1 ? 'Medium' : 'Heavy',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.neonPurple,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _intensity,
              min: 0,
              max: 2,
              divisions: 2,
              activeColor: AppColors.neonPurple,
              inactiveColor: isDark ? AppColors.backgroundSlate : const Color(0xFFE2E8F0),
              onChanged: (val) {
                setState(() {
                  _intensity = val;
                });
              },
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.neonPurple))
                : GlowingButton(
                text: 'Humanize Now',
                icon: LucideIcons.zap,
                onPressed: () async {
                  final text = _textController.text.trim();
                  if (text.isEmpty) return;
                  
                  final wordCount = text.split(RegExp(r'\s+')).length;
                  if (!CreditService.hasEnoughCredits(wordCount)) {
                    _showUpgradeBottomSheet();
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  final result = await AIService.humanizeText(
                    text: _textController.text,
                    tone: _selectedTone,
                    intensity: _intensity,
                  );

                  await CreditService.consumeCredits(wordCount);

                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OutputScreen(
                          originalText: _textController.text,
                          humanizedText: result.humanizedText,
                          tone: _selectedTone,
                          intensity: _intensity,
                          corrections: result.corrections,
                        ),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
