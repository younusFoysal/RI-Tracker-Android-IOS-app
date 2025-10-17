import 'package:dio/dio.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  final Dio _dio = Dio();
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  void _initializeService() {
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY must be provided via --dart-define');
    }

    _dio.options = BaseOptions(
      baseUrl: 'https://api.openai.com/v1',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );
  }

  /// Generate session notes using AI
  Future<Map<String, dynamic>> generateSessionNotes({
    required String userInput,
    required String projectContext,
    required Duration sessionDuration,
  }) async {
    try {
      _initializeService();

      final messages = [
        {
          'role': 'system',
          'content':
              'You are a professional productivity assistant helping users create concise, meaningful session notes for their time tracking. Focus on key accomplishments, tasks completed, and next steps. Keep the tone professional yet personal.'
        },
        {
          'role': 'user',
          'content': '''
Please help me create professional session notes based on this information:

Project: $projectContext
Session Duration: ${_formatDuration(sessionDuration)}
User Input: $userInput

Please generate a well-structured note that includes:
1. Brief summary of what was accomplished
2. Key tasks or activities completed
3. Any challenges faced (if mentioned)
4. Next steps or follow-up actions (if relevant)

Keep it concise but informative, suitable for time tracking records.
'''
        }
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-5-mini',
          'messages': messages,
          'max_completion_tokens': 300,
          'reasoning_effort': 'minimal',
          'verbosity': 'low',
        },
      );

      final data = response.data;
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return {
          'success': true,
          'userNote': data['choices'][0]['message']['content'],
        };
      } else {
        return {
          'success': false,
          'message': 'No response generated',
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to generate notes';
      if (e.response?.data != null) {
        errorMessage = e.response!.data['error']['message'] ?? errorMessage;
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  /// Generate productivity insights using AI
  Future<Map<String, dynamic>> generateProductivityInsights({
    required Map<String, dynamic> dailyStats,
    required Map<String, dynamic> weeklyStats,
    required List<String> recentActivities,
  }) async {
    try {
      _initializeService();

      final messages = [
        {
          'role': 'system',
          'content':
              'You are a productivity coach analyzing time tracking data. Provide actionable insights, positive reinforcement, and practical suggestions for improvement. Be encouraging while being honest about areas for growth.'
        },
        {
          'role': 'user',
          'content': '''
Please analyze my productivity data and provide insights:

Daily Stats:
- Total time tracked: ${_formatDuration(Duration(seconds: dailyStats['totalHours'] ?? 0))}
- Active time: ${_formatDuration(Duration(seconds: dailyStats['activeHours'] ?? 0))}
- Productivity percentage: ${dailyStats['activePercentage']}%
- Sessions completed: ${dailyStats['sessionCount']}

Weekly Stats:
- Total time tracked: ${_formatDuration(Duration(seconds: weeklyStats['totalHours'] ?? 0))}
- Weekly productivity: ${weeklyStats['activePercentage']}%
- Average sessions per day: ${weeklyStats['averageSessionsPerDay']}

Recent activities: ${recentActivities.join(', ')}

Please provide:
1. Key productivity insights
2. Areas doing well
3. Suggestions for improvement
4. Motivational message

Keep it concise and actionable.
'''
        }
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-5-mini',
          'messages': messages,
          'max_completion_tokens': 400,
          'reasoning_effort': 'low',
          'verbosity': 'medium',
        },
      );

      final data = response.data;
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        return {
          'success': true,
          'insights': data['choices'][0]['message']['content'],
        };
      } else {
        return {
          'success': false,
          'message': 'No insights generated',
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to generate insights';
      if (e.response?.data != null) {
        errorMessage = e.response!.data['error']['message'] ?? errorMessage;
      }

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  /// Format duration for display
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Check if AI service is available
  bool get isAvailable => apiKey.isNotEmpty;
}
