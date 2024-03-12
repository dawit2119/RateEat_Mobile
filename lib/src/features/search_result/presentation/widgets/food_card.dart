import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class FoodCard extends StatelessWidget {
  final String imageUrl;

  final double rating;
  final String foodName;
  final String restaurantName;
  final double price;
  final int noOfReviews;
  final VoidCallback ontap;

  const FoodCard({
    super.key,
    required this.imageUrl,
    required this.rating,
    required this.foodName,
    required this.restaurantName,
    required this.price,
    required this.noOfReviews,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        height: screenHeight * 0.28,
        width: screenWidth * 0.65,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: ontap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 18.h,
                        memCacheHeight: (18.h).cacheSize(context),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          );
                        },
                        progressIndicatorBuilder: (context, url, progress) =>
                            Shimmer.fromColors(
                          baseColor: AppColors.shimmerBaseColor,
                          highlightColor: AppColors.grey100,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            foodName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: const Color(0xff24292e),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '$price ${AppLocalizations.of(context)!.etbText}',
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              letterSpacing: 0.28,
                              color: const Color(0xFF59585D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalPadding(height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 2, 0, 0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.primaryColor,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "$rating/5",
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff24292e),
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          '($noOfReviews ${AppLocalizations.of(context)!.reviewsText})',
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff6a737d),
                          ),
                        )
                      ],
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
