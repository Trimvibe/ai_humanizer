import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../components/glass_card.dart';
import '../../components/glowing_button.dart';
import '../../services/ai_service.dart';

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key});

  @override
  State<DetectorScreen> createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _results;

  void _analyzeText() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _results = null;
    });

    final res = await AIService.detectAI(_textController.text);

    setState(() {
      _results = res;
      _isAnalyzing = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI Detector',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  expands: true,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark ? AppColors.textPrimary : Colors.black,
                      ),
                  decoration: InputDecoration(
                    hintText: 'Paste text to analyze...',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: GlowingButton(
                text: _isAnalyzing ? 'Analyzing...' : 'Analyze Text',
                icon: LucideIcons.scanLine,
                glowColor: AppColors.neonBlue,
                onPressed: _isAnalyzing ? () {} : _analyzeText,
              ),
            ),
            const SizedBox(height: 32),
            if (_isAnalyzing)
              const Center(child: CircularProgressIndicator(color: AppColors.neonBlue)),
            if (_results != null) ...[
              Text(
                'Analysis Results',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildResultBar(context, 'AI Probability', _results!['aiScore'], AppColors.neonPurple),
                    const SizedBox(height: 24),
                    _buildResultBar(context, 'Human Score', _results!['humanScore'], AppColors.neonCyan),
                    const SizedBox(height: 24),
                    _buildResultBar(context, 'Readability', _results!['readability'], AppColors.neonBlue),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildResultBar(BuildContext context, String label, int score, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            Text('$score%', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: score / 100,
          backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFE2E8F0),
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
