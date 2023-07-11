import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:xGPT/chat/chat_message.dart';
import 'package:xGPT/chat/domain/entities/chat_message.dart';
import 'package:xGPT/chat/image_preview.dart';
// import 'package:xGPT/chat/presentation/controllers/audio_controller.dart';
import 'package:xGPT/chat/presentation/controllers/file_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/image_input_controller.dart';
import 'package:xGPT/chat/presentation/controllers/message_input_controller.dart';
import 'package:xGPT/chat/presentation/widgets/atoms/audio_recording_input.dart';
import 'package:xGPT/chat/presentation/widgets/molecules/text_input.dart';

class MessageInput extends StatefulWidget {
  final Function(ChatMessage) handleMessageSend;

  const MessageInput({Key? key, required this.handleMessageSend})
      : super(key: key);

  @override
  MessageInputState createState() => MessageInputState();
}

class MessageInputState extends State<MessageInput> {
  ImageInputController imageInputController =
      Get.find<ImageInputController>(tag: 'imageInputController');
  FileInputController fileInputController =
      Get.find<FileInputController>(tag: 'fileInputController');
  MessageInputController messageInputController =
      Get.find<MessageInputController>(tag: 'messageInputController');

  @override
  void initState() {
    super.initState();
  }

  Widget sendMessageButton() {
    return IconButton(
      onPressed: () {
        messageInputController.sendMessage(widget.handleMessageSend);
      },
      padding: const EdgeInsets.all(16),
      icon: const Icon(
        Icons.send,
        color: Color(0xFF7147FA),
      ),
    );
  }

  Widget getSendOrAudioButton() {

    if(fileInputController.hasFile.value || imageInputController.hasImage.value || messageInputController.textInputController.hasInput.value){
      return sendMessageButton();
    }

    return AudioRecordingInput(onAudioStopped: widget.handleMessageSend);
  }

  bool shouldShowImageAndAttachmentButtons(){
    return !fileInputController.hasFile.value && !imageInputController.hasImage.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 5, top: 8, bottom: 16),
      child: Obx(() => Column(
        children: [
          imageInputController.hasImage.value
              ? ImagePreview(
                  image: imageInputController.pickedImage.value,
                  removeImage: imageInputController.removeImage,
                )
              : fileInputController.hasFile.value
                  ? ImagePreview(
                      showIcon: true,
                      title: fileInputController.pickedFile.value?.name,
                      removeImage: fileInputController.removeFile,
                    )
                  : const SizedBox.shrink(),
          Row(
            children: [
              Expanded(
                child: TextInput(showImageAndAttachmentButtons: shouldShowImageAndAttachmentButtons()),
              ),
              getSendOrAudioButton()
            ],
          )
        ],
      )),
    );
  }
}
