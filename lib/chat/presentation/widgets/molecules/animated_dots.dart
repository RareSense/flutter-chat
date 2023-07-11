import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:xGPT/chat/presentation/widgets/atoms/dot.dart';
import 'package:xGPT/themes/theme.dart';

class AnimatedDots extends StatefulWidget {
  const AnimatedDots({super.key});

  @override
  AnimatedDotsState createState() => AnimatedDotsState();
}

class AnimatedDotsState extends State<AnimatedDots>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late AnimationController _controller;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation1 = Tween<double>(begin: 0, end: 10).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    _animation2 = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.3,  //Start point
        1.0,  //End point
        curve: Curves.easeInOut,
      ),
    ));

    _animation3 = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.6,  //Start point
        1.0,  //End point
        curve: Curves.easeInOut,
      ),
    ));

    _controller.repeat(reverse: true);

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const CircularProgressIndicator();
    }
    return SizedBox(
      height: 40,
      width: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Transform.translate(
            offset: Offset(1, -_animation1.value),
            child: const Dot(size: 8.0, color: AppColors.primary),
          ),
          Transform.translate(
            offset: Offset(1, -_animation2.value),
            child: const Dot(size: 8.0, color: AppColors.primary),
          ),
          Transform.translate(
            offset: Offset(1, -_animation3.value),
            child: const Dot(size: 8.0, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
