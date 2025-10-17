import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectSelectorWidget extends StatefulWidget {
  final String selectedProject;
  final Function(String) onProjectChanged;

  const ProjectSelectorWidget({
    Key? key,
    required this.selectedProject,
    required this.onProjectChanged,
  }) : super(key: key);

  @override
  State<ProjectSelectorWidget> createState() => _ProjectSelectorWidgetState();
}

class _ProjectSelectorWidgetState extends State<ProjectSelectorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  final List<Map<String, dynamic>> projects = [
    {'name': 'RemoteIntegrity', 'color': AppTheme.primaryBlue, 'icon': 'work'},
    {
      'name': 'Project Alpha',
      'color': AppTheme.successGreen,
      'icon': 'science',
    },
    {'name': 'Project Beta', 'color': AppTheme.alertRed, 'icon': 'bug_report'},
    {
      'name': 'Client Work',
      'color': const Color(0xFF9C27B0),
      'icon': 'business',
    },
    {
      'name': 'Internal Tasks',
      'color': const Color(0xFFFF9800),
      'icon': 'home_work',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getSelectedProject() {
    return projects.firstWhere(
      (project) => project['name'] == widget.selectedProject,
      orElse: () => projects.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProject = _getSelectedProject();

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.surface,
                  AppTheme.lightTheme.colorScheme.surface.withValues(
                    alpha: 0.9,
                  ),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selectedProject['color'].withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: selectedProject['color'].withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: AppTheme.shadowLight.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    // Project icon with modern styling
                    Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        color: selectedProject['color'].withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedProject['color'].withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: selectedProject['icon'],
                        color: selectedProject['color'],
                        size: 20,
                      ),
                    ),

                    SizedBox(width: 4.w),

                    // Project details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Project',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            selectedProject['name'],
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                          ),
                        ],
                      ),
                    ),

                    // Dropdown button with modern design
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PopupMenuButton<String>(
                        onSelected: (String value) {
                          widget.onProjectChanged(value);
                        },
                        icon: CustomIconWidget(
                          iconName: 'keyboard_arrow_down',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: AppTheme.surfaceWhite,
                        elevation: 20,
                        shadowColor: AppTheme.shadowLight.withValues(
                          alpha: 0.3,
                        ),
                        itemBuilder: (BuildContext context) {
                          return projects.map((project) {
                            return PopupMenuItem<String>(
                              value: project['name'],
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: project['color'].withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: project['icon'],
                                        color: project['color'],
                                        size: 16,
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        project['name'],
                                        style: AppTheme
                                            .lightTheme
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppTheme.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    if (project['name'] ==
                                        widget.selectedProject)
                                      Icon(
                                        Icons.check_circle_rounded,
                                        color: project['color'],
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
