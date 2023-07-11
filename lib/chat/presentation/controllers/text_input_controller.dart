// lib/controllers/chat_controller.dart
// import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

// import 'dart:io';
import 'package:get/get.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../dummy_data.dart';
// import 'package:xGPT/chat/chat_message.dart';
// import 'package:xGPT/chat/chat_service.dart';
// import 'package:xGPT/chat/image_data.dart';

class TextInputController extends GetxController {
  // Move your state variables from ChatPageState to here, and add "Rx" to make them observable

  TextEditingController textEditingController = TextEditingController();
  RxString inputText = ''.obs;
  final hasInput = false.obs;

  // void sendMessage() async {
  //   if (textEditingController.text.isNotEmpty ||
  //       hasImage.value ||
  //       (recordingPath?.value != null &&
  //           recordingPath?.value.isNotEmpty == true)) {
  //     // Create a new ChatMessage object with text, image, and/or audio
  //     ChatMessage newMessage = ChatMessage(
  //       text: textEditingController.text,
  //       image: pickedImage.value != null
  //           ? ImageData.file(pickedImage.value!)
  //           : null,
  //       audio:
  //       recordingPath?.value.isEmpty ?? true ? null : recordingPath?.value,
  //       type: MessageType.text,
  //       isUser: true,
  //     );
  //
  //     debugPrint("Image chosen: ${newMessage.image}");
  //
  //     messages.add(newMessage);
  //
  //     inputText.value = '';
  //     hasImage.value = false;
  //     pickedImage.value = null;
  //     recordingPath = null;
  //     hasInput.value = inputText.value.isNotEmpty || hasImage.value;
  //     textEditingController.clear();
  //
  //     final reply = await chatApiService.sendMessage(newMessage);
  //
  //     debugPrint(reply.toString());
  //
  //     messages.add(reply);
  //
  //   }
  // }
  void clearTextInput() {
    inputText.value = '';
    textEditingController.clear();
  }

  bool get hasText {
    return textEditingController.text.isNotEmpty;
  }

  // void updateHasInput() {
  //   hasInput.value = inputText.value.isNotEmpty;
  // }
}
