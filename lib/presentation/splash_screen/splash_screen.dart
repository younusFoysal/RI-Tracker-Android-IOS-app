import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Show splash for minimum 3 seconds
      await Future.delayed(const Duration(seconds: 3));

      // TEMPORARY BYPASS: Load mock user data and navigate directly to timer dashboard
      // TODO: Remove this bypass when login API is fixed
      // await _loadMockUserData();
      //
      // if (mounted) {
      //   // Navigate directly to timer dashboard with mock data
      //   Navigator.pushReplacementNamed(context, AppRoutes.timerDashboard);
      // }

      // ORIGINAL CODE (COMMENTED OUT FOR BYPASS):
      // /*
      // Initialize auth service and check for saved credentials
      final isAuthenticated = await _authService.initialize();

      if (mounted) {
        if (isAuthenticated) {
          // User is already logged in, verify profile
          final profileResult = await _authService.getProfile();
          if (profileResult['success']) {
            // Navigate to timer dashboard
            Navigator.pushReplacementNamed(context, AppRoutes.timerDashboard);
          } else {
            // Profile fetch failed, show login
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        } else {
          // No saved credentials, show login
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      }
      // */
    } catch (e) {
      print('Error during app initialization: $e');
      if (mounted) {
        // On error, still navigate to timer dashboard with mock data
        //await _loadMockUserData();
        Navigator.pushReplacementNamed(context, AppRoutes.timerDashboard);
      }
    }
  }

  /// TEMPORARY: Load mock user data for bypass
  // Future<void> _loadMockUserData() async {
  //   try {
  //     // Mock login response data provided by user
  //     final mockLoginData = {
  //       "success": true,
  //       "message": "Employee is logged in successfully!",
  //       "data": {
  //         "employee": {
  //           "_id": "68b7e64316c4500fa5fdf8a3",
  //           "username": "johncena",
  //           "name": "John Cena",
  //           "email": "nhnahid.iu@gmail.com",
  //           "password":
  //               "\$2b\$10\$vthw1Ra9h8tcNjpBY2RtgetITc8B.djFN006HRINpzuUzWbhrhnlm",
  //           "avatar": "https://i.ibb.co/ZzLC3NQR/man-Avater.jpg",
  //           "roleId": null,
  //           "employeeId": "68b7e51c4a430ecc9423a725",
  //           "position": "",
  //           "division": "",
  //           "role": "user",
  //           "status": "active",
  //           "note": "New User",
  //           "isDeleted": false,
  //           "isBlocked": false,
  //           "needsPasswordChange": false,
  //           "isEmailVerified": false,
  //           "createdAt": "2025-09-03T06:54:59.310Z",
  //           "updatedAt": "2025-09-03T06:54:59.310Z",
  //           "__v": 0
  //         },
  //         "token":
  //             "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OGI3ZTY0MzE2YzQ1MDBmYTVmZGY4YTMiLCJ1c2VybmFtZSI6ImpvaG5jZW5hIiwibmFtZSI6IkpvaG4gQ2VuYSIsImVtYWlsIjoibmhuYWhpZC5pdUBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsImF2YXRhciI6Imh0dHBzOi8vaS5pYmIuY28vWnpMQzNOUVIvbWFuLUF2YXRlci5qcGciLCJwb3NpdGlvbiI6IiIsInJvbGVJZCI6bnVsbCwic3RhdHVzIjoiYWN0aXZlIiwiaXNEZWxldGVkIjpmYWxzZSwiaXNCbG9ja2VkIjpmYWxzZSwibmVlZHNQYXNzd29yZENoYW5nZSI6ZmFsc2UsImlzRW1haWxWZXJpZmllZCI6ZmFsc2UsImlhdCI6MTc2MDQyOTAwNywiZXhwIjoxNzYxMjkzMDA3fQ.NuY-4Tgfnu_cfcofI0SxUx_st0fXOrAYkwaFDDqsO-U"
  //       }
  //     };
  //
  //     // Load mock data into AuthService manually
  //     await _authService.loadMockData(
  //       token: (mockLoginData['data'] as Map<String, dynamic>)['token'] as String,
  //       userData: (mockLoginData['data'] as Map<String, dynamic>)['employee'] as Map<String, dynamic>,
  //     );
  //
  //     print('Mock user data loaded successfully for bypass');
  //   } catch (e) {
  //     print('Error loading mock user data: $e');
  //   }
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBlue,
              AppTheme.primaryBlueDark.withValues(alpha: 0.9),
              AppTheme.backgroundLight,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo with animations
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 35.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 35.w,
                            height: 35.w,
                            fit: BoxFit.cover,
                            semanticLabel:
                                'RemoteIntegrity Time Tracking',
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.timer_outlined,
                                  size: 18.w,
                                  color: AppTheme.surfaceWhite,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // App title with fade animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'RI Tracker',
                          style: AppTheme.lightTheme.textTheme.headlineLarge
                              ?.copyWith(
                            color: AppTheme.surfaceWhite,
                            fontWeight: FontWeight.w900,
                            fontSize: 32.sp,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'RemoteIntegrity Time Tracking',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.surfaceWhite.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 8.w,
                          height: 8.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.surfaceWhite.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          'Loading your workspace...',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.surfaceWhite.withValues(alpha: 0.7),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Footer
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Text(
                        'RemoteIntegrity © 2025',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.surfaceWhite.withValues(alpha: 0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}