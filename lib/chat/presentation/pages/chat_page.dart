import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:xGPT/chat/domain/entities/chat_message.dart';

import 'package:xGPT/chat/presentation/widgets/organisms/chat_bubble.dart';
import 'package:xGPT/chat/presentation/controllers/chat_controller.dart';
import 'package:xGPT/chat/presentation/controllers/file_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/image_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/message_input_controller.dart';
import 'package:xGPT/chat/presentation/widgets/organisms/message_input.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  ValueNotifier<bool> isMessageSelected = ValueNotifier<bool>(false);

  ChatMessage? selectedMessage;

  late AnimationController _animationController;

  final Map<ChatMessage, ValueNotifier<double>> animationValues = {};
  final ScrollController _scrollController = ScrollController();

  ImageInputController imageInputController = Get.put<ImageInputController>(
      ImageInputController(),
      tag: 'imageInputController');

  FileInputController fileInputController = Get.put<FileInputController>(
      FileInputController(),
      tag: 'fileInputController');

  MessageInputController messageInputController =
      Get.put<MessageInputController>(MessageInputController(),
          tag: 'messageInputController');

  final ChatController chatController =
      Get.put(ChatController(), tag: 'chatController');

  @override
  void dispose() {
    chatController.currentPage.value = 1;
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    Future.microtask(() {
      loadMessages();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        chatController.loadMessages(chatController.sessionId.value);
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void loadMessages() {
    chatController.resetToDefaults();
    if (Get.arguments != null && Get.arguments['sessionId'] != null) {
      chatController.sessionId.value = Get.arguments['sessionId'];
    } else {
      chatController.sessionId.value = '';
    }
    if (chatController.sessionId.value.isNotEmpty) {
      chatController.loadMessages(chatController.sessionId.value);
    } else {
      chatController.messages.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Scaffold(
            // appBar: const ChatAppBar(),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFfafafa),
                    Colors.white,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    bottom: selectedMessage == null ? 60.0 : 100.0,
                    child: Obx(() => chatController.messages.isEmpty &&
                            !chatController.areMessagesLoading.value
                        ? const Center(
                            child: Text('Wow, such empty'),
                          )
                        : Stack(
                            children: [
                              ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                padding: const EdgeInsets.only(bottom: 8.0),
                                itemCount: chatController.messages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ChatMessage message =
                                      chatController.messages[index];
                                  if (!animationValues.containsKey(message)) {
                                    animationValues[message] =
                                        ValueNotifier<double>(0.0);
                                  }
                                  return ChatBubble(
                                    message: message,
                                    showImage: (fileOrUrl) {
                                      if (fileOrUrl is String) {
                                        chatController.imagePreviewUrl
                                            .value = fileOrUrl;
                                      } else if (fileOrUrl is File) {
                                        chatController.imagePreviewFile
                                            .value = fileOrUrl;
                                      }
                                    },
                                  );
                                  // return GestureDetector(
                                  //   onHorizontalDragUpdate: (details) {
                                  //     if (details.delta.dx > 0) {
                                  //       double newValue =
                                  //           animationValues[message]!.value +
                                  //               details.delta.dx /
                                  //                   (0.4 *
                                  //                       MediaQuery.of(context)
                                  //                           .size
                                  //                           .width);
                                  //       if (newValue <= 0.85) {
                                  //         animationValues[message]!.value =
                                  //             newValue;
                                  //       } else {
                                  //         animationValues[message]!.value =
                                  //             0.85;
                                  //       }
                                  //     }
                                  //   },
                                  //   onHorizontalDragEnd: (details) {
                                  //     if (animationValues[message]!.value >=
                                  //         0.3) {
                                  //       setState(() {
                                  //         selectedMessage = message;
                                  //       });
                                  //       if (message.attachmentType != null) {
                                  //         messageInputController
                                  //             .disableFileAndImageInputs();
                                  //       }
                                  //
                                  //       isMessageSelected.value = true;
                                  //     }
                                  //     animationValues[message]!.value = 0.0;
                                  //   },
                                  //   child: AnimatedBuilder(
                                  //     animation: animationValues[message]!,
                                  //     builder: (context, child) {
                                  //       double curveValue = Curves.easeOutCubic
                                  //           .transform(animationValues[message]!
                                  //               .value);
                                  //       bool showFilledIcon =
                                  //           animationValues[message]!.value >=
                                  //               0.3;
                                  //       return Stack(
                                  //         children: [
                                  //           if (animationValues[message]!
                                  //                   .value >
                                  //               0)
                                  //             Positioned(
                                  //               left: curveValue *
                                  //                       0.4 *
                                  //                       MediaQuery.of(context)
                                  //                           .size
                                  //                           .width -
                                  //                   30,
                                  //               top: 0,
                                  //               bottom: 0,
                                  //               child: Icon(
                                  //                 showFilledIcon
                                  //                     ? Icons.check_circle
                                  //                     : Icons
                                  //                         .check_circle_outline,
                                  //                 color: showFilledIcon
                                  //                     ? Colors.green
                                  //                     : Colors.black,
                                  //               ),
                                  //             ),
                                  //           Transform.translate(
                                  //             offset: Offset(
                                  //                 curveValue *
                                  //                     0.4 *
                                  //                     MediaQuery.of(context)
                                  //                         .size
                                  //                         .width,
                                  //                 0),
                                  //             child: child,
                                  //           ),
                                  //         ],
                                  //       );
                                  //     },
                                  //     child: ChatBubble(
                                  //       message: message,
                                  //       showImage: (fileOrUrl) {
                                  //         if (fileOrUrl is String) {
                                  //           chatController.imagePreviewUrl
                                  //               .value = fileOrUrl;
                                  //         } else if (fileOrUrl is File) {
                                  //           chatController.imagePreviewFile
                                  //               .value = fileOrUrl;
                                  //         }
                                  //       },
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                              chatController.areMessagesLoading.value
                                  ? const Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          )),
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: -13.0,
                    child:
                        MessageInput(handleMessageSend: (ChatMessage message) {
                      _scrollToBottom();
                      message.replyToId = selectedMessage?.id;
                      if (selectedMessage != null) {
                        message.repliedToMessage = selectedMessage;
                      }

                      chatController.handleSendMessage(message);

                      if (message.attachmentType == 'file') {
                        setState(() {
                          isMessageSelected.value = true;
                          selectedMessage = message;
                        });
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
