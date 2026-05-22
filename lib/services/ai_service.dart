import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

const String GROQ_API_KEY = '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';

class GrammarCorrection {
  final String original;
  final String replacement;
  final String reason;

  GrammarCorrection({
    required this.original,
    required this.replacement,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'original': original,
        'replacement': replacement,
        'reason': reason,
      };

  factory GrammarCorrection.fromJson(Map<String, dynamic> json) {
    return GrammarCorrection(
      original: json['original'] ?? '',
      replacement: json['replacement'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}

class HumanizationResult {
  final String humanizedText;
  final List<GrammarCorrection> corrections;

  HumanizationResult({
    required this.humanizedText,
    required this.corrections,
  });
}

class AIService {
  // AI Text Humanization with Supabase Integration & Corrections
  static Future<HumanizationResult> humanizeText({
    required String text,
    required String tone,
    required double intensity,
  }) async {
    String resultText = "Failed to humanize text.";
    List<GrammarCorrection> corrections = [];
    
    if (GROQ_API_KEY == 'YOUR_GROQ_API_KEY_HERE' || GROQ_API_KEY.isEmpty) {
      resultText = "Please enter your Groq API Key in lib/services/ai_service.dart to enable real AI generation.";
    } else {
      try {
        final intensityString = intensity == 0 ? 'Low' : intensity == 1 ? 'Medium' : 'High';
        final prompt = '''
Rewrite the following text to sound human-like and bypass AI detectors.
Tone: $tone
Intensity of changes: $intensityString

Additionally, scan the input text for any grammar, spelling, typos, or awkward phrasing. Correct them in the rewritten text, and note down all corrections.

You MUST respond ONLY with a JSON object in this exact format:
{
  "humanized_text": "The completely rewritten human-like text goes here...",
  "corrections": [
    {
      "original": "spelling_error_or_wrong_phrase",
      "replacement": "corrected_word_or_phrase",
      "reason": "explanation of what was wrong and why it was corrected"
    }
  ]
}

Text to rewrite:
$text
''';

        final response = await http.post(
          Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
          headers: {
            'Authorization': 'Bearer $GROQ_API_KEY',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': 'llama-3.1-8b-instant',
            'response_format': {'type': 'json_object'},
            'messages': [
              {'role': 'system', 'content': 'You are an expert copywriter and editor. You always respond with JSON.'},
              {'role': 'user', 'content': prompt}
            ],
            'temperature': 0.7,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final contentString = data['choices'][0]['message']['content'].toString().trim();
          final parsedJson = jsonDecode(contentString);
          
          resultText = parsedJson['humanized_text'] ?? "Failed to humanize.";
          
          final correctionsJson = parsedJson['corrections'] as List?;
          if (correctionsJson != null) {
            corrections = correctionsJson
                .map((c) => GrammarCorrection.fromJson(Map<String, dynamic>.from(c)))
                .toList();
          }
        } else {
          print('Groq API Error: ${response.statusCode} - ${response.body}');
          resultText = "Error from AI provider. Check console.";
        }
      } catch (e) {
        print('Error calling Groq API: $e');
        resultText = "Network error. Could not reach AI provider.";
      }
    }
    
    // Save to Supabase (History)
    try {
      final supabase = Supabase.instance.client;
      if (supabase.auth.currentUser != null) {
        final wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
        
        await supabase.from('generations').insert({
          'user_id': supabase.auth.currentUser!.id,
          'original_text': text,
          'humanized_text': resultText,
          'tone': tone,
          'intensity': intensity,
          'word_count': wordCount,
        });
      }
    } catch (e) {
      print('Error saving generation to Supabase: $e');
    }

    return HumanizationResult(humanizedText: resultText, corrections: corrections);
  }

  // Real AI Detector check using Groq API
  static Future<Map<String, dynamic>> detectAI(String text) async {
    if (GROQ_API_KEY == 'YOUR_GROQ_API_KEY_HERE' || GROQ_API_KEY.isEmpty) {
      return {
        'aiScore': 50,
        'humanScore': 50,
        'readability': 50,
      };
    }

    try {
      final prompt = '''
Analyze the following text and determine:
1. The probability that it was written by an AI (0-100%).
2. The probability that it was written by a human (0-100%, should complement the AI score).
3. The readability score (0-100%, where 100 means extremely easy to read, 0 means extremely hard).

You MUST respond ONLY with a JSON object in this exact format:
{
  "aiScore": 85,
  "humanScore": 15,
  "readability": 70
}

Text to analyze:
$text
''';

      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $GROQ_API_KEY',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-8b-instant',
          'response_format': {'type': 'json_object'},
          'messages': [
            {'role': 'system', 'content': 'You are a professional AI detector and linguist. You always respond with JSON.'},
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.3,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final contentString = data['choices'][0]['message']['content'].toString().trim();
        final parsedJson = jsonDecode(contentString);
        return {
          'aiScore': parsedJson['aiScore'] ?? 50,
          'humanScore': parsedJson['humanScore'] ?? 50,
          'readability': parsedJson['readability'] ?? 50,
        };
      }
    } catch (e) {
      print('Error in real AI detection: $e');
    }

    return {
      'aiScore': 45,
      'humanScore': 55,
      'readability': 60,
    };
  }
}
