import 'package:flutter/material.dart';

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final double borderRadius;
  final double horizontalMargin;
  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
    this.child,
    this.horizontalMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: horizontalMargin),
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.all(
          Radius.circular(
            borderRadius,
          ),
        ),
      ),
      child: child,
    );
  }
}
