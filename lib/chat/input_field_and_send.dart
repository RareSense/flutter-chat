// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:xGPT/chat/chat_controller.dart';
// import 'package:xGPT/chat/chat_message.dart';
// import 'package:xGPT/chat/image_preview.dart';
// import 'package:xGPT/chat/presentation/controllers/audio_controller.dart';
// import 'package:xGPT/chat/presentation/widgets/atoms/audio_recording_input.dart';
//
// class InputFieldAndSend extends StatefulWidget {
//   final ChatController chatController;
//
//   const InputFieldAndSend({Key? key, required this.chatController})
//       : super(key: key);
//
//   @override
//   InputFieldAndSendState createState() => InputFieldAndSendState();
// }
//
// class InputFieldAndSendState extends State<InputFieldAndSend> {
//   AudioInputController audioRecordingController =
//       Get.find<AudioInputController>(tag: 'audioRecordingController');
//
//   Future<void> onChooseImagePressed() async {
//     bool hasPermission = await widget.chatController.requestStoragePermission();
//
//     if (!mounted) return;
//
//     if (hasPermission) {
//       widget.chatController.chooseImage(context);
//     } else {
//       // Show a message to the user if they don't grant permission
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Storage permission is required to access images.'),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(left: 16, right: 5, top: 8, bottom: 16),
//       child: Column(
//         children: [
//           Obx(() => widget.chatController.hasImage.value
//               ? ImagePreview(
//                   image: widget.chatController.pickedImage.value,
//                   removeImage: widget.chatController.removeImage,
//                 )
//               : const SizedBox.shrink()),
//           Row(
//             children: [
//               Expanded(
//                 child: Obx(() => TextField(
//                       controller: widget.chatController.textEditingController,
//                       onChanged: (text) {
//                         widget.chatController.inputText.value = text;
//                         widget.chatController.hasInput.value =
//                             text.isNotEmpty ||
//                                 widget.chatController.hasImage.value;
//                       },
//                       decoration: InputDecoration(
//                         hintText: audioRecordingController.isRecording.value
//                             ? ''
//                             : 'Type your message here',
//                         prefixIcon: audioRecordingController.isRecording.value
//                             ? Obx(() => Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 12, vertical: 8),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       const Icon(
//                                         Icons.mic,
//                                         color: Colors.red,
//                                         size: 18,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         audioRecordingController.formatDuration(
//                                             audioRecordingController
//                                                 .recordingDuration.value),
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.red,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ))
//                             : null,
//                         filled: true,
//                         fillColor: Colors.white,
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         contentPadding:
//                             const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                         suffixIcon:
//                             Obx(() => !widget.chatController.hasInput.value
//                                 ? IconButton(
//                                     onPressed: onChooseImagePressed,
//                                     icon: const Icon(
//                                       Icons.camera_alt,
//                                       color: Color(0xFF7147FA),
//                                     ),
//                                   )
//                                 : IconButton(
//                                     onPressed:
//                                         widget.chatController.sendMessage,
//                                     icon: const Icon(
//                                       Icons.send,
//                                       color: Color(0xFF7147FA),
//                                     ),
//                                   )),
//                       ),
//                     )),
//               ),
//              AudioRecordingInput(onAudioStopped: (ChatMessage chatMessage){
//
//              })
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
