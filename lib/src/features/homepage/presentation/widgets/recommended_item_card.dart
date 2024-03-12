import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/utils/walking_distance_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/item.dart';

class RecommendedItemCard extends StatelessWidget {
  final Item item;

  const RecommendedItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.itemDetail,
          pathParameters: {"itemId": item.itemId},
        );
      },
      child: Container(
        height: 32.h,
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        width: 100.w,
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
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
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x146a737d),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Stack(
                  children: [
                    //* Item Image
                    (item.imageUrl ?? "").isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: item.imageUrl!,
                            width: 100.w,
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
                            progressIndicatorBuilder:
                                (context, url, progress) => Shimmer.fromColors(
                              baseColor: AppColors.shimmerBaseColor,
                              highlightColor: AppColors.grey100,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            width: 100.w,
                            height: 18.h,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.restaurant,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ),
                          ),
                    //*Restaurant Name
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 60.w),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          item.restaurantName!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    //* Walking and Driving Distance
                    if (item.walkingTime != "")
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: .5.h,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              !isFeasibleWalkingTime(
                                      walkingTime: item.walkingTime)
                                  ? Row(
                                      children: [
                                        const Icon(
                                          Icons.directions_bus,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          item.ridingTime,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        const Icon(
                                          Icons.directions_walk,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          item.walkingTime,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: .7.h),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 64.w,
                    child: Text(
                      item.itemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontSize: 2.h,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: const Color(0xff24292e),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  (item.isOpen!) ? Colors.green : Colors.red),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: (item.isOpen!)
                            ? Container(
                                width: 6.w,
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)!.openText,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              )
                            : Container(
                                width: 6.w,
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)!.closedText,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalPadding(height: 1),
            Container(
              padding: EdgeInsets.only(left: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.tags!.isNotEmpty
                      ? SizedBox(
                          width: 100.w - 24,
                          height: 28,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: item.tags!.length,
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
                                  item.tags![index],
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
                  verticalPadding(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(width: .4.w),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 1.3.h,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff24292e),
                          ),
                          children: [
                            TextSpan(
                              text: item.averageRating.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                                text:
                                    " (${item.numberOfReviews} ${AppLocalizations.of(context)!.reviewsText})",
                                style: const TextStyle(
                                  color: Color(0xFF586069),
                                )),
                            WidgetSpan(
                              child: SizedBox(
                                  width: 2.w), // Add space between text spans
                            ),
                            const TextSpan(
                                text: " . ",
                                style: TextStyle(
                                  color: Color(0xFF586069),
                                )),
                            WidgetSpan(
                              child: SizedBox(
                                  width: 2.w), // Add space between text spans
                            ),
                            TextSpan(
                              text: "${item.price}ETB ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!
                                  .averagePriceText,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF586069),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
