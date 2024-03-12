import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class GotoAllMenusCard extends StatelessWidget {
  final String restaurantId;

  const GotoAllMenusCard({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        height: screenHeight * 0.23,
        width: screenWidth * 0.38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 2),
              blurRadius: 8,
              // spreadRadius: 10,
            ),
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // * goto restaurant details page / better togo to menu page
              context.pushNamed(
                AppRoutes.restaurantDetail,
                pathParameters: {'restaurantId': restaurantId},
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.textDark,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/plus_2.svg",
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                  verticalPadding(height: 1),
                  Text(
                    AppLocalizations.of(context)!.seeAllItemsText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  verticalPadding(height: 1),
                  TextButton(
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.primaryColor.withOpacity(.1),
                      ),
                      overlayColor: WidgetStatePropertyAll(
                        AppColors.primaryColor.withOpacity(.2),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed(
                        AppRoutes.restaurantDetail,
                        pathParameters: {'restaurantId': restaurantId},
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.visitPlaceText,
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
