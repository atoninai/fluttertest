import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/models.dart';

class GroqService {
  static const String _apiKey = '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';
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _primaryModel = 'openai/gpt-oss-120b';
  static const String _fallbackModel = 'llama-3.3-70b-versatile';

  /// Generate a custom study routine using Groq AI
  static Future<GroqRoutineResponse> generateCustomRoutine({
    required String userRequest,
    required String sectionId,
    required List<Subject> subjects,
  }) async {
    try {
      // First try with primary model
      final response = await _makeRequest(
        userRequest: userRequest,
        sectionId: sectionId,
        subjects: subjects,
        model: _primaryModel,
      );
      
      return response;
    } catch (e) {
      if (e.toString().contains('rate_limit') || e.toString().contains('429')) {
        debugPrint('Rate limit hit on primary model, trying fallback...');
        
        // Try fallback model
        final response = await _makeRequest(
          userRequest: userRequest,
          sectionId: sectionId,
          subjects: subjects,
          model: _fallbackModel,
        );
        
        return response;
      }
      rethrow;
    }
  }

  static Future<GroqRoutineResponse> _makeRequest({
    required String userRequest,
    required String sectionId,
    required List<Subject> subjects,
    required String model,
  }) async {
    // Build subject list for context
    final subjectList = subjects.map((s) => '- ${s.name}').join('\n');
    
    final systemPrompt = '''You are a study routine generator for SSC 2026 students in Bangladesh.
The student is in the $sectionId section and is studying the following subjects:
$subjectList

Your task is to create a structured study routine based on their request.

IMPORTANT: You must respond ONLY with a valid JSON object in this exact format:
{
  "title": "Routine Title",
  "duration_days": number_of_days,
  "tasks": [
    {
      "subject": "Subject Name",
      "topic": "Topic/Chapter Name",
      "date": "YYYY-MM-DD",
      "start_time": "HH:MM",
      "duration_minutes": number,
      "description": "Brief description"
    }
  ]
}

Do not include any markdown formatting, explanations, or text outside the JSON object.''';

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userRequest},
        ],
        'temperature': 0.7,
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      
      // Parse the JSON response
      try {
        final routineData = jsonDecode(content.trim());
        return GroqRoutineResponse.fromJson(routineData);
      } catch (e) {
        throw Exception('Failed to parse AI response: $e\nContent: $content');
      }
    } else if (response.statusCode == 429) {
      throw Exception('rate_limit_exceeded');
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}

class GroqRoutineResponse {
  final String title;
  final int durationDays;
  final List<RoutineTask> tasks;

  GroqRoutineResponse({
    required this.title,
    required this.durationDays,
    required this.tasks,
  });

  factory GroqRoutineResponse.fromJson(Map<String, dynamic> json) {
    return GroqRoutineResponse(
      title: json['title'] as String,
      durationDays: json['duration_days'] as int,
      tasks: (json['tasks'] as List)
          .map((task) => RoutineTask.fromJson(task as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RoutineTask {
  final String subject;
  final String topic;
  final DateTime date;
  final TimeOfDay startTime;
  final int durationMinutes;
  final String description;

  RoutineTask({
    required this.subject,
    required this.topic,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.description,
  });

  factory RoutineTask.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String;
    final timeStr = json['start_time'] as String;
    
    final dateParts = dateStr.split('-');
    final timeParts = timeStr.split(':');
    
    return RoutineTask(
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      date: DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
      ),
      startTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      durationMinutes: json['duration_minutes'] as int,
      description: json['description'] as String,
    );
  }
}
