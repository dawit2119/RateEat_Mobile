import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemDescription extends StatelessWidget {
  final String desc;
  final List<Ingredient> ingredients;
  const ItemDescription(
      {super.key, required this.desc, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        desc != ""
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.descriptionText,
                    style: GoogleFonts.poppins(
                      fontSize: 16.2.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: const Color(0xff434343),
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Text(
                    desc,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: 0.28,
                      color: const Color(0xff565656),
                    ),
                  ),
                ],
              )
            : Container(),
        SizedBox(height: 1.h),
        ingredients.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.ingredientText,
                    style: GoogleFonts.poppins(
                      fontSize: 16.2.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      color: const Color(0xff434343),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    ingredients.map((ingredient) => ingredient.name).join(', '),
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
