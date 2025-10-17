import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SwitchSettingWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final Widget? leading;

  const SwitchSettingWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.initialValue,
    required this.onChanged,
    this.leading,
  }) : super(key: key);

  @override
  State<SwitchSettingWidget> createState() => _SwitchSettingWidgetState();
}

class _SwitchSettingWidgetState extends State<SwitchSettingWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          widget.leading != null
              ? Container(
                  margin: EdgeInsets.only(right: 3.w),
                  child: widget.leading,
                )
              : const SizedBox.shrink(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                widget.subtitle != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          widget.subtitle!,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Switch(
            value: _value,
            onChanged: (bool newValue) {
              setState(() {
                _value = newValue;
              });
              widget.onChanged(newValue);
            },
            activeColor: AppTheme.primaryBlue,
            activeTrackColor: AppTheme.primaryBlue.withValues(alpha: 0.3),
            inactiveThumbColor: AppTheme.progressTrack,
            inactiveTrackColor: AppTheme.borderSubtle,
          ),
        ],
      ),
    );
  }
}
