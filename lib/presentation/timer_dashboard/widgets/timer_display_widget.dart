import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimerDisplayWidget extends StatelessWidget {
  final Duration elapsedTime;
  final bool isActive;

  const TimerDisplayWidget({
    Key? key,
    required this.elapsedTime,
    required this.isActive,
  }) : super(key: key);

  List<String> _getTimeParts(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return [
      twoDigits(duration.inHours),
      twoDigits(duration.inMinutes.remainder(60)),
      twoDigits(duration.inSeconds.remainder(60)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final timeParts = _getTimeParts(elapsedTime);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppTheme.primaryBlue.withValues(alpha: 0.3)
              : AppTheme.borderSubtle,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Simple status indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.successGreen.withValues(alpha: 0.1)
                  : AppTheme.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isActive ? AppTheme.successGreen : AppTheme.textSecondary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.successGreen
                        : AppTheme.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  isActive ? 'RECORDING' : 'READY',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isActive
                        ? AppTheme.successGreen
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Clean timer display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.borderSubtle,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hours
                _buildTimeUnit(timeParts[0], 'HH'),
                Text(
                  ':',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 32.sp,
                  ),
                ),
                // Minutes
                _buildTimeUnit(timeParts[1], 'MM'),
                Text(
                  ':',
                  style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 32.sp,
                  ),
                ),
                // Seconds
                _buildTimeUnit(timeParts[2], 'SS'),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Simple progress indicator
          if (isActive)
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.progressTrack,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40.w, // Fixed width for simplicity
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 32.sp,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
