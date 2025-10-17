import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressCardWidget extends StatefulWidget {
  final String title;
  final Duration workedTime;
  final double productivityPercentage;
  final bool isWeekly;

  const ProgressCardWidget({
    Key? key,
    required this.title,
    required this.workedTime,
    required this.productivityPercentage,
    this.isWeekly = false,
  }) : super(key: key);

  @override
  State<ProgressCardWidget> createState() => _ProgressCardWidgetState();
}

class _ProgressCardWidgetState extends State<ProgressCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.productivityPercentage / 100,
    ).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animations with delay
    Future.delayed(Duration(milliseconds: widget.isWeekly ? 300 : 100), () {
      if (mounted) {
        _cardAnimationController.forward();
        _progressAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Color _getProductivityColor() {
    if (widget.productivityPercentage >= 80) {
      return AppTheme.successGreen;
    } else if (widget.productivityPercentage >= 60) {
      return AppTheme.primaryBlue;
    } else {
      return AppTheme.alertRed;
    }
  }

  IconData _getProductivityIcon() {
    if (widget.productivityPercentage >= 80) {
      return Icons.trending_up_rounded;
    } else if (widget.productivityPercentage >= 60) {
      return Icons.trending_flat_rounded;
    } else {
      return Icons.trending_down_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.surface,
                  AppTheme.lightTheme.colorScheme.surface.withValues(
                    alpha: 0.8,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getProductivityColor().withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getProductivityColor().withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: AppTheme.shadowLight.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with modern styling
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTheme.lightTheme.textTheme.titleLarge
                            ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _getProductivityColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getProductivityIcon(),
                        color: _getProductivityColor(),
                        size: 20,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Main content with modern layout
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time section
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hours Worked',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  _formatDuration(widget.workedTime),
                                  style: AppTheme
                                      .lightTheme
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24.sp,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 2.h),

                          // Productivity section
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getProductivityColor().withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Productivity Score',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.3,
                                      ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    Text(
                                      '${widget.productivityPercentage.toInt()}%',
                                      style: AppTheme
                                          .lightTheme
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: _getProductivityColor(),
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20.sp,
                                          ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Icon(
                                      _getProductivityIcon(),
                                      color: _getProductivityColor(),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Circular progress indicator
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background circle
                                Container(
                                  width: 20.w,
                                  height: 20.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getProductivityColor().withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                                // Progress indicator
                                CircularPercentIndicator(
                                  radius: 10.w,
                                  lineWidth: 6.0,
                                  percent: _progressAnimation.value,
                                  center: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${(widget.productivityPercentage * _progressAnimation.value).toInt()}%',
                                        style: AppTheme
                                            .lightTheme
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: AppTheme.textPrimary,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16.sp,
                                            ),
                                      ),
                                      Text(
                                        'Score',
                                        style: AppTheme
                                            .lightTheme
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.textSecondary,
                                              fontSize: 10.sp,
                                            ),
                                      ),
                                    ],
                                  ),
                                  progressColor: _getProductivityColor(),
                                  backgroundColor: AppTheme.progressTrack,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  animation: true,
                                  animationDuration: 1200,
                                  curve: Curves.easeOutBack,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Additional insights bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insights_rounded,
                        color: AppTheme.textSecondary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        widget.isWeekly
                            ? 'Weekly average performance'
                            : 'Current day performance',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
