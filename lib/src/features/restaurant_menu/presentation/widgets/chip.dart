import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/constants.dart';

class Chips extends StatelessWidget {
  final bool isSelected;
  final String label;
  const Chips({
    super.key,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        color: isSelected ? AppColors.primaryColor : AppColors.grey100,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 10.sp),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : AppColors.grey500,
          ),
        ),
      ),
    );
  }
}
