import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class CharacterCounter extends StatelessWidget {
  final int currentLength;
  final int maxLength;

  const CharacterCounter({
    super.key,
    required this.currentLength,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final isNearLimit = currentLength > (maxLength * 0.8);
    final isAtLimit = currentLength >= maxLength;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isAtLimit
            ? AppTheme.alertRed.withValues(alpha: 0.1)
            : isNearLimit
                ? Colors.orange.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAtLimit
              ? AppTheme.alertRed
              : isNearLimit
                  ? Colors.orange
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isAtLimit ? 'warning' : 'edit',
            color: isAtLimit
                ? AppTheme.alertRed
                : isNearLimit
                    ? Colors.orange
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            '$currentLength / $maxLength',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isAtLimit
                  ? AppTheme.alertRed
                  : isNearLimit
                      ? Colors.orange
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: isAtLimit ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
