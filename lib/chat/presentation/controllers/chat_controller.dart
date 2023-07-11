// lib/controllers/chat_controller.dart
import 'dart:async';
import 'dart:io';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:xGPT/chat/domain/entities/chat_message.dart';
import 'package:xGPT/chat/presentation/controllers/file_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/image_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/text_input_controller.dart';

class ChatController extends GetxController {
  StreamSubscription? subscription;
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  RxInt currentPage = 1.obs;
  RxBool areMessagesLoading = false.obs;
  RxBool hasReachedTheEnd = false.obs;
  Rx<File?> imagePreviewFile = Rx<File?>(null);
  Rx<String?> imagePreviewUrl = Rx<String?>(null);
  RxBool isWaitingForResponse = false.obs;

  final imageInputController =
      Get.find<ImageInputController>(tag: 'imageInputController');
  final fileInputController =
      Get.find<FileInputController>(tag: 'fileInputController');
  final textInputController =
      Get.find<TextInputController>(tag: 'textInputController');

  RxString sessionId = ''.obs;


  Future<void> loadMessages(String sessionId) async {
    debugPrint(
        'Loading: ${areMessagesLoading.value}, Ended: ${hasReachedTheEnd.value}, Page: ${currentPage.value}');

    if (areMessagesLoading.value || hasReachedTheEnd.value) return;

    areMessagesLoading.value = true;

    List<ChatMessage>? newMessages = true
        ? [
            ChatMessage(type: MessageType.text, text: 'Hi', isUser: true),
            ChatMessage(
                type: MessageType.text,
                text: 'Hi! How can I help you',
                isUser: false),
          ]
        : null;

    if (newMessages == null || newMessages.length < 10) {
      hasReachedTheEnd.value = true;
    }

    currentPage.value++;

    if (newMessages != null && newMessages.isNotEmpty) {
      messages.addAll(newMessages);
    } else {
      hasReachedTheEnd.value = true;
    }

    areMessagesLoading.value = false;
  }

  void removeLoaderBubble() {
    if (messages.isNotEmpty &&
        messages[0].type == MessageType.waiting &&
        messages[0].text == null) {
      messages.removeAt(0);
    }
  }

  Future<void> handleSendMessage(ChatMessage newMessage) async {
    removeLoaderBubble();

    newMessage.sessionId = sessionId.value;

    newMessage.createdAt = DateTime.now().toString();

    messages.insert(0, newMessage);

    clearInputs();

    messages.insert(0, ChatMessage(type: MessageType.waiting, isUser: false, createdAt: DateTime.now().toString()));

    Amplitude.getInstance().logEvent('SendMessageAction');

    late ChatMessage? reply = true
        ? ChatMessage(
            type: MessageType.text,
            text: 'Hi! How can I help you',
            isUser: false)
        : null;

    removeLoaderBubble();

    messages.refresh();

    if (reply == null) return;

    debugPrint("Reply: $reply}");

    if (reply.error != null) {
      sessionId.value = reply.sessionId ?? sessionId.value;
      return;
    }

    removeLoaderBubble();

    messages[0].id = reply.replyToId;
    messages.refresh();

    sessionId.value = reply.sessionId ?? sessionId.value;

    reply.replyToId = null;

    messages.insert(0, reply);
  }



  void clearInputs() {

    imageInputController.removeImage();
    imageInputController.pickedImage.value = null;
    textInputController.clearTextInput();
    fileInputController.removeFile();
    textInputController.hasInput.value = false;

  }

  void resetToDefaults() {
    hasReachedTheEnd.value = false;
    areMessagesLoading.value = false;
    messages.clear();
  }
}
