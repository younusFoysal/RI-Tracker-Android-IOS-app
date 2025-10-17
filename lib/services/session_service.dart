import 'dart:async';

import 'package:dio/dio.dart';

import './auth_service.dart';
import './config_service.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final AuthService _authService = AuthService();
  String? _currentSessionId;
  Timer? _updateTimer;
  DateTime? _sessionStartTime;
  int _activeTimeSeconds = 0;
  int _idleTimeSeconds = 0;

  // Getters
  String? get currentSessionId => _currentSessionId;
  bool get hasActiveSession => _currentSessionId != null;
  int get activeTimeSeconds => _activeTimeSeconds;
  int get idleTimeSeconds => _idleTimeSeconds;

  /// Create a new session when timer starts
  Future<Map<String, dynamic>> createSession({
    String userNote = "",
  }) async {
    if (!_authService.isAuthenticated) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    try {
      // Get current time in UTC
      final localTime = DateTime.now();
      final utcTime = localTime.toUtc();
      final startTime = utcTime.toIso8601String().replaceAll('+00:00', 'Z');

      final sessionData = {
        'employeeId': _authService.currentUser!.employeeId,
        'companyId': _authService
            .currentUser!.employeeId, // Using employeeId as companyId for now
        'startTime': startTime,
        'notes': userNote,
        'userNote': "Session from Android/IOS app." + userNote,
      };

      final response = await _authService.dio.post(
        AppConfig.urls['SESSIONS']!,
        data: sessionData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_authService.authToken}',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data['success'] == true) {
        _currentSessionId = data['data']['id'] ?? data['data']['_id'];
        _sessionStartTime = DateTime.now();
        _activeTimeSeconds = 0;
        _idleTimeSeconds = 0;

        // Start periodic updates every 10 minutes
        _startPeriodicUpdates();

        return {
          'success': true,
          'sessionId': _currentSessionId,
          'message': 'Session created successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create session',
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

  /// Update session with current active/idle time
  Future<Map<String, dynamic>> updateSession({
    String userNote = "",
    bool isFinalUpdate = false,
  }) async {
    if (!hasActiveSession || !_authService.isAuthenticated) {
      return {
        'success': false,
        'message': 'No active session or not authenticated',
      };
    }

    try {
      final updateData = {
        'activeTime': _activeTimeSeconds,
        'idleTime': _idleTimeSeconds,
        'notes': userNote,
        'userNote': "Session from Android/IOS app." + userNote,
      };

      // Add endTime for final update (when stopping timer)
      if (isFinalUpdate) {
        final localTime = DateTime.now();
        final utcTime = localTime.toUtc();
        final endTime = utcTime.toIso8601String().replaceAll('+00:00', 'Z');
        updateData['endTime'] = endTime;
      }

      final response = await _authService.dio.patch(
        '${AppConfig.urls['SESSIONS']!}/$_currentSessionId',
        data: updateData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${_authService.authToken}',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data['success'] == true) {
        // If this was final update, clear session data
        if (isFinalUpdate) {
          _clearSession();
        }

        return {
          'success': true,
          'message': 'Session updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update session',
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

  /// Start periodic updates every 10 minutes
  void _startPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      updateSession();
    });
  }

  /// Stop periodic updates
  void _stopPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  /// Update active time (call this every second when timer is running)
  void updateActiveTime(int seconds) {
    _activeTimeSeconds = seconds;
  }

  /// Update idle time (if implementing idle detection)
  void updateIdleTime(int seconds) {
    _idleTimeSeconds = seconds;
  }

  /// End current session
  Future<Map<String, dynamic>> endSession({String userNote = ""}) async {
    final result = await updateSession(
      userNote: userNote,
      isFinalUpdate: true,
    );

    _stopPeriodicUpdates();
    return result;
  }

  /// Clear session data
  void _clearSession() {
    _currentSessionId = null;
    _sessionStartTime = null;
    _activeTimeSeconds = 0;
    _idleTimeSeconds = 0;
    _stopPeriodicUpdates();
  }

  /// Force clear session (for logout or app restart)
  void clearSession() {
    _clearSession();
  }
}
