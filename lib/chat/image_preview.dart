import 'package:flutter/material.dart';
import 'dart:io';

import 'package:xGPT/utils/strings.dart';

class ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback removeImage;
  final String? title;
  final bool? showIcon;

  const ImagePreview({super.key, this.image, this.showIcon, this.title, required this.removeImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.cyan[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image!=null? Image.file(
              image!,
              height: 150,
              width: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.cover,
            ): showIcon!=null && showIcon==true ? SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.72,
              child: Row(
                children: [
                  const SizedBox(width: 7,),
                  const Icon(
                    Icons.file_copy,
                    size: 20, // you might want to adjust this
                  ),
                  if(title!=null)...[
                    const SizedBox(width: 7,),
                    Text(truncateFilename(title!, 25))
                  ]
                ],
              ),
            ): const SizedBox.shrink(),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: removeImage,
            color: Colors.cyan[300],
            icon: const Icon(
              Icons.close,
              color: Colors.red,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
