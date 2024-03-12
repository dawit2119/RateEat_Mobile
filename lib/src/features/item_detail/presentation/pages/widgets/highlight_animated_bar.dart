import 'package:flutter/material.dart';

class AnimatedBar extends StatelessWidget {
  final int position;
  final int currentIndex;
  // final AnimationController animationController;
  final int animationDuration = 300;

  const AnimatedBar({
    super.key,
    // required this.animationController,
    required this.position,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (position == currentIndex) {
              return AnimatedContainer(
                duration: Duration(milliseconds: animationDuration),
                width: 20,
                height: 5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white),
              );
            } else if (currentIndex - position == 1 ||
                position - currentIndex == 1) {
              return AnimatedContainer(
                duration: Duration(milliseconds: animationDuration),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
              );
            } else if (currentIndex - position == 2 ||
                position - currentIndex == 2) {
              return AnimatedContainer(
                duration: Duration(milliseconds: animationDuration),
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
              );
            } else if (currentIndex - position == 3 ||
                position - currentIndex == 3) {
              return AnimatedContainer(
                duration: Duration(milliseconds: animationDuration),
                width: 1.8,
                height: 1.8,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
              );
            } else {
              return Container(
                width: 0,
              );
            }
          },
        ),
      ),
    );
  }
}
