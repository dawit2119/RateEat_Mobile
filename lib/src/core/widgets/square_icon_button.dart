import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constants/constants.dart';

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.onTap,
    required this.iconData,
  });

  final GestureTapCallback onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.sp,
      width: 30.sp,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [...elevation_2, ...elevation_4],
      ),
      child: InkWell(
        splashColor: Colors.green,
        onTap: onTap,
        child: Center(
          child: Icon(
            iconData,
          ),
        ),
      ),
    );
  }
}
