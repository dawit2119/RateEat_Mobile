import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CancelOrderDisplayWidget extends StatelessWidget {
  const CancelOrderDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20.h,
          width: 88.w,
          padding: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEDCCB4),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Order has been canceled",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "The restaurant canceled the order",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: const Color(0xffBD6320),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -4.h,
                child: SvgPicture.asset(
                  "assets/icons/search_result.svg",
                  height: 15.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Center(
          child: Text(
            "Order was canceled",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
