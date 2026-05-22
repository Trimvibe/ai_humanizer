import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';
import '../../components/glass_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    if (supabase.auth.currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }
    
    try {
      final data = await supabase
          .from('generations')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);
          
      setState(() {
        _history = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching history: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'History',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.neonPurple))
        : _history.isEmpty
            ? Center(
                child: Text(
                  'No history found.\nHumanize some text first!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                itemCount: _history.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = _history[index];
                  final tone = item['tone'] ?? 'Unknown Tone';
                  final wordCount = item['word_count'] ?? 0;
                  final originalText = item['original_text'] ?? '';
                  final snippet = originalText.length > 30 
                      ? '${originalText.substring(0, 30)}...' 
                      : originalText;

                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  final iconBgColor = isDark ? AppColors.backgroundDark : const Color(0xFFE2E8F0);
                  final borderCol = isDark ? AppColors.glassBorder : Colors.black12;

                  return GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: borderCol),
                          ),
                          child: const Icon(LucideIcons.fileText, color: AppColors.neonPurple),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snippet.isEmpty ? 'Untitled Project' : snippet,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$tone • $wordCount words',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.moreVertical, color: AppColors.textSecondary),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
