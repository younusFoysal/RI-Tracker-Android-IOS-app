import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimerControlWidget extends StatefulWidget {
  final bool isActive;
  final VoidCallback onStartStop;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final bool isPaused;

  const TimerControlWidget({
    Key? key,
    required this.isActive,
    required this.onStartStop,
    this.onPause,
    this.onResume,
    this.isPaused = false,
  }) : super(key: key);

  @override
  State<TimerControlWidget> createState() => _TimerControlWidgetState();
}

class _TimerControlWidgetState extends State<TimerControlWidget>
    with TickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    _rippleController.forward().then((_) {
      _rippleController.reset();
    });

    widget.onStartStop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Main Start/Stop Button with modern design
          Stack(
            alignment: Alignment.center,
            children: [
              // Ripple effect
              if (widget.isActive)
                AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return Container(
                      width: (25.w) * (1 + _rippleAnimation.value * 0.3),
                      height: (12.h) * (1 + _rippleAnimation.value * 0.3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.alertRed.withValues(
                            alpha: 0.3 * (1 - _rippleAnimation.value),
                          ),
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),

              // Main button
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: GestureDetector(
                      onTapDown: (_) => _buttonAnimationController.forward(),
                      onTapUp: (_) => _buttonAnimationController.reverse(),
                      onTapCancel: () => _buttonAnimationController.reverse(),
                      onTap: _onButtonPressed,
                      child: Container(
                        width: 25.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors:
                                widget.isActive
                                    ? [
                                      AppTheme.alertRed,
                                      AppTheme.alertRed.withValues(alpha: 0.8),
                                    ]
                                    : [
                                      AppTheme.primaryBlue,
                                      AppTheme.primaryBlueDark,
                                    ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  widget.isActive
                                      ? AppTheme.alertRed.withValues(alpha: 0.4)
                                      : AppTheme.primaryBlue.withValues(
                                        alpha: 0.4,
                                      ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.2),
                              blurRadius: 2,
                              offset: const Offset(-2, -2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child:
                                widget.isActive
                                    ? CustomIconWidget(
                                      key: const ValueKey('stop'),
                                      iconName: 'stop',
                                      color: AppTheme.surfaceWhite,
                                      size: 40,
                                    )
                                    : CustomIconWidget(
                                      key: const ValueKey('play'),
                                      iconName: 'play_arrow',
                                      color: AppTheme.surfaceWhite,
                                      size: 40,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Button label with animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              widget.isActive ? 'Stop Session' : 'Start Session',
              key: ValueKey(widget.isActive),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Pause/Resume controls when active
          if (widget.isActive) ...[
            SizedBox(height: 3.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pause/Resume button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton.icon(
                    onPressed:
                        widget.isPaused ? widget.onResume : widget.onPause,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.isPaused
                              ? AppTheme.successGreen
                              : AppTheme.primaryBlue.withValues(alpha: 0.8),
                      foregroundColor: AppTheme.surfaceWhite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.5.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 8,
                      shadowColor:
                          widget.isPaused
                              ? AppTheme.successGreen.withValues(alpha: 0.3)
                              : AppTheme.primaryBlue.withValues(alpha: 0.3),
                    ),
                    icon: CustomIconWidget(
                      iconName: widget.isPaused ? 'play_arrow' : 'pause',
                      color: AppTheme.surfaceWhite,
                      size: 20,
                    ),
                    label: Text(
                      widget.isPaused ? 'Resume' : 'Pause',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.surfaceWhite,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                // Quick actions button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.textSecondary.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _showQuickActions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.surfaceWhite,
                      foregroundColor: AppTheme.textPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppTheme.textSecondary.withValues(alpha: 0.2),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  height: 4,
                  width: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      Text(
                        'Session Actions',
                        style: AppTheme.lightTheme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3.h),

                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'note_add',
                          color: AppTheme.primaryBlue,
                        ),
                        title: const Text('Add Notes'),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to notes
                        },
                      ),

                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'schedule',
                          color: AppTheme.textSecondary,
                        ),
                        title: const Text('Set Target'),
                        onTap: () {
                          Navigator.pop(context);
                          // Show target setting dialog
                        },
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
