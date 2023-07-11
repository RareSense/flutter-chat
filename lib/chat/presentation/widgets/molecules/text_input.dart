import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xGPT/chat/presentation/controllers/audio_controller.dart';
import 'package:xGPT/chat/presentation/controllers/text_input_controller.dart';
import 'package:xGPT/chat/presentation/widgets/atoms/file_input.dart';
import 'package:xGPT/chat/presentation/widgets/atoms/image_input.dart';

class TextInput extends StatefulWidget {
  final bool showImageAndAttachmentButtons;
  const TextInput({Key? key, required this.showImageAndAttachmentButtons})
      : super(key: key);

  @override
  TextInputState createState() => TextInputState();
}

class TextInputState extends State<TextInput> {
  TextInputController textInputController =
      Get.find<TextInputController>(tag: 'textInputController');

  AudioInputController audioInputController =
      Get.find<AudioInputController>(tag: 'audioInputController');

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          focusNode: _focusNode,
          controller: textInputController.textEditingController,
          onChanged: (text) {
            textInputController.inputText.value = text;
            textInputController.hasInput.value = text.isNotEmpty;
          },
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                audioInputController.isRecording.value ? '' : 'Send Message',
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w400, // Thinner font
              color: Color(0xFFb1b5c4), // Grey color
            ),
            prefixIcon: audioInputController.isRecording.value
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.mic,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          audioInputController.formatDuration(
                              audioInputController.recordingDuration.value),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.cyan[50],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            suffixIcon: widget.showImageAndAttachmentButtons
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FileInput(updateHasInput: () => {}),
                      ImageInput(updateHasInput: () => {})
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ));
  }
}
