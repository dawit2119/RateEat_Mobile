import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class FoodCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final double rating;
  final String foodName;
  final String restaurantName;
  final String currencyCode;
  final double price;
  final int noOfReviews;
  final List<String>? tags;

  const FoodCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.rating,
    required this.foodName,
    required this.restaurantName,
    required this.price,
    required this.noOfReviews,
    required this.currencyCode,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Container(
        width: screenWidth * 0.54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 2),
              blurRadius: 8,
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
              // * goto item details page

              context.pushNamed(
                AppRoutes.itemDetail,
                pathParameters: {"itemId": id},
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        memCacheHeight: (120).cacheSize(context),
                        memCacheWidth: (120).cacheSize(context),
                        imageUrl: imageUrl.isNotEmpty
                            ? imageUrl
                            : 'https://storage.googleapis.com/rateeat_bucket/RateEat/ItemImagesUpdated/1734682325169-high.webp',
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person,
                            ),
                            verticalPadding(height: 1),
                            Text(
                              "Unable to load\n image",
                              textAlign: TextAlign.center,
                              style: subTitleTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalPadding(height: 1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          foodName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        // price
                        child: Text(
                          '$price $currencyCode',
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalPadding(height: 1),
                  tags != null
                      ? SizedBox(
                          width: 100.w - 24,
                          height: 28,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: tags!.length,
                            itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  tags![index],
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.tagNotAvailableText,
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                  verticalPadding(height: 1),
                  Row(
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
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '($noOfReviews ${AppLocalizations.of(context)!.reviewsText})',
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey400,
                        ),
                      )
                    ],
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
