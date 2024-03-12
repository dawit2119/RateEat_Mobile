import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_item_response_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../map_section/data/models/restaurant_model.dart';

class DraftReviewInfoCard extends StatelessWidget {
  final SavedReviewItemResponseModel? item;
  final RestaurantModel? restaurant;
  const DraftReviewInfoCard({super.key, this.item, this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 12.h,
            height: 12.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item != null
                    ? item!.imageUrl.toString()
                    : restaurant!.restaurantImages!.isEmpty
                        ? "https://plus.unsplash.com/premium_photo-1686090448301-4c453ee74718?auto=format&fit=crop&q=80&w=1374&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                        : restaurant!.restaurantImages!.first.url,
                memCacheHeight: (12.h).cacheSize(context),
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.error,
                  ),
                ),
              ),
            ),
          ),
          horizontalPadding(width: 2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalPadding(height: 1),
                Text(
                  (item != null)
                      ? item!.itemName
                      : (restaurant != null && restaurant!.name != null)
                          ? restaurant!.name!
                          : "Item/Restaurant name",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: medium18,
                ),
                verticalPadding(height: 1),
                Row(
                  children: [
                    // const Icon(
                    //   Iconsax.dollar_circle,
                    //   color: Colors.green,
                    // ),
                    // horizontalPadding(width: 1),
                    // Text(
                    //   (item != null)
                    //       ? item!.price.toString()
                    //       : (restaurant != null)
                    //           ? restaurant!.averageRating.toString()
                    //           : "Failed to get price",
                    //   style: semiBold16.copyWith(color: AppColors.primaryColor),
                    // ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
