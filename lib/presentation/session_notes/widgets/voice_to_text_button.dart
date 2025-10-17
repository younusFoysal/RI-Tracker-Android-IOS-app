import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class VoiceToTextButton extends StatefulWidget {
  final Function(String) onTextReceived;

  const VoiceToTextButton({
    super.key,
    required this.onTextReceived,
  });

  @override
  State<VoiceToTextButton> createState() => _VoiceToTextButtonState();
}

class _VoiceToTextButtonState extends State<VoiceToTextButton> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (!kIsWeb) {
        final status = await Permission.microphone.request();
        if (!status.isGranted) {
          _showErrorMessage('Microphone permission required');
          return;
        }
      }

      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: 'recording.aac', // Add required path parameter
          );
        }
      } else {
        _showErrorMessage('Microphone access denied');
      }
    } catch (e) {
      _showErrorMessage('Failed to start recording');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      final path = await _audioRecorder.stop();

      if (path != null) {
        // Simulate voice-to-text processing
        await Future.delayed(const Duration(seconds: 2));

        // Mock transcription result
        const mockTranscription =
            "Worked on implementing the session notes feature with voice-to-text functionality.";
        widget.onTextReceived(mockTranscription);
      }
    } catch (e) {
      _showErrorMessage('Failed to process recording');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.alertRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isProcessing ? null : _toggleRecording,
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: _isRecording
              ? AppTheme.alertRed
              : _isProcessing
                  ? AppTheme.lightTheme.colorScheme.outline
                  : AppTheme.lightTheme.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: _isProcessing
              ? SizedBox(
                  width: 5.w,
                  height: 5.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.surface,
                    ),
                  ),
                )
              : CustomIconWidget(
                  iconName: _isRecording ? 'stop' : 'mic',
                  color: AppTheme.lightTheme.colorScheme.surface,
                  size: 6.w,
                ),
        ),
      ),
    );
  }
}