import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';

class RestaurantServiceCard extends StatelessWidget {
  const RestaurantServiceCard({
    super.key,
    required this.title,
    required this.info,
    required this.iconPath,
    this.onTap,
    this.leftWidget,
    this.restaurant,
    this.showDivider = true,
  });
  final String title;
  final String info;
  final String iconPath;
  final Widget? leftWidget;
  final bool showDivider;
  final GestureTapCallback? onTap;
  final RestaurantModel? restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   title,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 16.sp,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.grey700,
                    //   ),
                    // ),
                    // SizedBox(height: .6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (leftWidget != null) leftWidget!,
                        if (leftWidget != null) horizontalPadding(width: 1),
                        SizedBox(
                          width: 35.w,
                          child: Text(
                            info,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey600,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 2.w,
                ),
                SizedBox(
                  height: 2.h,
                  width: 2.h,
                  child: SvgPicture.asset(iconPath),
                ),
              ],
            ),
            verticalPadding(height: 2.sp),
            if (showDivider)
              Divider(
                thickness: 1,
                indent: 12.sp,
                endIndent: 12.sp,
                color: AppColors.grey200,
              ),
          ],
        ),
      ),
    );
  }
}
