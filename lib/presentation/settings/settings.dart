import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/stepper_setting_widget.dart';
import './widgets/switch_setting_widget.dart';
import './widgets/time_picker_widget.dart';
import './widgets/user_profile_header_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  final AuthService _authService = AuthService();

  // Get real user data from AuthService
  Map<String, dynamic> get userData {
    final user = _authService.currentUser;
    if (user == null) {
      return {
        "id": "",
        "name": "Guest User",
        "email": "guest@remoteintegrity.com",
        "avatar": "",
        "productivityStreak": 0,
        "joinDate": "",
        "totalHours": 0.0,
        "currentProject": "RemoteIntegrity"
      };
    }
    return {
      "id": user.id,
      "name": user.name,
      "email": user.email,
      "avatar": user.avatar,
      "productivityStreak": 0, // TODO: Calculate from stats service
      "joinDate": user.createdAt,
      "totalHours": 0.0, // TODO: Calculate from stats service
      "currentProject": "RemoteIntegrity" // TODO: Get from current session
    };
  }

  // Settings state
  bool _autoStartTimer = true;
  bool _breakReminders = true;
  bool _sessionAlerts = true;
  bool _dailySummaries = false;
  bool _productivityGoals = true;
  bool _offlineMode = false;
  TimeOfDay _breakReminderTime = const TimeOfDay(hour: 10, minute: 30);
  TimeOfDay _dailyReminderTime = const TimeOfDay(hour: 9, minute: 0);
  int _breakInterval = 25;
  int _syncFrequency = 15;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.textPrimary,
      textColor: AppTheme.surfaceWhite,
      fontSize: 14,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Logout',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to logout? Any unsaved data will be lost.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showToast('Logged out successfully');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/splash-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.alertRed,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showPasswordChangeDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Change Password',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: currentPasswordController,
                      obscureText: obscureCurrentPassword,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        suffixIcon: IconButton(
                          icon: CustomIconWidget(
                            iconName: obscureCurrentPassword
                                ? 'visibility'
                                : 'visibility_off',
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureCurrentPassword = !obscureCurrentPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: newPasswordController,
                      obscureText: obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: CustomIconWidget(
                            iconName: obscureNewPassword
                                ? 'visibility'
                                : 'visibility_off',
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureNewPassword = !obscureNewPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        suffixIcon: IconButton(
                          icon: CustomIconWidget(
                            iconName: obscureConfirmPassword
                                ? 'visibility'
                                : 'visibility_off',
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    currentPasswordController.dispose();
                    newPasswordController.dispose();
                    confirmPasswordController.dispose();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentPasswordController.text.isEmpty ||
                        newPasswordController.text.isEmpty ||
                        confirmPasswordController.text.isEmpty) {
                      _showToast('Please fill all fields');
                      return;
                    }

                    if (currentPasswordController.text != 'password123') {
                      _showToast('Current password is incorrect');
                      return;
                    }

                    if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      _showToast('New passwords do not match');
                      return;
                    }

                    if (newPasswordController.text.length < 6) {
                      _showToast('Password must be at least 6 characters');
                      return;
                    }

                    currentPasswordController.dispose();
                    newPasswordController.dispose();
                    confirmPasswordController.dispose();
                    Navigator.of(context).pop();
                    _showToast('Password changed successfully');
                  },
                  child: const Text('Change Password'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
        DateTime endDate = DateTime.now();
        String exportFormat = 'CSV';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                'Export Data',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Format',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('CSV'),
                          value: 'CSV',
                          groupValue: exportFormat,
                          onChanged: (value) {
                            setState(() {
                              exportFormat = value!;
                            });
                          },
                          activeColor: AppTheme.primaryBlue,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('PDF'),
                          value: 'PDF',
                          groupValue: exportFormat,
                          onChanged: (value) {
                            setState(() {
                              exportFormat = value!;
                            });
                          },
                          activeColor: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Date Range',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme:
                                        Theme.of(context).colorScheme.copyWith(
                                              primary: AppTheme.primaryBlue,
                                            ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                startDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 3.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderSubtle),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${startDate.day}/${startDate.month}/${startDate.year}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Text('to'),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate: startDate,
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme:
                                        Theme.of(context).colorScheme.copyWith(
                                              primary: AppTheme.primaryBlue,
                                            ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                endDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 3.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderSubtle),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${endDate.day}/${endDate.month}/${endDate.year}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showToast('Exporting data as $exportFormat...');
                  },
                  child: const Text('Export'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _buildFilteredSettings() {
    final List<Widget> allSettings = [
      // Timer Preferences Section
      SettingsSectionWidget(
        title: 'Timer Preferences',
        children: [
          SettingsItemWidget(
            title: 'Default Project',
            subtitle: 'RemoteIntegrity',
            leading: CustomIconWidget(
              iconName: 'work',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onTap: () => _showToast('Project selection coming soon'),
          ),
          SwitchSettingWidget(
            title: 'Auto-start Timer',
            subtitle: 'Automatically start timer when opening app',
            initialValue: _autoStartTimer,
            leading: CustomIconWidget(
              iconName: 'play_circle',
              color: AppTheme.successGreen,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _autoStartTimer = value;
              });
              _showToast('Auto-start ${value ? 'enabled' : 'disabled'}');
            },
          ),
          SwitchSettingWidget(
            title: 'Break Reminders',
            subtitle: 'Get notified when it\'s time for a break',
            initialValue: _breakReminders,
            leading: CustomIconWidget(
              iconName: 'coffee',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _breakReminders = value;
              });
              _showToast('Break reminders ${value ? 'enabled' : 'disabled'}');
            },
          ),
          StepperSettingWidget(
            title: 'Break Interval',
            subtitle: 'Minutes between break reminders',
            initialValue: _breakInterval,
            minValue: 15,
            maxValue: 120,
            step: 5,
            unit: ' min',
            leading: CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _breakInterval = value;
              });
              _showToast('Break interval set to $value minutes');
            },
          ),
          const SizedBox(height: 1),
        ],
      ),

      // Notifications Section
      SettingsSectionWidget(
        title: 'Notifications',
        children: [
          SwitchSettingWidget(
            title: 'Session Alerts',
            subtitle: 'Notifications for timer start/stop events',
            initialValue: _sessionAlerts,
            leading: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _sessionAlerts = value;
              });
              _showToast('Session alerts ${value ? 'enabled' : 'disabled'}');
            },
          ),
          SwitchSettingWidget(
            title: 'Daily Summaries',
            subtitle: 'End-of-day productivity reports',
            initialValue: _dailySummaries,
            leading: CustomIconWidget(
              iconName: 'summarize',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _dailySummaries = value;
              });
              _showToast('Daily summaries ${value ? 'enabled' : 'disabled'}');
            },
          ),
          SwitchSettingWidget(
            title: 'Productivity Goals',
            subtitle: 'Notifications for goal achievements',
            initialValue: _productivityGoals,
            leading: CustomIconWidget(
              iconName: 'emoji_events',
              color: AppTheme.successGreen,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _productivityGoals = value;
              });
              _showToast(
                  'Productivity goals ${value ? 'enabled' : 'disabled'}');
            },
          ),
          TimePickerWidget(
            title: 'Daily Reminder Time',
            initialTime: _dailyReminderTime,
            onTimeChanged: (time) {
              setState(() {
                _dailyReminderTime = time;
              });
              _showToast('Daily reminder time updated');
            },
          ),
          const SizedBox(height: 1),
        ],
      ),

      // Data & Sync Section
      SettingsSectionWidget(
        title: 'Data & Sync',
        children: [
          StepperSettingWidget(
            title: 'Sync Frequency',
            subtitle: 'Minutes between automatic syncs',
            initialValue: _syncFrequency,
            minValue: 5,
            maxValue: 60,
            step: 5,
            unit: ' min',
            leading: CustomIconWidget(
              iconName: 'sync',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _syncFrequency = value;
              });
              _showToast('Sync frequency set to $value minutes');
            },
          ),
          SwitchSettingWidget(
            title: 'Offline Mode',
            subtitle: 'Work without internet connection',
            initialValue: _offlineMode,
            leading: CustomIconWidget(
              iconName: 'cloud_off',
              color: AppTheme.textSecondary,
              size: 24,
            ),
            onChanged: (value) {
              setState(() {
                _offlineMode = value;
              });
              _showToast('Offline mode ${value ? 'enabled' : 'disabled'}');
            },
          ),
          SettingsItemWidget(
            title: 'Export Data',
            subtitle: 'Download your time tracking data',
            leading: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onTap: _showExportDialog,
          ),
          SettingsItemWidget(
            title: 'Manual Sync',
            subtitle: 'Last synced: 2 minutes ago',
            leading: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.successGreen,
              size: 24,
            ),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onTap: () => _showToast('Syncing data...'),
            showDivider: false,
          ),
          const SizedBox(height: 1),
        ],
      ),

      // Account Section
      SettingsSectionWidget(
        title: 'Account',
        children: [
          SettingsItemWidget(
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            leading: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onTap: () => _showToast('Profile editing coming soon'),
          ),
          SettingsItemWidget(
            title: 'Change Password',
            subtitle: 'Update your account password',
            leading: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onTap: _showPasswordChangeDialog,
          ),
          SettingsItemWidget(
            title: 'Logout',
            subtitle: 'Sign out of your account',
            leading: CustomIconWidget(
              iconName: 'logout',
              color: AppTheme.alertRed,
              size: 24,
            ),
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onTap: _showLogoutDialog,
            showDivider: false,
          ),
          const SizedBox(height: 1),
        ],
      ),
    ];

    if (_searchQuery.isEmpty) {
      return allSettings;
    }

    // Simple search filtering - in a real app, this would be more sophisticated
    return allSettings.where((widget) {
      if (widget is SettingsSectionWidget) {
        return widget.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          // Header with user profile
          UserProfileHeaderWidget(userData: userData),

          // Search bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _isSearching = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search settings...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _isSearching = false;
                          });
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              ),
            ),
          ),

          // Settings content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ..._buildFilteredSettings(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
