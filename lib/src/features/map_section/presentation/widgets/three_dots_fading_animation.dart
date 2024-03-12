import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  LoadingDotsState createState() => LoadingDotsState();
}

class LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Adjust the Tween to change the opacity range
    _animations = List.generate(3, (index) {
      return Tween(begin: 0.3, end: 0.8).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.2 * index,
            0.2 * index + 0.4,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _animations.map((animation) {
        return FadeTransition(
          opacity: animation,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Dot(),
          ),
        );
      }).toList(),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.0,
      width: 15.0,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
