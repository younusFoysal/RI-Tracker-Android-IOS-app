import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserProfileHeaderWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlueDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.surfaceWhite,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.surfaceWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.surfaceWhite,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: (userData['avatar'] as String?) ??
                            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                        width: 16.w,
                        height: 16.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (userData['name'] as String?) ?? 'John Doe',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.surfaceWhite,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          (userData['email'] as String?) ??
                              'john.doe@remoteintegrity.com',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.surfaceWhite.withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(userData['productivityStreak'] as int?) ?? 7} day streak',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.surfaceWhite,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
