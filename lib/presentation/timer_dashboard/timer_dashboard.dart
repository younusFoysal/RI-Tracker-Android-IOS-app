import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../services/stats_service.dart';
import './widgets/progress_card_widget.dart';
import './widgets/project_selector_widget.dart';
import './widgets/sync_status_widget.dart';
import './widgets/timer_control_widget.dart';
import './widgets/timer_display_widget.dart';

class TimerDashboard extends StatefulWidget {
  const TimerDashboard({Key? key}) : super(key: key);

  @override
  State<TimerDashboard> createState() => _TimerDashboardState();
}

class _TimerDashboardState extends State<TimerDashboard>
    with TickerProviderStateMixin {
  // Services
  final AuthService _authService = AuthService();
  final SessionService _sessionService = SessionService();
  final StatsService _statsService = StatsService();

  // Timer state
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isActive = false;
  bool _isPaused = false;
  DateTime? _startTime;

  // Project and sync state
  String _selectedProject = 'RemoteIntegrity';
  DateTime _lastSyncTime = DateTime.now().subtract(const Duration(minutes: 5));
  bool _isSyncing = false;
  bool _isLoading = true;

  // Animation controllers for modern UI
  late AnimationController _headerAnimationController;
  late AnimationController _cardsAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _cardsSlideAnimation;

  // Stats data
  Duration _todayWorkedTime = Duration.zero;
  double _todayProductivity = 0.0;
  Duration _weeklyWorkedTime = Duration.zero;
  double _weeklyProductivity = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _cardsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _cardsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardsAnimationController.forward();
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize auth service
      final isAuthenticated = await _authService.initialize();

      if (!isAuthenticated) {
        // Navigate to login screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        return;
      }

      // Verify profile and get fresh data
      final profileResult = await _authService.getProfile();
      if (!profileResult['success']) {
        if (profileResult['shouldLogout'] == true) {
          // Navigate to login screen
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
          return;
        }
      }

      // Load stats data
      await _loadStatsData();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing app: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  Future<void> _loadStatsData() async {
    try {
      // Load daily stats
      final dailyResult = await _statsService.getDailyStats();
      if (dailyResult['success']) {
        final dailyStats = dailyResult['data'];
        _todayWorkedTime = dailyStats.totalDuration;
        _todayProductivity = dailyStats.activePercentage.toDouble();
      }

      // Load weekly stats
      final weeklyResult = await _statsService.getWeeklyStats();
      if (weeklyResult['success']) {
        final weeklyStats = weeklyResult['data'];
        _weeklyWorkedTime = weeklyStats.totalDuration;
        _weeklyProductivity = weeklyStats.activePercentage.toDouble();
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _headerAnimationController.dispose();
    _cardsAnimationController.dispose();
    super.dispose();
  }

  Future<void> _startTimer() async {
    if (_isActive) return;

    setState(() {
      _isActive = true;
      _isPaused = false;
      _startTime = DateTime.now();
    });

    // Create session
    final sessionResult = await _sessionService.createSession();
    if (!sessionResult['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to create session: ${sessionResult['message']}'),
          backgroundColor: AppTheme.alertRed,
        ),
      );
      setState(() {
        _isActive = false;
        _isPaused = false;
      });
      return;
    }

    // Start UI timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedTime = Duration(seconds: _elapsedTime.inSeconds + 1);
        });

        // Update session service with current time
        _sessionService.updateActiveTime(_elapsedTime.inSeconds);
      }
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.play_arrow, color: AppTheme.surfaceWhite),
            SizedBox(width: 3.w),
            Text('Timer started and session created!'),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  Future<void> _stopTimer() async {
    if (!_isActive) return;

    _timer?.cancel();

    // End session
    final sessionResult = await _sessionService.endSession();
    if (!sessionResult['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to end session: ${sessionResult['message']}'),
          backgroundColor: AppTheme.alertRed,
        ),
      );
    }

    setState(() {
      _isActive = false;
      _isPaused = false;
      _elapsedTime = Duration.zero;
      _startTime = null;
    });

    HapticFeedback.mediumImpact();

    // Reload stats after session completion
    await _loadStatsData();

    // Show completion feedback with modern styling
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: AppTheme.surfaceWhite),
            SizedBox(width: 3.w),
            Text('Session completed and saved!'),
          ],
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(4.w),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _pauseTimer() {
    if (!_isActive || _isPaused) return;

    setState(() {
      _isPaused = true;
    });

    HapticFeedback.lightImpact();
  }

  void _resumeTimer() {
    if (!_isActive || !_isPaused) return;

    setState(() {
      _isPaused = false;
    });

    HapticFeedback.lightImpact();
  }

  void _onProjectChanged(String newProject) {
    setState(() {
      _selectedProject = newProject;
    });
  }

  void _syncData() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      // Reload stats data
      await _loadStatsData();

      setState(() {
        _isSyncing = false;
        _lastSyncTime = DateTime.now();
      });

      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.cloud_done_outlined, color: AppTheme.surfaceWhite),
              SizedBox(width: 3.w),
              Text('Data synchronized successfully'),
            ],
          ),
          backgroundColor: AppTheme.primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(4.w),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _isSyncing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: AppTheme.surfaceWhite),
              SizedBox(width: 3.w),
              Text('Failed to sync data'),
            ],
          ),
          backgroundColor: AppTheme.alertRed,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(4.w),
        ),
      );
    }
  }

  void _addNote() {
    Navigator.pushNamed(context, AppRoutes.sessionNotes);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isSyncing = true;
    });

    await _loadStatsData();

    setState(() {
      _isSyncing = false;
      _lastSyncTime = DateTime.now();
    });

    HapticFeedback.lightImpact();
  }

  void _showSettingsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 2.h),
                width: 12.w,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: 2.h),

              ListTile(
                leading: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
                title: Text(
                  'Settings',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),

              Divider(
                color: AppTheme.borderSubtle,
                thickness: 1,
                indent: 4.w,
                endIndent: 4.w,
              ),

              ListTile(
                leading: CustomIconWidget(
                  iconName: 'logout',
                  color: AppTheme.alertRed,
                  size: 24,
                ),
                title: Text(
                  'Logout',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.alertRed,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    // Stop timer if active
                    if (_isActive) {
                      await _stopTimer();
                    }

                    // Clear session data
                    _sessionService.clearSession();

                    // Logout
                    await _authService.logout();

                    // Navigate to login
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  }
                },
              ),

              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                AppTheme.primaryBlue,
                AppTheme.primaryBlueDark.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Add current session time to today's total
    Duration todayTotalTime = _todayWorkedTime;
    if (_isActive) {
      todayTotalTime = _todayWorkedTime + _elapsedTime;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppTheme.primaryBlue,
              AppTheme.primaryBlueDark.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern header with three dots menu
              FadeTransition(
                opacity: _headerFadeAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RI Tracker',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: AppTheme.surfaceWhite,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Welcome, ${_authService.currentUser?.name ?? "User"}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.surfaceWhite.withValues(
                                alpha: 0.8,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _showSettingsMenu,
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceWhite.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.surfaceWhite.withValues(
                                alpha: 0.3,
                              ),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'more_vert',
                            color: AppTheme.surfaceWhite,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main content area with modern glass morphism
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppTheme.primaryBlue,
                    strokeWidth: 3,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      child: SlideTransition(
                        position: _cardsSlideAnimation,
                        child: FadeTransition(
                          opacity: _headerFadeAnimation,
                          child: Column(
                            children: [
                              SizedBox(height: 3.h),

                              // Project Selector
                              ProjectSelectorWidget(
                                selectedProject: _selectedProject,
                                onProjectChanged: _onProjectChanged,
                              ),

                              // Timer Display
                              TimerDisplayWidget(
                                elapsedTime: _elapsedTime,
                                isActive: _isActive,
                              ),

                              // Timer Control
                              TimerControlWidget(
                                isActive: _isActive,
                                isPaused: _isPaused,
                                onStartStop:
                                    _isActive ? _stopTimer : _startTimer,
                                onPause: _pauseTimer,
                                onResume: _resumeTimer,
                              ),

                              SizedBox(height: 3.h),

                              // Progress cards with real data
                              ProgressCardWidget(
                                title: "Today's Progress",
                                workedTime: todayTotalTime,
                                productivityPercentage: _todayProductivity,
                              ),

                              ProgressCardWidget(
                                title: "Weekly Summary",
                                workedTime: _weeklyWorkedTime,
                                productivityPercentage: _weeklyProductivity,
                                isWeekly: true,
                              ),

                              // Sync Status
                              SyncStatusWidget(
                                lastSyncTime: _lastSyncTime,
                                isSyncing: _isSyncing,
                                onSyncPressed: _syncData,
                              ),

                              SizedBox(height: 6.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _addNote,
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: AppTheme.surfaceWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: CustomIconWidget(
            iconName: 'note_add',
            color: AppTheme.surfaceWhite,
            size: 20,
          ),
          label: Text(
            'Add Note',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.surfaceWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}