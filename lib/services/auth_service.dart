import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import './config_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _setupDioInterceptors();
  }

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  String? _authToken;
  UserModel? _currentUser;

  // Getters
  String? get authToken => _authToken;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _authToken != null && _currentUser != null;

  /// Initialize the auth service and check for saved credentials
  Future<bool> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userJson = prefs.getString('user_data');

      if (token != null && userJson != null) {
        _authToken = token;
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
        _setupDioInterceptors();

        // Verify token is still valid by getting profile
        final isValid = await _verifyToken();
        if (!isValid) {
          await logout();
          return false;
        }

        return true;
      }

      return false;
    } catch (e) {
      print('Error initializing auth service: $e');
      await logout();
      return false;
    }
  }

  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final loginUrl = AppConfig.urls['LOGIN'];
      if (loginUrl == null || loginUrl.isEmpty) {
        return {
          'success': false,
          'message': 'Login URL is not configured',
        };
      }

      // Debug log (password masked)
      try {
        print('[AuthService] Initiating login → URL: ' + loginUrl + ' | email: ' + email);
      } catch (_) {}

      final response = await _dio.post(
        loginUrl,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      dynamic raw = response.data;
      // Ensure we have a Map<String, dynamic>
      Map<String, dynamic> data;
      if (raw is String) {
        try {
          data = jsonDecode(raw) as Map<String, dynamic>;
        } catch (_) {
          print('[AuthService] Login response was not valid JSON string.');
          return {
            'success': false,
            'message': 'Invalid server response',
          };
        }
      } else if (raw is Map<String, dynamic>) {
        data = raw;
      } else {
        print('[AuthService] Login response had unexpected type: ' + raw.runtimeType.toString());
        return {
          'success': false,
          'message': 'Invalid server response',
        };
      }

      // Normalize structure
      final bool success = (data['success'] == true) || (data['status'] == true);
      final Map<String, dynamic> payload =
          (data['data'] is Map<String, dynamic>) ? data['data'] as Map<String, dynamic> : data;

      // Extract token from common keys
      final String? token = (payload['token'] ?? payload['accessToken'] ?? payload['jwt'] ?? payload['authToken']) as String?;

      // Extract user object from common keys
      final dynamic userObj = payload['employee'] ?? payload['user'] ?? payload['profile'] ?? payload['data'];

      if (success && userObj is Map<String, dynamic>) {
        _authToken = token; // can be null if API doesn't send; we still proceed
        _currentUser = UserModel.fromJson(userObj);

        _setupDioInterceptors();

        // Always save credentials to maintain session, regardless of rememberMe
        if (_authToken != null && _currentUser != null) {
          await _saveAuthData();
          print('[AuthService] Login successful, auth data saved. Token: ${_authToken?.substring(0, 20)}... User: ${_currentUser?.name}');
        } else {
          print('[AuthService] Warning: Login succeeded but token or user is null. Token: ${_authToken != null}, User: ${_currentUser != null}');
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'user': _currentUser,
        };
      }

      // If server explicitly indicates failure, return its message
      return {
        'success': false,
        'message': data['message'] ?? payload['message'] ?? 'Login failed',
      };
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      // Map common connectivity issues to a clearer message
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Unable to reach server. Please check your internet connection.';
      } else if (e.error is SocketException) {
        errorMessage = 'Unable to reach server. Please check your internet connection.';
      }

      final respData = e.response?.data;
      if (respData is Map<String, dynamic>) {
        errorMessage = respData['message'] ?? errorMessage;
      } else if (respData is String) {
        // Try parse string JSON error
        try {
          final parsed = jsonDecode(respData);
          if (parsed is Map<String, dynamic>) {
            errorMessage = parsed['message'] ?? errorMessage;
          }
        } catch (_) {}
      }

      try {
        print('[AuthService] Login failed (DioException): type=' + e.type.toString() + ' code=' + (e.response?.statusCode?.toString() ?? '-') + ' message=' + (e.message ?? ''));
      } catch (_) {}

      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred during login',
      };
    }
  }

  /// Get user profile and verify token
  Future<bool> _verifyToken() async {
    if (_authToken == null || _currentUser == null) return false;

    try {
      final response = await _dio.get(
        '${AppConfig.urls['PROFILE']!}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data['success'] == true;
    } catch (e) {
      print('Token verification failed: $e');
      return false;
    }
  }

  /// Get fresh user profile data
  Future<Map<String, dynamic>> getProfile() async {
    if (!isAuthenticated) {
      return {
        'success': false,
        'message': 'Not authenticated',
      };
    }

    try {
      final response = await _dio.get(
        '${AppConfig.urls['PROFILE']!}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_authToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data['success'] == true) {
        // Update current user with fresh data
        _currentUser = UserModel.fromJson(data['data']['employee']);
        await _saveAuthData(); // Save updated user data

        return {
          'success': true,
          'data': _currentUser,
        };
      } else {
        // If profile fetch fails, logout user
        await logout();
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
          'shouldLogout': true,
        };
      }
    } on DioException catch (e) {
      // If unauthorized, logout user
      if (e.response?.statusCode == 401) {
        await logout();
        return {
          'success': false,
          'message': 'Session expired',
          'shouldLogout': true,
        };
      }

      return {
        'success': false,
        'message': 'Failed to fetch profile',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while fetching profile',
      };
    }
  }

  /// Logout user and clear stored data
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      _authToken = null;
      _currentUser = null;

      // Clear dio interceptors
      _dio.interceptors.clear();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  /// Save authentication data to SharedPreferences
  Future<void> _saveAuthData() async {
    if (_authToken != null && _currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _authToken!);
      await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
    }
  }

  /// Setup Dio interceptors for automatic token injection and error handling
  void _setupDioInterceptors() {
    _dio.interceptors.clear();

    // Lightweight logging to observe request attempts and outcomes
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
        logPrint: (obj) {
          try {
            // Keep logs concise
            print('[DIO] ' + obj.toString());
          } catch (_) {}
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle token expiry
          if (error.response?.statusCode == 401) {
            logout();
          }
          handler.next(error);
        },
      ),
    );
  }

  /// Get dio instance for other services
  Dio get dio => _dio;

  /// TEMPORARY: Load mock data for bypass (TODO: Remove when API is fixed)
  // Future<void> loadMockData({
  //   required String token,
  //   required Map<String, dynamic> userData,
  // }) async {
  //   try {
  //     _authToken = token;
  //     _currentUser = UserModel.fromJson(userData);
  //     _setupDioInterceptors();
  //
  //     // Save the mock data to SharedPreferences
  //     await _saveAuthData();
  //
  //     print('Mock data loaded: ${_currentUser?.name} (${_currentUser?.email})');
  //   } catch (e) {
  //     print('Error loading mock data: $e');
  //   }
  // }
}
