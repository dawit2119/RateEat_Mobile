import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({
    super.key,
    this.onTap,
    required this.child,
    this.color = const Color(0xffFF3008),
    this.shadowColor = AppColors.primaryColor,
  });
  final void Function()? onTap;
  final Widget child;
  final Color color;
  final Color shadowColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 1.8.h,
          horizontal: 4.w,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
