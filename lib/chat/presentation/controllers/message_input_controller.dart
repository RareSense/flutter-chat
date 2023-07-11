// lib/controllers/chat_controller.dart
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
//
// import 'dart:io';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:xGPT/chat/domain/entities/chat_message.dart';
import 'package:xGPT/chat/presentation/controllers/audio_controller.dart';
import 'package:xGPT/chat/presentation/controllers/file_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/image_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/text_input_controller.dart';

class MessageInputController extends GetxController {
  // Move your state variables from ChatPageState to here, and add "Rx" to make them observable

  TextInputController textInputController = Get.put<TextInputController>(
      TextInputController(),
      tag: 'textInputController');

  ImageInputController imageInputController =
  Get.find<ImageInputController>(tag: 'imageInputController');

  FileInputController fileInputController =
  Get.find<FileInputController>(tag: 'fileInputController');

  AudioInputController audioInputController = Get.put<AudioInputController>(
      AudioInputController(),
      tag: 'audioInputController');

  void sendMessage(Function(ChatMessage) sendMessageCallback) async {
    if (textInputController.hasText ||
        imageInputController.hasImage.value ||
        fileInputController.hasFile.value ||
        audioInputController.hasVoiceRecorded) {
      String? attachmentType;
      File? pickedImage;
      PlatformFile? pickedFile;
      String? url;
      String? voiceCommand;

      if (imageInputController.hasImage.value) {
        attachmentType = 'image';
        pickedImage = imageInputController.pickedImage.value;
      }
      if (fileInputController.hasFile.value) {
        attachmentType = 'file';
        pickedFile = fileInputController.pickedFile.value;
      }
      if (audioInputController.hasVoiceRecorded) {
        voiceCommand = audioInputController.recordingPath?.value;
      }

      // Create a new ChatMessage object with text, image, and/or audio
      ChatMessage newMessage = ChatMessage(
        voiceCommand: voiceCommand,
        text: textInputController.textEditingController.text,
        attachmentType: attachmentType,
        pickedImage: pickedImage,
        pickedFile: pickedFile,
        url: url,
        type: MessageType.text,
        isUser: true,
      );

      enableFileAndImageInputs();
      sendMessageCallback(newMessage);
    }
  }

  void disableFileAndImageInputs() {
    imageInputController.disabled = true;
    fileInputController.disabled = true;
  }

  void enableFileAndImageInputs() {
    imageInputController.disabled = false;
    fileInputController.disabled = false;
  }
}