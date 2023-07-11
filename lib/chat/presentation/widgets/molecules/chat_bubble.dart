import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xGPT/chat/presentation/callbacks/show_image.dart';
import 'package:xGPT/themes/theme.dart';
import 'package:xGPT/chat/presentation/widgets/atoms/chat_bubble.dart';

class AudioWidget extends StatelessWidget {
  final bool isPlaying;
  final bool isAudioLoading;
  final bool isError;
  final Function togglePlayback;
  final bool isUser;

  const AudioWidget({
    super.key,
    required this.isPlaying,
    required this.isAudioLoading,
    required this.isError,
    required this.togglePlayback,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isAudioLoading)
          LoadingIndicator(color: isUser ? Colors.white : Colors.black),
        if (isError) ErrorIcon(color: isUser ? Colors.white : Colors.black),
        if (!isAudioLoading && !isError)
          PlayPauseIcon(
              color: isUser ? Colors.white : Colors.black,
              isPlaying: isPlaying),
        // other widgets go here...
      ],
    );
  }
}

class ImageWidget extends StatelessWidget {
  final dynamic image;
  final ShowImageCallback showImage;

  const ImageWidget({super.key, required this.image, required this.showImage});

  @override
  Widget build(BuildContext context) {
    if (image == null) return const SizedBox.shrink();

    const fit = BoxFit.cover;
    final width = MediaQuery.of(context).size.width * 0.75;

    Widget? imageWidget;
    if (image is File) {
      imageWidget = ImageFile(image: image, width: width, fit: fit);
    }
    if (image is String) {
      imageWidget = CachedNetworkImage(
        imageUrl: image,
        width: width,
        fit: fit,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(
            Icons.error,
            color: Colors.red, // Change the color if needed
          ),
        ),
      );
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () => showImage(image),
          child: imageWidget,
        ));
  }
}

String textFormatter(String text) {
  if (text.contains("Sources:")) {
    text = text.replaceAll("Sources:", "\nSources:");
  }
  if (text.contains("Source:")) {
    text = text.replaceAll("Source:", "\nSource:");
  }
  return text;
}

class LinkifiedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle linkStyle;

  const LinkifiedText({
    super.key,
    required this.text,
    required this.style,
    required this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getLowerWidgetMargin(),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: SelectableLinkify(
        onOpen: (link) async {
          Uri uri = Uri.parse(link.url);

          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        text: textFormatter(text),
        style: style,
        linkStyle: linkStyle,
        selectionControls: MaterialTextSelectionControls(),

      ),
    );
  }
}

class AudioPlayerUI extends StatefulWidget {
  final String voiceCommand;
  final bool isUser;

  const AudioPlayerUI({
    super.key,
    required this.voiceCommand,
    required this.isUser,
  });

  @override
  AudioPlayerUIState createState() => AudioPlayerUIState();
}

class AudioPlayerUIState extends State<AudioPlayerUI> {
  FlutterSoundPlayer? _player;
  bool _isPlaying = false;

  bool _isAudioLoading = false;
  String? _audioErrorMessage;

  @override
  void initState() {
    super.initState();

    _player = FlutterSoundPlayer(logLevel: Level.nothing);
    _player!.openPlayer();
  }

  @override
  void dispose() {
    _player!.closePlayer();
    _player = null;
    super.dispose();
  }

  void _togglePlayback() async {
    setState(() {
      _isAudioLoading = true;
      _audioErrorMessage = null;
    });
    if (_isPlaying) {
      await _player!.stopPlayer();
    } else {
      try {
        await _player!
            .startPlayer(
          fromURI: widget.voiceCommand,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
            });
          },
        )
            .catchError((error) {
          setState(() {
            _audioErrorMessage = 'Error playing audio';
          });
          return const Duration(seconds: 15);
        });
      } catch (e, stackTrace) {
        debugPrint('stackTrace::$stackTrace');
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
      _isAudioLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: _togglePlayback,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isAudioLoading)
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isUser ? Colors.white : Colors.black),
                ),
              )
            else if (_audioErrorMessage != null)
              IconMessage(
                  icon: Icons.error,
                  color: widget.isUser ? Colors.white : Colors.black)
            else
              IconMessage(
                icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.isUser ? Colors.white : Colors.black,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                "Audio Message",
                style: TextStyle(
                  color: widget.isUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
