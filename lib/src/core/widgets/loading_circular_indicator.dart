import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoadingCircularIndicator extends StatelessWidget {
  final double? size;
  final Color color;
  final String text;
  const LoadingCircularIndicator({
    super.key,
    this.size,
    this.color = Colors.black,
    this.text = "Loading your map",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size ?? 23.sp,
            width: size ?? 23.sp,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
