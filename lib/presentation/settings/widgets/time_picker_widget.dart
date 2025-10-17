import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimePickerWidget extends StatefulWidget {
  final String title;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimePickerWidget({
    Key? key,
    required this.title,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primaryBlue,
                  onPrimary: AppTheme.surfaceWhite,
                  surface: AppTheme.surfaceWhite,
                  onSurface: AppTheme.textPrimary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selectTime,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _formatTime(_selectedTime),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
