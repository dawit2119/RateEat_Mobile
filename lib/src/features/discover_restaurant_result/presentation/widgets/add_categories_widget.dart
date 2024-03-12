import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class AddCategories extends StatelessWidget {
  const AddCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the add page
        context.pushNamed(AppRoutes.selectFoodCategory);
      },
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: AppColors.primaryButtonColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryButtonColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)!.moreText,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
