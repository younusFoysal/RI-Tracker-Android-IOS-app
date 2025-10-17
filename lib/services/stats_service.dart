import 'package:dio/dio.dart';

import './auth_service.dart';
import './config_service.dart';

class StatsService {
  static final StatsService _instance = StatsService._internal();
  factory StatsService() => _instance;
  StatsService._internal();

  final AuthService _authService = AuthService();

  /// Get daily stats for current employee
  Future<Map<String, dynamic>> getDailyStats() async {
    if (!_authService.isAuthenticated) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    try {
      // Get local timezone
      final now = DateTime.now();
      final localTz = now.timeZoneName;

      final employeeId = _authService.currentUser!.employeeId;

      final response = await _authService.dio.get(
        '${AppConfig.urls['DAILY_STATS']!}/$employeeId',
        queryParameters: {
          'timezone': localTz,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_authService.authToken}',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data['success'] == true) {
        return {
          'success': true,
          'data': DailyStatsModel.fromJson(data['data']),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get daily stats',
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.response?.data != null) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
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

  /// Get weekly stats for current employee
  Future<Map<String, dynamic>> getWeeklyStats() async {
    if (!_authService.isAuthenticated) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    try {
      // Get local timezone
      final now = DateTime.now();
      final localTz = now.timeZoneName;

      final employeeId = _authService.currentUser!.employeeId;

      final response = await _authService.dio.get(
        '${AppConfig.urls['WEEKLY_STATS']!}/$employeeId',
        queryParameters: {
          'timezone': localTz,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_authService.authToken}',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data['success'] == true) {
        return {
          'success': true,
          'data': WeeklyStatsModel.fromJson(data['data']),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get weekly stats',
        };
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      if (e.response?.data != null) {
        errorMessage = e.response!.data['message'] ?? errorMessage;
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
}

class DailyStatsModel {
  final String date;
  final int totalHours; // in seconds
  final int activeHours; // in seconds
  final int idleHours; // in seconds
  final int activePercentage;
  final int sessionCount;

  DailyStatsModel({
    required this.date,
    required this.totalHours,
    required this.activeHours,
    required this.idleHours,
    required this.activePercentage,
    required this.sessionCount,
  });

  factory DailyStatsModel.fromJson(Map<String, dynamic> json) {
    return DailyStatsModel(
      date: json['date'] ?? '',
      totalHours: json['totalHours'] ?? 0,
      activeHours: json['activeHours'] ?? 0,
      idleHours: json['idleHours'] ?? 0,
      activePercentage: json['activePercentage'] ?? 0,
      sessionCount: json['sessionCount'] ?? 0,
    );
  }

  // Convert seconds to Duration for easier formatting
  Duration get totalDuration => Duration(seconds: totalHours);
  Duration get activeDuration => Duration(seconds: activeHours);
  Duration get idleDuration => Duration(seconds: idleHours);
}

class WeeklyStatsModel {
  final String weekStart;
  final String weekEnd;
  final int totalHours; // in seconds
  final int activeHours; // in seconds
  final int idleHours; // in seconds
  final int activePercentage;
  final int averageSessionsPerDay;

  WeeklyStatsModel({
    required this.weekStart,
    required this.weekEnd,
    required this.totalHours,
    required this.activeHours,
    required this.idleHours,
    required this.activePercentage,
    required this.averageSessionsPerDay,
  });

  factory WeeklyStatsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyStatsModel(
      weekStart: json['weekStart'] ?? '',
      weekEnd: json['weekEnd'] ?? '',
      totalHours: json['totalHours'] ?? 0,
      activeHours: json['activeHours'] ?? 0,
      idleHours: json['idleHours'] ?? 0,
      activePercentage: json['activePercentage'] ?? 0,
      averageSessionsPerDay: json['averageSessionsPerDay'] ?? 0,
    );
  }

  // Convert seconds to Duration for easier formatting
  Duration get totalDuration => Duration(seconds: totalHours);
  Duration get activeDuration => Duration(seconds: activeHours);
  Duration get idleDuration => Duration(seconds: idleHours);

  // Parse dates
  DateTime get weekStartDate => DateTime.parse(weekStart);
  DateTime get weekEndDate => DateTime.parse(weekEnd);
}
