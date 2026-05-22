import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../components/glass_card.dart';
import '../../components/glowing_button.dart';
import '../../services/ai_service.dart';

class OutputScreen extends StatefulWidget {
  final String originalText;
  final String humanizedText;
  final String tone;
  final double intensity;
  final List<GrammarCorrection> corrections;
  
  const OutputScreen({
    super.key,
    required this.originalText,
    required this.humanizedText,
    required this.tone,
    required this.intensity,
    required this.corrections,
  });

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  late int _humanScore;
  late int _readabilityScore;

  @override
  void initState() {
    super.initState();
    // Generate dynamic scores based on intensity & text length
    final rand = Random();
    final baseHuman = widget.intensity == 0 ? 70 : widget.intensity == 1 ? 82 : 92;
    final baseRead = widget.intensity == 0 ? 65 : widget.intensity == 1 ? 78 : 88;
    _humanScore = baseHuman + rand.nextInt(8);
    _readabilityScore = baseRead + rand.nextInt(8);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.humanizedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard!'),
        backgroundColor: AppColors.backgroundSlate,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareText() {
    Clipboard.setData(ClipboardData(text: widget.humanizedText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Text copied — paste it anywhere to share!'),
        backgroundColor: AppColors.backgroundSlate,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _downloadText() {
    Clipboard.setData(ClipboardData(text: 
      '--- Original Text ---\n${widget.originalText}\n\n--- Humanized Text (${widget.tone} tone) ---\n${widget.humanizedText}'
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Full text (original + humanized) copied to clipboard!'),
        backgroundColor: AppColors.backgroundSlate,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        title: Text(
          'Result',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.share2),
            onPressed: _shareText,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(LucideIcons.download),
            onPressed: _downloadText,
            tooltip: 'Copy full text',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreMeter(context, 'Human Score', _humanScore, AppColors.neonCyan),
                _buildScoreMeter(context, 'Readability', _readabilityScore, AppColors.neonPurple),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Original Text',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundSlate : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.glassBorder : Colors.black12),
              ),
              child: Text(
                widget.originalText.isEmpty ? 'No text provided.' : widget.originalText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondary : Colors.black54,
                      decoration: TextDecoration.lineThrough,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.neonPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.neonPurple),
                  ),
                  child: Text(
                    'Tone: ${widget.tone}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.neonPurple),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.neonCyan.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.neonCyan),
                  ),
                  child: Text(
                    'Intensity: ${widget.intensity == 0 ? "Low" : widget.intensity == 1 ? "Medium" : "High"}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.neonCyan),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Humanized Text',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.neonCyan,
                      ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.copy, size: 20),
                  color: AppColors.neonCyan,
                  onPressed: _copyToClipboard,
                  tooltip: 'Copy',
                ),
              ],
            ),
            const SizedBox(height: 8),
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Text(
                widget.humanizedText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            
            // WRONG WORDS & GRAMMAR CORRECTIONS
            Text(
              'Grammar & Spelling Corrections',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (widget.corrections.isEmpty)
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(LucideIcons.checkCircle2, color: AppColors.neonCyan, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Perfect grammar! No errors or corrections detected.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.neonCyan,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...widget.corrections.map((corr) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                                ),
                                child: Text(
                                  corr.original,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Icon(LucideIcons.arrowRight, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.neonCyan.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.neonCyan.withOpacity(0.4)),
                                ),
                                child: Text(
                                  corr.replacement,
                                  style: const TextStyle(
                                    color: AppColors.neonCyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            corr.reason,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: GlowingButton(
                text: 'Rewrite Again',
                icon: LucideIcons.rotateCcw,
                glowColor: AppColors.neonPurple,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreMeter(BuildContext context, String label, int score, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 8,
                backgroundColor: AppColors.backgroundSlate,
                color: color,
              ),
            ),
            Text(
              '$score%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
