import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/utils/is_restaurant_open.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../features.dart';
import 'recommended_resturant_opening_widget.dart';

class RecommendedRestaurantWidget extends StatelessWidget {
  final RecommendedRestaurantEntity restaurant;

  const RecommendedRestaurantWidget({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantImages = restaurant.restaurantImages;
    var leadingImage = restaurantImages != null && restaurantImages.isNotEmpty
        ? restaurant.restaurantImages![0]['url']
        : "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg";
    if (restaurantImages != null) {
      for (var image in restaurantImages) {
        if (image['is_leading'] == true) {
          leadingImage = image['url'];
        }
      }
    }

    return InkWell(
      onTap: () {
        context.pushNamed(
          AppRoutes.restaurantDetail,
          pathParameters: {'restaurantId': restaurant.id!},
        );
      },
      splashColor: AppColors.lightBlueText,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        height: 32.h,
        padding: EdgeInsets.only(
          top: 1.w,
          right: 1.w,
          left: 1.w,
          bottom: 1.h,
        ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Image at the top
            SizedBox(
              height: 22.h,
              child: Container(
                width: 100.w,
                height: 10.5.h,
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
                  child: CachedNetworkImage(
                    imageUrl: leadingImage ??
                        "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg",
                    memCacheHeight: (9.5.h).cacheSize(context),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: AppColors.primaryColor,
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
            ),
            // Restaurant Name
            Flexible(
              child: Text(
                restaurant.name ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: semiBold16,
              ),
            ),
            const SizedBox(height: 6),
            // Location and Open Now Tag in a row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Location
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.location5,
                          color: AppColors.primaryColor,
                          size: 1.8.h,
                        ),
                        horizontalPadding(width: 1),
                        Expanded(
                          child: Text(
                            restaurant.restaurantLocations?[0].description ??
                                "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: medium14.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  horizontalPadding(width: .8),
                  // Open/Closed Tag
                  restaurant.isOpen ?? true
                      ? RecommendedRestaurantOpeningClosingTime(
                          restaurant: restaurant,
                        )
                      : Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                                size: 16
                                    .sp, // Slightly smaller for more inline feel
                              ),
                              SizedBox(width: 5), // tighter spacing
                              Text(
                                AppLocalizations.of(context)!
                                    .permanentlyClosedText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: medium14.copyWith(
                                  fontSize: 14.sp, // Match with status tags
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            // Rating only (no distance)
            const SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: AppColors.primaryColor,
                    size: 1.6.h,
                  ),
                  SizedBox(width: 0.6.h),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: restaurant.averageRating.toString(),
                          style: medium14.copyWith(
                            fontSize: 1.2.h,
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(text: " • "),
                        TextSpan(
                          text:
                              "(${restaurant.numberOfReviews} ${restaurant.numberOfReviews != 1 ? AppLocalizations.of(context)!.revText : AppLocalizations.of(context)!.reviewText})",
                          style: medium14.copyWith(
                            fontSize: 1.2.h,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
