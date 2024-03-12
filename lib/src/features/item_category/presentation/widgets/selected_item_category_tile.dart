import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectedItemCategoryTile extends StatelessWidget {
  final String categoryName;
  final Function() onTap;

  const SelectedItemCategoryTile({
    super.key,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 0,
          ),
          padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
          margin: EdgeInsets.only(right: 12.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primaryButtonColor,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                categoryName,
                style: GoogleFonts.poppins(
                  color: AppColors.primaryButtonColor,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.clear,
                color: AppColors.primaryButtonColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
