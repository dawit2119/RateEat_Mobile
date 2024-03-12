import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/utils/walking_distance_checker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';
import '../../../currency_exchange/currency_exchange.dart';

class ItemResult extends StatelessWidget {
  final String id;
  final String imageUrl;
  final double rating;
  final String foodName;
  final String restaurantName;
  final double price;
  final int noOfReviews;
  final String ridingTime;
  final String walkingTime;
  final String distance;
  final String currency;
  const ItemResult({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.rating,
    required this.foodName,
    required this.restaurantName,
    required this.price,
    required this.noOfReviews,
    required this.ridingTime,
    required this.walkingTime,
    required this.distance,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final hasRating = (rating ?? 0) > 0;
    final hasReviews = (noOfReviews ?? 0) > 0;

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.itemDetail,
          pathParameters: {"itemId": id},
        );
      },
      splashColor: AppColors.lightBlueText,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 50.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0x146a737d),
              offset: Offset(0, 0),
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
                height: 16.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheHeight: (13.h).cacheSize(context),
                  progressIndicatorBuilder: (context, url, progress) =>
                      Shimmer.fromColors(
                    baseColor: AppColors.shimmerBaseColor,
                    highlightColor: AppColors.grey100,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),

            // spacing
            SizedBox(height: 1.h),

            // 2) Name + Price row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      foodName ?? "",
                      maxLines: (foodName?.split(" ").length ?? 1) > 1 ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: const Color(0xff24292e),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SmartCurrencyPriceWidget(
                    originalPrice: price?.toDouble() ?? 0.0,
                    originalCurrency: currency ?? 'USD',
                    priceStyle: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.7,
                      letterSpacing: 0.1,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: .5.h),

            // 3) Left: rating  |  Right: number of reviews
            Padding(
              padding: EdgeInsets.fromLTRB(2.w, 0, 2.w, 1.2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: star + rating
                  if (hasRating)
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.red,
                          size: 15.sp,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          rating.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff24292e),
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),

                  // Right side: reviews count
                  if (hasReviews)
                    Text(
                      '${noOfReviews} ${l10n.revText}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.28,
                        color: const Color(0xff586069),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Distance/Time badge - positioned at bottom right INSIDE container
                // if (walkingTime.isNotEmpty)
                //   Positioned(
                //     bottom: 0,
                //     right: 0,
                //     child: Container(
                //       constraints: BoxConstraints(
                //         maxWidth: 50.w, // Prevent overflow horizontally
                //       ),
                //       decoration: const BoxDecoration(
                //         color: Colors.black,
//         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(10),
                //           bottomRight: Radius.circular(12),
                //         ),
                //       ),
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 8,
                //         vertical: 4,
                //       ),
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Flexible(
                //             child: Text(
                //               "${double.parse(distance) < 1 ? (double.parse(distance) * 1000).toStringAsFixed(0) : double.parse(distance).toStringAsFixed(1)} ${double.parse(distance) < 1 ? AppLocalizations.of(context)!.meterText : AppLocalizations.of(context)!.kiloMeterText}",
                //               maxLines: 1,
                //               overflow: TextOverflow.ellipsis,
                //               style: GoogleFonts.poppins(
                //                 fontSize: 1.3.h,
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //           ),
                //           const SizedBox(width: 8),
                //           if (walkingTime.isNotEmpty &&
                //               !isFeasibleWalkingTime(walkingTime: walkingTime))
                //             Row(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 Icon(
                //                   Icons.directions_bus,
                //                   size: 1.4.h,
                //                   color: Colors.white,
                //                 ),
                //                 const SizedBox(width: 4),
                //                 Text(
                //                   ridingTime,
                //                   style: GoogleFonts.poppins(
                //                     fontSize: 1.3.h,
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w500,
                //                   ),
                //                 ),
                //               ],
                //             )
                //           else
                //             Row(
                //               mainAxisSize: MainAxisSize.min,
                //               children: [
                //                 Icon(
                //                   Icons.directions_walk,
                //                   size: 1.4.h,
                //                   color: Colors.white,
                //                 ),
                //                 const SizedBox(width: 4),
                //                 Text(
                //                   walkingTime,
                //                   style: GoogleFonts.poppins(
                //                     fontSize: 1.3.h,
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.w500,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //         ],
                //       ),
                //     ),
                //   ),