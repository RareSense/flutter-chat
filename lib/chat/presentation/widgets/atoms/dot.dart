
import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final double size;
  final Color color;

  const Dot({super.key,  required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
