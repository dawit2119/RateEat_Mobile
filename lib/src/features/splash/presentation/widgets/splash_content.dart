import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    required this.title,
    required this.imagePath,
    required this.detailInfo,
  });
  final String title, imagePath, detailInfo;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Spacer(flex: 3),
      Image.asset(
        imagePath,
        height: 50.h,
        width: 320,
        fit: BoxFit.cover,
      ),
      const Spacer(),
      Text(
        title,
        style: GoogleFonts.poppins(
          color: AppColors.secondaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 3.h,
        ),
      ),
      SizedBox(
        height: 1.h,
      ),
      Text(detailInfo,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.w400,
            fontSize: 2.3.h,
          )),
      const Spacer(
        flex: 3,
      ),
    ]);
  }
}
