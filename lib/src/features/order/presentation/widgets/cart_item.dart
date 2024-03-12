import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/utils/walking_distance_checker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';

class CartItem extends StatelessWidget {
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
  final String currencyCode;
  const CartItem({
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
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Container(
        width: double.infinity,
        height: 11.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              context.pushNamed(
                AppRoutes.itemDetail,
                pathParameters: {'itemId': id},
              );
            },
            child: Stack(
              children: [
                Positioned(
                  bottom: -3,
                  right: 0,
                  child: Container(
                    height: 3.h,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${double.parse(distance) < 1 ? (double.parse(distance) * 1000).toStringAsFixed(0) : double.parse(distance).toStringAsFixed(1)} ${double.parse(distance) < 1 ? AppLocalizations.of(context)!.meterText : AppLocalizations.of(context)!.kiloMeterText}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 1.3.h,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const SizedBox(
                            width: 2,
                          ),
                          !isFeasibleWalkingTime(walkingTime: walkingTime)
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.directions_bus,
                                      size: 1.4.h,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 1,
                                    ),
                                    Text(
                                      ridingTime,
                                      style: GoogleFonts.poppins(
                                        fontSize: 1.3.h,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Icon(
                                      Icons.directions_walk,
                                      size: 1.4.h,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 1,
                                    ),
                                    Text(
                                      walkingTime,
                                      style: GoogleFonts.poppins(
                                        fontSize: 1.3.h,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 20.w,
                            height: 20.w,
                            // memCacheHeight: (20.w).cacheSize(context),
                            memCacheWidth: (20.w).cacheSize(context),
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
                                Text(
                                  AppLocalizations.of(context)!.loadImageError,
                                  textAlign: TextAlign.center,
                                  style: subTitleTextStyle,
                                ),
                              ],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            verticalPadding(height: .6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: SizedBox(
                                    width: 48.w,
                                    child: Text(
                                      foodName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1.5,
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      '${price.toInt()} $currencyCode',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 2, 5, 2),
                                  child: Transform.rotate(
                                    angle: 0.8,
                                    child: Icon(
                                      Icons.push_pin,
                                      size: 1.7.h,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 57.w,
                                  child: Text(
                                    restaurantName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.sp,
                                      height: 1.5,
                                      color: AppColors.grey700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 5,
                                        ),
                                        child: Icon(
                                          Icons.star_rounded,
                                          color: AppColors.primaryColor,
                                          size: 15.sp,
                                        ),
                                      ),
                                      Text(
                                        "$rating/5 ",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff24292e),
                                        ),
                                      ),
                                      Text(
                                        '($noOfReviews ${AppLocalizations.of(context)!.ratingText})',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.grey500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
