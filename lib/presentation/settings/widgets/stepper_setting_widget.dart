import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StepperSettingWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final int step;
  final String unit;
  final ValueChanged<int> onChanged;
  final Widget? leading;

  const StepperSettingWidget({
    Key? key,
    required this.title,
    this.subtitle,
    required this.initialValue,
    this.minValue = 1,
    this.maxValue = 60,
    this.step = 1,
    this.unit = '',
    required this.onChanged,
    this.leading,
  }) : super(key: key);

  @override
  State<StepperSettingWidget> createState() => _StepperSettingWidgetState();
}

class _StepperSettingWidgetState extends State<StepperSettingWidget> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _increment() {
    if (_value < widget.maxValue) {
      setState(() {
        _value += widget.step;
      });
      widget.onChanged(_value);
    }
  }

  void _decrement() {
    if (_value > widget.minValue) {
      setState(() {
        _value -= widget.step;
      });
      widget.onChanged(_value);
    }
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
          Row(
            children: [
              InkWell(
                onTap: _value > widget.minValue ? _decrement : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _value > widget.minValue
                        ? AppTheme.primaryBlue
                        : AppTheme.borderSubtle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'remove',
                    color: _value > widget.minValue
                        ? AppTheme.surfaceWhite
                        : AppTheme.textSecondary,
                    size: 16,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.progressTrack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_value${widget.unit}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: _value < widget.maxValue ? _increment : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _value < widget.maxValue
                        ? AppTheme.primaryBlue
                        : AppTheme.borderSubtle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: _value < widget.maxValue
                        ? AppTheme.surfaceWhite
                        : AppTheme.textSecondary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
