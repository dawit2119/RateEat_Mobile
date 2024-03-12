import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RatingReviewWidget extends StatelessWidget {
  final double rating;
  final int noOfReviews;
  final void Function()? onTap;
  const RatingReviewWidget({
    super.key,
    required this.rating,
    required this.noOfReviews,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.9.h, horizontal: 2.5.w),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // 👈 keep row tight
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Iconsax.star1,
                size: 17.5.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                rating.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                  color: const Color(0xff000000),
                ),
              ),
              SizedBox(
                width: .9.w,
              ),
              Text(
                '($noOfReviews ${noOfReviews != 1 ? AppLocalizations.of(context)!.revText : AppLocalizations.of(context)!.reviewText})',
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
