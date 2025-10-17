import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SyncStatusWidget extends StatelessWidget {
  final DateTime lastSyncTime;
  final bool isSyncing;
  final VoidCallback onSyncPressed;

  const SyncStatusWidget({
    Key? key,
    required this.lastSyncTime,
    required this.isSyncing,
    required this.onSyncPressed,
  }) : super(key: key);

  String _formatSyncTime(DateTime syncTime) {
    final now = DateTime.now();
    final difference = now.difference(syncTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Sync',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatSyncTime(lastSyncTime),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: isSyncing ? null : onSyncPressed,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSyncing
                    ? AppTheme.progressTrack
                    : AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: isSyncing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryBlue,
                        ),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'sync',
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
