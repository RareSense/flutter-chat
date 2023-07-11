import 'dart:io';

import 'package:file_picker/file_picker.dart';

enum MessageType { text, image, file, waiting }

class ChatMessage {
  String? id;
  final String? text;
  final String? voiceCommand;

  final String? attachmentType;
  final File? pickedImage;
  final PlatformFile? pickedFile;
  final String? url;
  final MessageType type;
  final bool isUser;
  final String? error;
  String? replyToId;
  ChatMessage? repliedToMessage;
  String? sessionId;
  String? createdAt;
  bool? isWaitingForResponse;

  ChatMessage(
      {this.id,
      this.text,
      this.createdAt,
      this.voiceCommand,
      this.attachmentType,
      this.url,
      this.pickedImage,
      this.pickedFile,
      this.error,
      this.sessionId,
      this.replyToId,
      this.repliedToMessage,
      this.isWaitingForResponse,
      required this.type,
      required this.isUser});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    MessageType messageType;

    switch (json['type']) {
      case 'text':
        messageType = MessageType.text;
        break;
      case 'image':
        messageType = MessageType.image;
        break;
      case 'file':
        messageType = MessageType.file;
        break;
      default:
        messageType = MessageType.file;
    }

    final statusCode = json['statusCode'];
    if (statusCode != null) {
      final codes = statusCode.split('.');
      if (codes.length == 3) {
        if (codes[2] == '02') {
          messageType = MessageType.waiting;
        }
      }
    }
    return ChatMessage(
        id: json['id'],
        text: json['text'],
        voiceCommand: json['voiceCommand'],
        attachmentType: json['attachmentType'],
        url: json['url'],
        createdAt: json['createdAt'],
        replyToId: json['replyToId'],
        type: messageType,
        isUser: json['isUser'] ?? false,
        sessionId: json['sessionId'],
        error: json['error']);
  }

  @override
  String toString() {
    return 'ChatMessage {text: $text, voiceCommand: $voiceCommand, createdAt: $createdAt, attachmentType: $attachmentType, url: $url, type: $type, isUser: $isUser, sessionId: $sessionId, error: $error}';
  }
}
