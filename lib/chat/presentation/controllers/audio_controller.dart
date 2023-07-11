
import 'dart:async';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import 'package:get/get.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:logger/logger.dart';
import 'package:xGPT/chat/domain/entities/chat_message.dart';
import 'package:xGPT/utils/snackbar.dart';

class AudioInputController extends GetxController {
  Rx<FlutterSoundRecorder?> recorder = Rx<FlutterSoundRecorder?>(null);
  RxBool isRecording = false.obs;
  RxString? recordingPath = ''.obs;
  RxInt recordingDuration = 0.obs;
  Rx<Timer?> recordingTimer = Rx<Timer?>(null);

  @override
  void onInit() {
    super.onInit();
    initRecorder();
  }

  @override
  void onClose() {
    recorder.value?.closeRecorder();
    super.onClose();
  }

  Future<void> initRecorder() async {
    recorder.value = FlutterSoundRecorder(logLevel: Level.nothing);
    await recorder.value?.openRecorder();
  }

  bool get hasVoiceRecorded {
    return (recordingPath?.value != null &&
        recordingPath?.value.isNotEmpty == true);
  }

  Future<void> startRecording() async {
    bool hasPermission = await _isPermissionGranted();
    if (!hasPermission) {
      _requestMicrophonePermission();
      debugPrint("I'm here");

      return;
    }

    debugPrint("I'm here");
    try {
      isRecording.value = true;
      recordingPath?.value = await _getFileOutputPath('aac');

      debugPrint("AAC_PATH: ${recordingPath?.value}");
      await recorder.value?.startRecorder(
        toFile: recordingPath?.value,
        codec: Codec.aacADTS,
      );

      _startAudioTimer();
    } catch (e, stackTrace) {
      isRecording.value = false;
      debugPrint("startRecording::e: $e");
      debugPrint("startRecording::stackTrace: $stackTrace");
    }
  }

  Future<ChatMessage?> stopRecording() async {
    try {
      await recorder.value?.stopRecorder();

      if (recordingPath?.value.isEmpty ?? true) return null;

      String aacPath = recordingPath!.value;

      String m4aPath = await _convertAacToM4a(aacPath);


      resetAudioRecorder();

      if(m4aPath.isEmpty){
        Snackbar.showError('Unable to send voice message');
        throw Exception('Unable to send voice message');
      }
      Amplitude.getInstance().logEvent('SendAudioAction');
      return ChatMessage(
        voiceCommand: m4aPath,
        type: MessageType.text,
        isUser: true,
      );
    } catch (e, stackTrace) {
      debugPrint("stopRecording::error:$e");
      debugPrint("stopRecording::stackTrace:$stackTrace");
      resetAudioRecorder();
    }

    return null;
  }

  void resetAudioRecorder() {
    recordingPath?.value = '';
    isRecording.value = false;

    recordingTimer.value?.cancel();
    recordingDuration.value = 0;

  }

  String formatDuration(int seconds) {
    int minutes = (seconds / 60).truncate();
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startAudioTimer() {
    recordingDuration.value = 0;
    recordingTimer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingDuration.value++;
    });
  }

  Future<bool> _isPermissionGranted() async {
    PermissionStatus status = await Permission.microphone.status;
    return status.isGranted;
  }

  Future<void> _requestMicrophonePermission() async {
    PermissionStatus newStatus = await Permission.microphone.request();
  }

  Future<String> _convertAacToM4a(String inputPath) async {
    final outputPath = await _getFileOutputPath('m4a');
    debugPrint("Converting $inputPath to $outputPath"); // Add this line

    final command = '-i $inputPath -acodec copy -y  $outputPath';

    try {
      final session = await FFmpegKit.execute(command);

      final returnCode = await session.getReturnCode();

      if (returnCode == null) {
        debugPrint('Conversion failed with null return code.');
        return '';
      } else if (ReturnCode.isSuccess(returnCode)) {
        debugPrint('Conversion completed successfully.');
        return outputPath;
      } else {
        debugPrint('Conversion failed with return code $returnCode.');
        // throw Exception('Audio conversion failed');
        return '';
      }
    } catch (e, stackTrace) {
      debugPrint('Exception while executing FFmpeg command: $e');
      debugPrint('Stack trace: $stackTrace');
      return '';
    }
  }

  Future<String> _getFileOutputPath(String extension) async {
    final appDirectory = await getTemporaryDirectory();
    final outputPath =
        '${appDirectory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.$extension';

    return outputPath;
  }
}
