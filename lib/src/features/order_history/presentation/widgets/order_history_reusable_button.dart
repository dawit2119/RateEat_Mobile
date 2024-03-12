import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHistoryReusableButton extends StatelessWidget {
  const OrderHistoryReusableButton(
      {super.key,
      this.onTap,
      required this.child,
      this.color = const Color(0xffFF3008)});
  final void Function()? onTap;
  final Widget child;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 7.h,
        width: 95.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffE91E05),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
