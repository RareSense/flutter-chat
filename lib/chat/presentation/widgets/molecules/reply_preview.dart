import 'package:flutter/material.dart';
import 'package:xGPT/chat/domain/entities/chat_message.dart';
import 'package:xGPT/themes/theme.dart';

class ReplyPreviewWidget extends StatefulWidget {

  final ChatMessage? selectedMessage;
  final Function()? onRemove;

  const ReplyPreviewWidget({
    this.onRemove,
    required this.selectedMessage,

    Key? key,
  }) : super(key: key);

  @override
  ReplyPreviewWidgetState createState() => ReplyPreviewWidgetState();
}

class ReplyPreviewWidgetState extends State<ReplyPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedMessage != null) {
      String textToDisplay = '';
      IconData? leftIcon;
      if (widget.selectedMessage?.text?.isNotEmpty ?? false) {
        textToDisplay = widget.selectedMessage!.text!;
        if (widget.selectedMessage?.attachmentType == 'image') {
          leftIcon = Icons.image;
        }
      } else if (widget.selectedMessage?.attachmentType == 'image') {
        textToDisplay = 'Image';
        leftIcon = Icons.image;
      } else if (widget.selectedMessage?.voiceCommand != null) {
        textToDisplay = 'Audio';
        leftIcon = Icons.play_arrow;
      } else {
        textToDisplay = 'File';
        leftIcon = Icons.file_copy;
      }
      return _buildContainer(textToDisplay, leftIcon);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildContainer(String textToDisplay, IconData? leftIcon) {
    Radius topRadius = const Radius.circular(10.0);

    Radius bottomRadius = const Radius.circular(25.0);
    Color replyBackgroundColor = const Color(0xFFf5f6fa);
    EdgeInsets containerMargin = const EdgeInsets.only(left: 16, right: 61);
    EdgeInsets containerPadding = const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 55);

    Border? leftBorder = const Border(
      left: BorderSide(
        color: AppColors.primary,
        width: 5.0,
      ),
    );
    if(widget.selectedMessage!=null && widget.onRemove==null){
      bottomRadius = const Radius.circular(10.0);
      replyBackgroundColor=Colors.transparent;
      containerMargin= containerPadding = const EdgeInsets.all(0.0);
      leftBorder=null;
  }
    return Container(
      color: replyBackgroundColor,
      // padding: const EdgeInsets.only(top: 5),
      child: Container(
        // width: widget.selectedMessage!=null? const
        margin: containerMargin,
        padding: containerPadding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:  BorderRadius.only(
            topLeft: topRadius,
            topRight: topRadius,
            bottomLeft: bottomRadius,
            bottomRight: bottomRadius,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Container(
            padding:
                const EdgeInsets.only(left: 10, top: 6, right: 6, bottom: 6),
            decoration: BoxDecoration(
              color: Colors.cyan[50],
              border: leftBorder ,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (leftIcon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: Icon(
                              leftIcon,
                              size: 24,
                              color: Colors.teal,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            textToDisplay,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.onRemove!=null?GestureDetector(
                  onTap: widget.onRemove,
                  child:  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                    ),
                  ),
                ):const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
