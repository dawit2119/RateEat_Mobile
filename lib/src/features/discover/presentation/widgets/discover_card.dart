import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';

class DiscoverCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgUrl;
  final GestureTapCallback onTap;
  const DiscoverCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sp),
      child: Ink(
        height: 19.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: elevation_4,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          splashColor: AppColors.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        style: titleTextStyle.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      verticalPadding(height: 1),
                      Text(
                        subtitle,
                        style: subTitleTextStyle.copyWith(
                          color: AppColors.grey500,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SvgPicture.asset(
                  height: 16.h,
                  width: 16.h,
                  svgUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
