import 'package:flutter/material.dart';
import 'package:xGPT/chat/domain/entities/chat_message.dart';
import 'package:xGPT/chat/presentation/callbacks/show_image.dart';
import 'package:xGPT/chat/presentation/widgets/atoms/tick_and_text.dart';
import 'package:xGPT/themes/theme.dart';
import 'package:xGPT/chat/presentation/widgets/atoms/chat_bubble.dart';
import 'package:xGPT/chat/presentation/widgets/molecules/animated_dots.dart';
import 'package:xGPT/chat/presentation/widgets/molecules/chat_bubble.dart';
import 'package:xGPT/chat/presentation/widgets/molecules/reply_preview.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage message;
  final ShowImageCallback showImage;

  const ChatBubble({
    required this.message,
    required this.showImage,
    Key? key,
  }) : super(key: key);

  @override
  ChatBubbleState createState() => ChatBubbleState();
}

class ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment:
            widget.message.isUser ? Alignment.topRight : Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.message.type==MessageType.waiting)
              if (widget.message.text==null)
                const AnimatedDots()
              else TickAndText(text:widget.message.text!)
            else ...[
              Container(
                decoration: BoxDecoration(
                  color: widget.message.isUser
                      ? const Color(0xFF7147FA)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 8, // soften the shadow
                      spreadRadius: 0, //extend the shadow
                      offset: Offset(
                        0, // Move to right 10 horizontally
                        2, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.message.repliedToMessage != null)
                      Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          child: ReplyPreviewWidget(
                              selectedMessage:
                              widget.message.repliedToMessage)),
                    if (widget.message.attachmentType == 'image')
                      ImageWidget(
                          image: widget.message.pickedImage ??
                              widget.message.url,
                          showImage: widget.showImage),
                    if (widget.message.attachmentType == 'file')
                      const FileIcon(),
                    if (widget.message.text != null &&
                        widget.message.text!.isNotEmpty) ...[
                      if (widget.message.attachmentType != null)
                        const SizedBox(
                            height:
                            8), // Add some spacing between the image and text
                      LinkifiedText(
                        text: widget.message.text!,
                        style: TextStyle(
                          color: widget.message.isUser
                              ? Colors.white
                              : Colors.black,
                          fontSize: 17,
                        ),
                        linkStyle: const TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.none),
                      ),
                    ],
                    if (widget.message.voiceCommand != null)
                      AudioPlayerUI(
                        voiceCommand: widget.message.voiceCommand!,
                        isUser: widget.message.isUser,
                      ),
                  ],
                  // children: [
                  //   if (widget.message.repliedToMessage != null)
                  //     Container(
                  //         margin: const EdgeInsets.only(bottom: 3),
                  //         child: ReplyPreviewWidget(
                  //             selectedMessage: widget.message.repliedToMessage)),
                  //   if (widget.message.attachmentType == 'image')
                  //     ClipRRect(
                  //       borderRadius: BorderRadius.circular(16),
                  //       child: buildImageWidget(
                  //           widget.message.pickedImage ?? widget.message.url),
                  //     ),
                  //   if (widget.message.attachmentType == 'file')
                  //     const Icon(
                  //       Icons.file_copy,
                  //       size: 100,
                  //       color: Colors.white70,
                  //     ),
                  //
                  //   if (widget.message.text != null &&
                  //       widget.message.text!.isNotEmpty) ...[
                  //     if (widget.message.attachmentType != null)
                  //       const SizedBox(
                  //           height:
                  //           8), // Add some spacing between the image and text
                  //     Container(
                  //       margin: getLowerWidgetMargin(),
                  //       constraints: BoxConstraints(
                  //         maxWidth: MediaQuery.of(context).size.width * 0.75,
                  //       ),
                  //       child: Linkify(
                  //         onOpen: (link) async {
                  //           Uri uri = Uri.parse(link.url);
                  //           if (await canLaunchUrl(uri)) {
                  //             await launchUrl(uri);
                  //           }
                  //         },
                  //         text: formatText(widget.message.text!),
                  //         style: TextStyle(
                  //           color: widget.message.isUser
                  //               ? Colors.white
                  //               : Colors.black,
                  //           fontSize: 17,
                  //         ),
                  //         linkStyle: const TextStyle(
                  //           color: Colors.blue, // This is the color of the links.
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  //   if (widget.message.voiceCommand != null) buildAudioWidget(),
                  // ],
                ),
              ),
              if (widget.message.createdAt != null)
                FormattedDate(
                  date: widget.message.createdAt!,
                  color: const Color(0xFFb1b5c4),
                )
            ],
          ],
        ),
      ),
    );
  }
}
