import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xGPT/chat/domain/entities/chat_message.dart';
import 'package:xGPT/chat/presentation/controllers/audio_controller.dart';
import 'package:xGPT/themes/theme.dart';

class AudioRecordingInput extends StatefulWidget {
  final Function(ChatMessage) onAudioStopped;

  const AudioRecordingInput({
    Key? key,
    required this.onAudioStopped,
  }) : super(key: key);

  @override
  AudioRecordingInputState createState() => AudioRecordingInputState();
}

class AudioRecordingInputState extends State<AudioRecordingInput> {
  final AudioInputController _audioInputController =
      Get.find<AudioInputController>(tag: 'audioInputController');

  bool _longPressInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Listener(
        onPointerDown: (PointerDownEvent event) async {
          debugPrint("Entering into event");
          if (event.buttons == kPrimaryButton) {
            debugPrint(
                "-------------- Listener LongPressed Just Started ------------");
            _longPressInProgress = true;
            Future.delayed(
              const Duration(milliseconds: 500),
              () async {
                if (_longPressInProgress) {
                  debugPrint("500ms have been passed");
                  debugPrint(
                      "-------------- Listener LongPressed ------------");
                  await _audioInputController.startRecording();
                }
              },
            );
          }
        },
        onPointerUp: (PointerUpEvent event) async {
          _longPressInProgress = false;
          debugPrint("Pointer is up");
          if (!_audioInputController.isRecording.value) return;

          ChatMessage? chatMessage =
              await _audioInputController.stopRecording();

          if (chatMessage == null) return;

          widget.onAudioStopped(chatMessage);
        },
        onPointerCancel: (PointerCancelEvent event) {
          debugPrint("Pointer cancelled");
          _longPressInProgress = false;
        },
        behavior: HitTestBehavior.deferToChild,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            // onLongPress: (){
            //   debugPrint("Long pressed");
            // },
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.all(16), // Adjust to your preferred padding
              child: Icon(
                _audioInputController.isRecording.value
                    ? Icons.stop
                    : Icons.mic,
                color: _audioInputController.isRecording.value
                    ? Colors.red
                    : AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
