import 'package:flutter/material.dart';

class TickAndText extends StatelessWidget {
  final String text;

  const TickAndText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Icon(Icons.check, color: Colors.green), // tick icon
        const SizedBox(width: 10), // space between icon and text
        Expanded(child: Text(text)),
      ],
    );
  }
}
