import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestaurantNameDottedBorder extends StatelessWidget {
  final String title;
  const RestaurantNameDottedBorder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      width: 60.w,
      child: Center(
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 2.h,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}
