import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/character_counter.dart';
import './widgets/quick_action_chip.dart';
import './widgets/session_header.dart';
import './widgets/voice_to_text_button.dart';

class SessionNotes extends StatefulWidget {
  const SessionNotes({super.key});

  @override
  State<SessionNotes> createState() => _SessionNotesState();
}

class _SessionNotesState extends State<SessionNotes> {
  final TextEditingController _notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();
  final int _maxCharacters = 500;
  String _selectedTemplate = '';
  bool _hasUnsavedChanges = false;

  // Mock session data
  final Map<String, dynamic> _sessionData = {
    "duration": "02:34:15",
    "projectName": "RemoteIntegrity",
    "startTime": "09:30 AM",
    "date": "September 30, 2024",
  };

  final List<String> _quickTemplates = [
    'Meeting',
    'Development',
    'Research',
    'Documentation',
  ];

  @override
  void initState() {
    super.initState();
    _notesController.addListener(_onTextChanged);

    // Auto-focus text field when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notesFocusNode.requestFocus();
    });

    // Load any existing draft
    _loadDraftNote();
  }

  @override
  void dispose() {
    _notesController.removeListener(_onTextChanged);
    _notesController.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasUnsavedChanges = _notesController.text.isNotEmpty;
    });
    _saveDraftNote();
  }

  void _loadDraftNote() {
    // Simulate loading draft from local storage
    const draftNote = ""; // In real app, load from SharedPreferences
    if (draftNote.isNotEmpty) {
      _notesController.text = draftNote;
    }
  }

  void _saveDraftNote() {
    // Simulate saving draft to local storage
    // In real app, save to SharedPreferences
  }

  void _selectTemplate(String template) {
    setState(() {
      _selectedTemplate = _selectedTemplate == template ? '' : template;
    });

    if (_selectedTemplate.isNotEmpty) {
      final templateText = _getTemplateText(template);
      final currentText = _notesController.text;
      final newText =
          currentText.isEmpty ? templateText : '$currentText\n\n$templateText';

      if (newText.length <= _maxCharacters) {
        _notesController.text = newText;
        _notesController.selection = TextSelection.fromPosition(
          TextPosition(offset: _notesController.text.length),
        );
      }
    }
  }

  String _getTemplateText(String template) {
    switch (template) {
      case 'Meeting':
        return 'Attended team meeting to discuss project progress and upcoming milestones.';
      case 'Development':
        return 'Worked on implementing new features and fixing reported bugs.';
      case 'Research':
        return 'Conducted research on best practices and potential solutions.';
      case 'Documentation':
        return 'Updated project documentation and created user guides.';
      default:
        return '';
    }
  }

  void _onVoiceTextReceived(String text) {
    final currentText = _notesController.text;
    final newText = currentText.isEmpty ? text : '$currentText\n\n$text';

    if (newText.length <= _maxCharacters) {
      setState(() {
        _notesController.text = newText;
      });
      _notesController.selection = TextSelection.fromPosition(
        TextPosition(offset: _notesController.text.length),
      );
    } else {
      _showMessage('Adding voice note would exceed character limit');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Discard Changes?',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Discard',
              style: TextStyle(color: AppTheme.alertRed),
            ),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  void _saveNote() {
    if (_notesController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Empty Note',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to save an empty note?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performSave();
              },
              child: const Text('Save Anyway'),
            ),
          ],
        ),
      );
    } else {
      _performSave();
    }
  }

  void _performSave() {
    // Simulate saving note with session data
    final noteData = {
      "sessionId": DateTime.now().millisecondsSinceEpoch.toString(),
      "userNote": _notesController.text.trim(),
      "duration": _sessionData["duration"],
      "projectName": _sessionData["projectName"],
      "timestamp": DateTime.now().toIso8601String(),
      "date": _sessionData["date"],
    };

    // In real app, save to local storage and queue for sync
    _showMessage('Note saved successfully');

    // Clear draft and navigate back
    setState(() {
      _hasUnsavedChanges = false;
    });

    Navigator.of(context).pop(noteData);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.surfaceWhite,
              size: 6.w,
            ),
          ),
          title: Text(
            'Session Notes',
            style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
          ),
          actions: [
            TextButton(
              onPressed: _saveNote,
              child: Text(
                'Save',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.surfaceWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 2.w),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Session Header
                SessionHeader(
                  duration: _sessionData["duration"] as String,
                  projectName: _sessionData["projectName"] as String,
                ),

                SizedBox(height: 3.h),

                // Notes Input Section
                Text(
                  'Session Notes',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 1.h),

                // Text Input Field
                Container(
                  constraints: BoxConstraints(
                    minHeight: 25.h,
                    maxHeight: 35.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _notesFocusNode.hasFocus
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: _notesFocusNode.hasFocus ? 2 : 1,
                    ),
                  ),
                  child: TextField(
                    controller: _notesController,
                    focusNode: _notesFocusNode,
                    maxLength: _maxCharacters,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Describe what you worked on...',
                      hintStyle:
                          AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(4.w),
                      counterText: '',
                    ),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                  ),
                ),

                SizedBox(height: 2.h),

                // Character Counter and Voice Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CharacterCounter(
                      currentLength: _notesController.text.length,
                      maxLength: _maxCharacters,
                    ),
                    VoiceToTextButton(
                      onTextReceived: _onVoiceTextReceived,
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Quick Action Templates
                Text(
                  'Quick Templates',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 1.h),

                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _quickTemplates.map((template) {
                    return QuickActionChip(
                      label: template,
                      isSelected: _selectedTemplate == template,
                      onTap: () => _selectTemplate(template),
                    );
                  }).toList(),
                ),

                SizedBox(height: 4.h),

                // Session Info Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session Details',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Started: ${_sessionData["startTime"]} • ${_sessionData["date"]}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'work',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Project: ${_sessionData["projectName"]}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
