import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestaurantDottedBorder extends StatelessWidget {
  final String title;
  const RestaurantDottedBorder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          // Changed from RectDottedBorderOptions
          padding: EdgeInsets.zero,
          // borderType removed - not needed
          color: AppColors.primaryColor,
          dashPattern: const [6],
          radius: const Radius.circular(11), // Now works correctly
          strokeWidth: 2,
        ),
        child: ListTile(
          onTap: () {},
          tileColor: AppColors.primaryColor.withOpacity(.02),
          splashColor: AppColors.primaryColor.withOpacity(.1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.sp)),
          leading: Container(
            width: 10.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.iconBackground,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 6.sp, top: 6.sp, bottom: 6.sp, right: 6.sp),
              child: SvgPicture.asset(
                "assets/icons/search_result.svg",
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
                height: 1.1.h,
                width: 1.1.h,
              ),
            ),
          ),
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
