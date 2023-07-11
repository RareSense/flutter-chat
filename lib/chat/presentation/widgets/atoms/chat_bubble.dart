import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:xGPT/themes/theme.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}

class ErrorIcon extends StatelessWidget {
  final Color color;

  const ErrorIcon({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.error,
      color: color,
    );
  }
}

class PlayPauseIcon extends StatelessWidget {
  final Color color;
  final bool isPlaying;

  const PlayPauseIcon(
      {super.key, required this.color, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Icon(
      isPlaying ? Icons.pause : Icons.play_arrow,
      color: color,
    );
  }
}

class MessageText extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageText({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isUser ? Colors.white : Colors.black,
        fontSize: 17,
      ),
    );
  }
}

EdgeInsets getLowerWidgetMargin() {
  return const EdgeInsets.only(left: 5, right: 5);
}

class FormattedDate extends StatelessWidget {
  final String date;
  final Color color;

  const FormattedDate({super.key, required this.date, required this.color});

  @override
  Widget build(BuildContext context) {
    var messageTime = DateTime.parse(date);
    var timeAgo = timeago.format(messageTime, locale: 'en_short');

    return Container(
      margin: getLowerWidgetMargin() + const EdgeInsets.only(top: 5.0),
      child: Text(
        timeAgo,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: color, // adjust as per your design
          fontSize: 12,
        ),
      ),
    );
  }
}

class ImageFile extends StatelessWidget {
  final File image;
  final double width;
  final BoxFit fit;

  const ImageFile(
      {super.key,
      required this.image,
      required this.width,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      image,
      width: width,
      fit: fit,
    );
  }
}

class ImageNetwork extends StatelessWidget {
  final String imageUrl;
  final double width;
  final BoxFit fit;

  const ImageNetwork(
      {super.key,
      required this.imageUrl,
      required this.width,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      fit: fit,
      imageUrl: imageUrl,
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error, color: Colors.red)),
    );
  }
}

class FileIcon extends StatelessWidget {
  const FileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.file_copy,
      size: 100,
      color: Colors.white70,
    );
  }
}

class IconMessage extends StatelessWidget {
  final IconData icon;
  final Color color;

  const IconMessage({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color);
  }
}
